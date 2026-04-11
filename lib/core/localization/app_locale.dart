import 'package:flutter/material.dart';
import 'arabic_font_loader.dart';

class AppLocaleController {
  AppLocaleController._();

  static final ValueNotifier<Locale> locale = ValueNotifier(const Locale('en'));

  static bool get isArabic => locale.value.languageCode == 'ar';

  static Future<void> toggleLanguage() async {
    if (isArabic) {
      locale.value = const Locale('en');
      return;
    }

    await ArabicFontLoader.ensureLoaded();
    locale.value = const Locale('ar');
  }

  static Future<void> setArabic() async {
    await ArabicFontLoader.ensureLoaded();
    locale.value = const Locale('ar');
  }
}

extension AppLocaleX on BuildContext {
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  String t(String en, String ar) => isArabic ? ar : en;
}
