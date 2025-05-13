import 'dart:io';

import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class AppController extends GetxController {
  Future<String?> downloadFile(String url, String fileName) async {
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

  Future<void> handleFileAction(
      String url, String fileName, String action) async {
    final filePath = await downloadFile(url, fileName);
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
}
