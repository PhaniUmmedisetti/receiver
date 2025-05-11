import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'routes/routes.dart';
import 'constants/app_strings.dart';
import 'controllers/language_controller.dart';
import 'services/database_service.dart';
import 'services/location_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<LocationService>(LocationService());
    Get.put<DatabaseService>(DatabaseService());
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppStrings.supabaseUrl,
    anonKey: AppStrings.supabaseAnonKey,
  );

  await GetStorage.init();

  Get.put<LanguageController>(LanguageController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    if (languageController == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error: Unable to initialize app')),
        ),
      );
    }

    return Obx(
      () => GetMaterialApp(
        title: 'Receiver App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: languageController.locale.value,
        initialRoute: AppRoutes.main,
        getPages: AppRoutes.getPages,
        defaultTransition: Transition.zoom,
        initialBinding: AppBindings(),
      ),
    );
  }
}