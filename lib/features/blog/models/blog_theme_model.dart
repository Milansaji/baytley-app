import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

extension BlogThemeX on BuildContext {
  ThemeData get blogTheme {
    // We want a custom theme that is primarily light but with a grey background
    // regardless of the app's global state, if the user requested "grey background".
    final baseTheme = AppTheme.lightTheme;

    return baseTheme.copyWith(
      scaffoldBackgroundColor:
          Colors.grey[100], // The requested grey background
      colorScheme: baseTheme.colorScheme.copyWith(surface: Colors.white),
      cardTheme: baseTheme.cardTheme.copyWith(
        color: Colors.white,
        elevation: 4,
        shadowColor: baseTheme.primaryColor.withValues(alpha: 0.1),
      ),
    );
  }

  ColorScheme get blogColorScheme => blogTheme.colorScheme;

  TextTheme get blogTextTheme => blogTheme.textTheme;

  Color get blogScaffoldBackground => blogTheme.scaffoldBackgroundColor;
}
