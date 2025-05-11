import 'package:flutter/material.dart';

class AppTranslations {
  static const supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('te'),
  ];

  static const _translations = {
    'en': {
      'appTitle': 'Receiver App',
      'filesTab': 'Files',
      'noFiles': 'No files available.',
      'downloadButton': 'Download',
      'viewButton': 'View',
      'fileDetails': 'File Details',
      'fileName': 'File Name',
      'uploadedAt': 'Uploaded At',
      'location': 'Location',
      'language': 'Language',
      'refresh': 'Refresh',
    },
    'hi': {
      'appTitle': 'रिसीवर ऐप',
      'filesTab': 'फ़ाइलें',
      'noFiles': 'कोई फ़ाइल उपलब्ध नहीं।',
      'downloadButton': 'डाउनलोड करें',
      'viewButton': 'देखें',
      'fileDetails': 'फ़ाइल विवरण',
      'fileName': 'फ़ाइल का नाम',
      'uploadedAt': 'अपलोड किया गया',
      'location': 'स्थान',
      'language': 'भाषा',
      'refresh': 'ताज़ा करें',
    },
    'te': {
      'appTitle': 'రిసీవర్ యాప్',
      'filesTab': 'ఫైళ్లు',
      'noFiles': 'ఏ ఫైళ్లు అందుబాటులో లేవు।',
      'downloadButton': 'డౌన్‌లోడ్ చేయండి',
      'viewButton': 'చూడండి',
      'fileDetails': 'ఫైల్ వివరాలు',
      'fileName': 'ఫైల్ పేరు',
      'uploadedAt': 'అప్‌లోడ్ చేసిన సమయం',
      'location': 'స్థానం',
      'language': 'భాష',
      'refresh': 'రిఫ్రెష్ చేయండి',
    },
  };

  static String translate(String key, Locale locale) {
    final languageCode = locale.languageCode;
    return _translations[languageCode]?[key] ?? _translations['en']![key]!;
  }
}