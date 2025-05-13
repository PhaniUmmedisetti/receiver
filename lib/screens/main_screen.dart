import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../routes/routes.dart';
import '../widgets/language_switcher.dart';
import '../constants/app_colors.dart';
import '../controllers/language_controller.dart';
import '../localization/app_translations.dart';
import '../services/database_service.dart';
import '../services/location_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final DatabaseService databaseService = Get.find<DatabaseService>();
  final LocationService locationService = Get.find<LocationService>();
  final LanguageController languageController = Get.find<LanguageController>();
  Position? userLocation;
  final double geofenceLatitude = 17.385044; // Example: Hyderabad
  final double geofenceLongitude = 78.486671;
  final double geofenceRadius = 5000; // 5km radius
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserLocation();
    fetchFiles();
  }

  Future<void> fetchUserLocation() async {
    try {
      final position = await locationService.getCurrentLocation();
      if (position != null) {
        setState(() {
          userLocation = position;
          if (kDebugMode) {}
        });
      }
    } catch (e) {
      if (kDebugMode) {}
      Get.snackbar(
        'Error',
        'Failed to fetch user location: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
  }

  Future<void> fetchFiles() async {
    setState(() {
      isLoading = true;
    });
    await databaseService.fetchFiles();
    setState(() {
      isLoading = false;
    });
  }

  // bool _isWithinGeofence(UploadedFile file) {
  //   if (userLocation == null ||
  //       file.latitude == null ||
  //       file.longitude == null) {
  //     if (kDebugMode) {}
  //     return false;
  //   }

  //   try {
  //     double fileLat = file.latitude ?? 0;
  //     double fileLon = file.longitude ?? 0;
  //     double distance = Geolocator.distanceBetween(
  //       userLocation!.latitude,
  //       userLocation!.longitude,
  //       fileLat,
  //       fileLon,
  //     );
  //     if (kDebugMode) {}
  //     return distance <= geofenceRadius;
  //   } catch (e) {
  //     if (kDebugMode) {}
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            AppTranslations.translate(
                'appTitle', languageController.locale.value),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF2196F3),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: fetchFiles,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: LanguageSwitcher(),
            ),
          ],
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
            child: Obx(
              () {
                if (kDebugMode) {}

                final filteredFiles = databaseService.files
                    // .where((file) => _isWithinGeofence(file)) // Temporarily disabled geofencing
                    .toList();

                if (kDebugMode) {}

                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (filteredFiles.isEmpty) {
                  return Center(
                    child: Text(
                      AppTranslations.translate(
                          'noFiles', languageController.locale.value),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filteredFiles.length,
                  itemBuilder: (context, index) {
                    final file = filteredFiles[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: Icon(
                          _getFileIcon(file.name),
                          color: AppColors.primaryColor,
                          size: 30,
                        ),
                        title: Text(
                          file.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '${AppTranslations.translate('uploadedAt', languageController.locale.value)}: ${file.createdAt.toLocal().toString().split('.')[0]}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.info_outline,
                          color: AppColors.primaryColor,
                        ),
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.fileDetails,
                            arguments: {'file': file},
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    if (extension == 'pdf') {
      return Icons.picture_as_pdf;
    } else if (['jpg', 'jpeg', 'png'].contains(extension)) {
      return Icons.image;
    }
    return Icons.insert_drive_file;
  }
}
