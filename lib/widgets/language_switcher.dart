import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/language_controller.dart';
import '../constants/app_colors.dart';
import '../localization/app_translations.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    // if (languageController == null) {
    //   return const SizedBox.shrink();
    // }

    return Obx(
      () => DropdownButton<Locale>(
        value: languageController.locale.value,
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            languageController.changeLanguage(newLocale);
          }
        },
        items: const [
          DropdownMenuItem(
            value: Locale('en'),
            child: Text(
              'English',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          DropdownMenuItem(
            value: Locale('hi'),
            child: Text(
              'हिन्दी',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          DropdownMenuItem(
            value: Locale('te'),
            child: Text(
              'తెలుగు',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
        hint: Text(
          AppTranslations.translate('language', languageController.locale.value),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        underline: const SizedBox(),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        dropdownColor: AppColors.primaryColor,
      ),
    );
  }
}