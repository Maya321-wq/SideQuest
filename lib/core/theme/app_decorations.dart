import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized radii, borders, gradients, shadows, and [BoxDecoration] presets
/// for the SideQuest "Mystic Grove RPG" design system.
abstract final class AppDecorations {
  // ─── Corner Radii ───────────────────────────────────────────────────────────
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusItem = 14.0;
  static const double radiusCard = 16.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 24.0;
  static const double radiusPill = 999.0;

  static const BorderRadius borderRadiusSm =
      BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd =
      BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusItem =
      BorderRadius.all(Radius.circular(radiusItem));
  static const BorderRadius borderRadiusCard =
      BorderRadius.all(Radius.circular(radiusCard));
  static const BorderRadius borderRadiusLg =
      BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl =
      BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius borderRadiusPill =
      BorderRadius.all(Radius.circular(radiusPill));

  // ─── Gradients ──────────────────────────────────────────────────────────────

  /// Vertical purple gradient used on primary CTA buttons ("Start Quest", "Accept Quest").
  static const LinearGradient primaryCtaGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AppColors.ctaPurpleTop,
      AppColors.ctaPurpleBottom,
    ],
  );

  /// Horizontal purple-to-mint gradient used on the Quest Portal "ENTER PORTAL" CTA.
  static const LinearGradient portalCtaGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      AppColors.purpleContainer,
      AppColors.purpleAccent,
      AppColors.mintAccent,
    ],
  );

  /// Elevated purple-to-slate glass gradient used for Hero Header & Map Sync cards.
  static const LinearGradient heroCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xE61F1640), // #1F1640 at 90%
      Color(0xE616273E), // #16273E at 90%
    ],
  );

  /// Floating Stage Sheet dark glass gradient.
  static const LinearGradient stageSheetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xF219202A),
      Color(0xF2151C26),
      Color(0xF5080E18),
    ],
  );

  /// Gold-to-mint gradient used on the Hero XP progress bar.
  static const LinearGradient xpBarGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      AppColors.goldRewards,
      AppColors.amberAccent,
      AppColors.mintAccent,
    ],
  );

  /// Warm gold gradient used on compact HUD XP bars and boss stage orbs.
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      AppColors.amberAccent,
      AppColors.goldRewards,
    ],
  );

  /// Purple objective progress gradient.
  static const LinearGradient purpleProgressGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      AppColors.purpleContainer,
      AppColors.purpleSoft,
    ],
  );

  // ─── Restrained Glow Shadows ────────────────────────────────────────────────

  /// Restrained cyan/mint glow for active nodes, badges, and selected chips.
  static List<BoxShadow> mintGlow({double opacity = 0.30, double blur = 18}) =>
      <BoxShadow>[
        BoxShadow(
          color: AppColors.mintAccent.withValues(alpha: opacity),
          blurRadius: blur,
          spreadRadius: -2,
        ),
      ];

  /// Restrained purple glow for primary CTA buttons and active objectives.
  static List<BoxShadow> purpleGlow({
    double opacity = 0.42,
    double blur = 18,
    Offset offset = const Offset(0, 4),
  }) =>
      <BoxShadow>[
        BoxShadow(
          color: AppColors.purpleGlow.withValues(alpha: opacity),
          blurRadius: blur,
          offset: offset,
        ),
      ];

  /// Restrained gold/amber glow for boss portals, legendary items, and XP badges.
  static List<BoxShadow> goldGlow({double opacity = 0.32, double blur = 16}) =>
      <BoxShadow>[
        BoxShadow(
          color: AppColors.goldRewards.withValues(alpha: opacity),
          blurRadius: blur,
          spreadRadius: -2,
        ),
      ];

  /// Soft dark elevation shadow for standard cards.
  static const List<BoxShadow> cardShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x66050B13),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  // ─── Reusable BoxDecorations ────────────────────────────────────────────────

  /// Standard dark glass surface decoration.
  static BoxDecoration glassSurface({
    Color? color,
    Color? borderColor,
    double borderRadius = radiusCard,
    double borderWidth = 1.0,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: gradient == null
          ? (color ?? AppColors.mainSurface.withValues(alpha: 0.86))
          : null,
      gradient: gradient,
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      border: Border.all(
        color: borderColor ?? AppColors.outline.withValues(alpha: 0.75),
        width: borderWidth,
      ),
      boxShadow: boxShadow ?? cardShadow,
    );
  }

  /// Square 40x40 / 44x44 top-bar icon button decoration.
  static BoxDecoration iconButtonDecoration({
    Color? borderColor,
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppColors.surfaceHigh.withValues(alpha: 0.65),
      borderRadius: borderRadiusMd,
      border: Border.all(
        color: borderColor ?? AppColors.outline.withValues(alpha: 0.65),
        width: 1.0,
      ),
    );
  }
}
