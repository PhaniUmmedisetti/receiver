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

      if (kDebugMode) {}

      if (response.isEmpty) {
        if (kDebugMode) {}
        files.value = [];
        return;
      }

      files.value = (response as List<dynamic>)
          .map((e) => UploadedFile.fromJson(e as Map<String, dynamic>))
          .toList();

      if (kDebugMode) {}
    } catch (e) {
      if (kDebugMode) {}
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
          .stream(primaryKey: ['id']).listen((List<Map<String, dynamic>> data) {
        if (kDebugMode) {}
        if (data.isNotEmpty) {
          files.value = data.map((e) => UploadedFile.fromJson(e)).toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          if (kDebugMode) {}
        }
      }, onError: (error) {
        if (kDebugMode) {}
        // Don't show snackbar for real-time errors to avoid spamming the user
      });
    } catch (e) {
      if (kDebugMode) {}
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
