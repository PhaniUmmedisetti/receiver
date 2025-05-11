import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  var locale = const Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    String? savedLanguage = GetStorage().read('language');
    if (savedLanguage != null) {
      locale.value = Locale(savedLanguage);
    }
  }

  void changeLanguage(Locale newLocale) {
    locale.value = newLocale;
    GetStorage().write('language', newLocale.languageCode);
    Get.updateLocale(newLocale);
  }
}