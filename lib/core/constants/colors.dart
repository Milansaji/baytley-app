import 'package:flutter/material.dart';

class AppColors {
  // ── Brand Core ───────────────────────────────────────────────────────────
  /// Deep navy used in the hero section / primary brand colour
  static const Color primary = Color(0xFF0D1A2E);

  /// Slightly lighter navy for surfaces / cards in dark contexts
  static const Color primaryLight = Color(0xFF152236);

  /// The muted steel-blue used for section dividers & mid-tones
  static const Color secondary = Color(0xFF3D5068);

  // ── Backgrounds ──────────────────────────────────────────────────────────
  /// Light silver-grey used as the header / page background in light mode
  static const Color backgroundLight = Color(0xFFE8EBF0);

  /// Pure deep-navy used as the hero / dark-section background
  static const Color backgroundDark = Color(0xFF0D1A2E);

  /// Clean white for card / content surfaces
  static const Color surface = Color(0xFFFFFFFF);

  /// Very light grey for subtle surface elevation in light mode
  static const Color surfaceVariant = Color(0xFFF0F2F5);

  // ── Text ─────────────────────────────────────────────────────────────────
  /// Primary text on light backgrounds  (dark navy)
  static const Color textPrimaryDark = Color(0xFF0D1A2E);

  /// Secondary / muted text on light backgrounds
  static const Color textSecondaryDark = Color(0xFF3D5068);

  /// Primary text on dark / navy backgrounds (white)
  static const Color textPrimaryLight = Color(0xFFFFFFFF);

  /// Secondary / muted text on dark backgrounds
  static const Color textSecondaryLight = Color(0xFFB0BDD0);

  // ── UI Elements ──────────────────────────────────────────────────────────
  /// Border colour in light contexts
  static const Color border = Color(0xFFD1D8E0);

  /// Divider colour in light contexts
  static const Color divider = Color(0xFFE4E8EE);

  /// Semi-transparent overlay (for modals, bottom sheets, etc.)
  static const Color overlay = Color(0xBF0D1A2E);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}
