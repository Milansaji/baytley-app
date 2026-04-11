import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

class ArabicFontLoader {
  ArabicFontLoader._();

  static const Duration _minLoaderDuration = Duration(seconds: 3);

  static final ValueNotifier<bool> isLoading = ValueNotifier(false);
  static bool _isLoaded = false;

  static bool get isLoaded => _isLoaded;

  static Future<void> ensureLoaded() async {
    if (_isLoaded) return;

    final startedAt = DateTime.now();
    isLoading.value = true;
    try {
      await GoogleFonts.pendingFonts([
        GoogleFonts.cairo(),
        GoogleFonts.tajawal(),
      ]);
      _isLoaded = true;
    } catch (_) {
      // Keep default font as fallback if fetching fails.
    } finally {
      final elapsed = DateTime.now().difference(startedAt);
      final remaining = _minLoaderDuration - elapsed;
      if (remaining > Duration.zero) {
        await Future.delayed(remaining);
      }
      isLoading.value = false;
    }
  }
}
