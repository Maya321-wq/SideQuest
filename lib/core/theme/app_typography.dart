import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized typography styles for SideQuest.
///
/// Uses `Space Grotesk` for display headlines, stage counters, XP payouts, and
/// quest titles, and `Plus Jakarta Sans` for body copy, chips, and UI labels,
/// with clean sans-serif fallbacks when custom font assets are not bundled.
abstract final class AppTypography {
  static const String displayFontFamily = 'Space Grotesk';
  static const String bodyFontFamily = 'Plus Jakarta Sans';

  static const List<String> _fallbackFonts = <String>[
    'Plus Jakarta Sans',
    'Roboto',
    'sans-serif',
  ];

  // ─── Display & Headlines (Space Grotesk) ────────────────────────────────────

  /// 40px bold hero display style (e.g., celebration modal XP payout).
  static const TextStyle headlineXl = TextStyle(
    fontFamily: displayFontFamily,
    fontFamilyFallback: _fallbackFonts,
    fontSize: 40,
    height: 48 / 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.primaryText,
  );

  /// 32px bold mobile hero headline.
  static const TextStyle headlineXlMobile = TextStyle(
    fontFamily: displayFontFamily,
    fontFamilyFallback: _fallbackFonts,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.primaryText,
  );

  /// 26–28px bold page title (e.g., "Whispering Shrine Expedition").
  static const TextStyle pageTitle = TextStyle(
    fontFamily: displayFontFamily,
    fontFamilyFallback: _fallbackFonts,
    fontSize: 26,
    height: 34 / 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.primaryText,
  );

  /// 22px semi-bold section / screen title (e.g., "Quest Discovery").
  static const TextStyle headlineMd = TextStyle(
    fontFamily: displayFontFamily,
    fontFamilyFallback: _fallbackFonts,
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.primaryText,
  );

  /// 18px semi-bold card heading, metric value, or app bar title.
  static const TextStyle heading = TextStyle(
    fontFamily: displayFontFamily,
    fontFamilyFallback: _fallbackFonts,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    color: AppColors.primaryText,
  );

  /// 16px bold compact card title (e.g., badge titles, objective titles).
  static const TextStyle cardTitle = TextStyle(
    fontFamily: displayFontFamily,
    fontFamilyFallback: _fallbackFonts,
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  // ─── Body Copy (Plus Jakarta Sans) ──────────────────────────────────────────

  /// 16px regular large body text.
  static const TextStyle bodyLg = TextStyle(
    fontFamily: bodyFontFamily,
    fontFamilyFallback: _fallbackFonts,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  /// 14px regular standard body text (e.g., mission briefing, descriptions).
  static const TextStyle body = TextStyle(
    fontFamily: bodyFontFamily,
    fontFamilyFallback: _fallbackFonts,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
  );

  /// 12px regular compact body / caption text.
  static const TextStyle caption = TextStyle(
    fontFamily: bodyFontFamily,
    fontFamilyFallback: _fallbackFonts,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryText,
  );

  // ─── Labels & Buttons (Plus Jakarta Sans) ───────────────────────────────────

  /// 14px bold button and primary interactive label text.
  static const TextStyle button = TextStyle(
    fontFamily: bodyFontFamily,
    fontFamilyFallback: _fallbackFonts,
    fontSize: 14,
    height: 18 / 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: AppColors.primaryText,
  );

  /// 12px semi-bold chip and pill label text.
  static const TextStyle label = TextStyle(
    fontFamily: bodyFontFamily,
    fontFamilyFallback: _fallbackFonts,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.primaryText,
  );

  /// 10px semi-bold micro-label and overline text.
  static const TextStyle labelSm = TextStyle(
    fontFamily: bodyFontFamily,
    fontFamilyFallback: _fallbackFonts,
    fontSize: 10,
    height: 14 / 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.secondaryText,
  );

  /// Builds a complete Material 3 [TextTheme] mapped to SideQuest tokens.
  static TextTheme get textTheme => const TextTheme(
        displayLarge: headlineXl,
        displayMedium: headlineXlMobile,
        headlineLarge: pageTitle,
        headlineMedium: headlineMd,
        headlineSmall: heading,
        titleLarge: heading,
        titleMedium: cardTitle,
        bodyLarge: bodyLg,
        bodyMedium: body,
        bodySmall: caption,
        labelLarge: button,
        labelMedium: label,
        labelSmall: labelSm,
      );
}
