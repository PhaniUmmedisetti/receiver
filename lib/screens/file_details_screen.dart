import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import '../constants/app_colors.dart';
import '../controllers/language_controller.dart';
import '../localization/app_translations.dart';
import '../models/file.dart';

class FileDetailsScreen extends StatelessWidget {
  const FileDetailsScreen({super.key});

  Future<String?> _downloadFile(String url, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      if (await file.exists()) {
        return filePath;
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);

        if (await file.exists()) {
          return filePath;
        } else {
          Get.snackbar(
            'Error',
            'File was downloaded but cannot be found on disk.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black,
          );
          return null;
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to download file: HTTP ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to download file: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      return null;
    }
  }

  Future<void> _handleFileAction(
      String url, String fileName, String action) async {
    final filePath = await _downloadFile(url, fileName);
    if (filePath != null) {
      if (action == 'view') {
        final result = await OpenFile.open(filePath);

        if (result.type != ResultType.done) {
          Get.snackbar(
            'Error',
            'Failed to $action file: ${result.message}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black,
          );
        } else {
          Get.snackbar(
            'Success',
            'File viewed successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black,
          );
        }
      } else if (action == 'download') {
        // Step 1: Save to gallery

        try {
          await FlutterImageGallerySaver.saveFile(filePath);

          Get.snackbar(
            'Success',
            'File downloaded and saved to gallery!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black,
            duration: const Duration(seconds: 5),
          );
        } catch (e) {
          Get.snackbar(
            'Success (Limited)',
            'File downloaded but failed to save to gallery: $e\nFile is available at: $filePath',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black,
            duration: const Duration(seconds: 5),
          );
        }

        // Step 2: Open the file after saving

        final result = await OpenFile.open(filePath);

        if (result.type != ResultType.done) {
          Get.snackbar(
            'Error',
            'Failed to view file after download: ${result.message}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: Colors.black,
          );
        } else {}
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController =
        Get.find<LanguageController>();
    final arguments = Get.arguments;
    final UploadedFile? file = arguments != null ? arguments['file'] : null;

    if (file == null) {
      return const Scaffold(
        body: Center(child: Text('Error: Unable to initialize screen')),
      );
    }

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            AppTranslations.translate(
                'fileDetails', languageController.locale.value),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF2196F3),
          elevation: 0,
        ),
        extendBodyBehindAppBar: false,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2196F3),
                Color(0xFFBBDEFB),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 5,
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppTranslations.translate('fileName', languageController.locale.value)}: ${file.name}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${AppTranslations.translate('uploadedAt', languageController.locale.value)}: ${file.createdAt.toLocal().toString().split('.')[0]}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${AppTranslations.translate('location', languageController.locale.value)}: ${file.latitude != null && file.longitude != null ? '${file.latitude}, ${file.longitude}' : 'Not available'}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _handleFileAction(file.url, file.name, 'view');
                        },
                        icon: const Icon(Icons.visibility, size: 24),
                        label: Text(
                          AppTranslations.translate(
                              'viewButton', languageController.locale.value),
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _handleFileAction(
                              file.url, file.name, 'download');
                        },
                        icon: const Icon(Icons.download, size: 24),
                        label: Text(
                          AppTranslations.translate('downloadButton',
                              languageController.locale.value),
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
