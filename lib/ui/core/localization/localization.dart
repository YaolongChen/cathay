import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalization {
  static AppLocalization of(BuildContext context) {
    return Localizations.of(context, AppLocalization);
  }

  static const _string = <String, String>{
    'homeTitle': 'Home',
    'loginTitle': 'Login',
  };

  static String _get(String label) => _string[label] ?? label;

  String get homeTitle => _get('homeTitle');

  String get loginTitle => _get('loginTitle');
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'en';
  }

  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture(AppLocalization());
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) {
    return false;
  }
}
