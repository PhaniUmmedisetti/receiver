import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class LocationService extends GetxService {
  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'Location Error',
          'Location services are disabled.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
        return null;
      }

      PermissionStatus permission = await Permission.location.request();
      if (permission != PermissionStatus.granted) {
        Get.snackbar(
          'Permission Denied',
          'Location permission is required to use this feature.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch location: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      return null;
    }
  }
}