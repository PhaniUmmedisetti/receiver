import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receiver/controllers/app_controller.dart';

import '../constants/app_colors.dart';
import '../controllers/language_controller.dart';
import '../localization/app_translations.dart';
import '../models/file.dart';

class FileDetailsScreen extends StatelessWidget {
  const FileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController =
        Get.find<LanguageController>();
    final AppController appController = Get.find<AppController>();
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
                          await appController.handleFileAction(
                              file.url, file.name, 'view');
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
                          await appController.handleFileAction(
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
