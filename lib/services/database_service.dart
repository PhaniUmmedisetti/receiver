import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_strings.dart';
import '../models/file.dart';
import 'package:flutter/material.dart';

class DatabaseService extends GetxService {
  final SupabaseClient client = Supabase.instance.client;
  final files = <UploadedFile>[].obs;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    fetchFiles();
    _subscribeToChanges();
  }

  Future<void> fetchFiles() async {
    try {
      final response = await client
          .from(AppStrings.filesTable)
          .select()
          .order('created_at', ascending: false);

      if (kDebugMode) {
        print('Raw Supabase response: $response');
      }

      if (response.isEmpty) {
        if (kDebugMode) {
          print('No files found in Supabase.');
        }
        files.value = [];
        return;
      }

      files.value = (response as List<dynamic>)
          .map((e) => UploadedFile.fromJson(e as Map<String, dynamic>))
          .toList();

      if (kDebugMode) {
        print('Parsed files: ${files.map((file) => file.toJson())}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching files: $e');
      }
      Get.snackbar(
        'Error',
        'Failed to fetch files: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
  }

  void _subscribeToChanges() {
    try {
      _subscription = client
          .from(AppStrings.filesTable)
          .stream(primaryKey: ['id'])
          .listen((List<Map<String, dynamic>> data) {
        if (kDebugMode) {
          print('Real-time update received: $data');
        }
        if (data.isNotEmpty) {
          files.value = data
              .map((e) => UploadedFile.fromJson(e))
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          if (kDebugMode) {
            print('Updated files: ${files.map((file) => file.toJson())}');
          }
        }
      }, onError: (error) {
        if (kDebugMode) {
          print('Real-time subscription error: $error');
        }
        // Don't show snackbar for real-time errors to avoid spamming the user
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error setting up real-time subscription: $e');
      }
      // Fall back to manual fetching if real-time fails
      fetchFiles();
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}