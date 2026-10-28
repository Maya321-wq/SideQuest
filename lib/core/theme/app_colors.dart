import 'package:flutter/material.dart';

/// Centralized color palette for the SideQuest "Mystic Grove RPG" theme.
///
/// Derived directly from the SideQuest System Specification and Google Stitch
/// screen references.
abstract final class AppColors {
  // ─── Core Surfaces ──────────────────────────────────────────────────────────
  /// Deep nocturnal canvas background (`#0D141E`).
  static const Color background = Color(0xFF0D141E);

  /// Deepest recessed container background (`#080E18`).
  static const Color surfaceLowest = Color(0xFF080E18);

  /// Main card and container surface (`#151C26`).
  static const Color mainSurface = Color(0xFF151C26);

  /// Intermediate surface container (`#19202A`).
  static const Color surfaceContainer = Color(0xFF19202A);

  /// Elevated interactive surface (`#1D2633`).
  static const Color elevatedSurface = Color(0xFF1D2633);

  /// High-emphasis container surface (`#232A35`).
  static const Color surfaceHigh = Color(0xFF232A35);

  /// Highest-emphasis container surface (`#2E3540`).
  static const Color surfaceHighest = Color(0xFF2E3540);

  /// Frosted dark slate base (`#0F1C2E`).
  static const Color frostedSlate = Color(0xFF0F1C2E);

  // ─── Primary & Mint Accents ─────────────────────────────────────────────────
  /// Ethereal cyan / mint primary accent (`#00F5D4`).
  static const Color mintAccent = Color(0xFF00F5D4);

  /// Bright mint highlight for active path trails (`#26FEDC`).
  static const Color mintBright = Color(0xFF26FEDC);

  /// Slightly dimmed mint for borders and secondary indicators (`#00DFC1`).
  static const Color mintDim = Color(0xFF00DFC1);

  /// Soft pale mint text highlight (`#D7FFF3`).
  static const Color onMintLight = Color(0xFFD7FFF3);

  /// Deep dark teal text on mint pills (`#00201A`).
  static const Color onMintDark = Color(0xFF00201A);

  // ─── Arcane Purple Accents & Glows ──────────────────────────────────────────
  /// Core purple accent (`#5541A8`).
  static const Color purpleAccent = Color(0xFF5541A8);

  /// Royal arcane purple container (`#6C04DE`).
  static const Color purpleContainer = Color(0xFF6C04DE);

  /// Primary purple glow (`#8A2BE2`).
  static const Color purpleGlow = Color(0xFF8A2BE2);

  /// Secondary lighter purple glow (`#9D4EDD`).
  static const Color purpleGlowLight = Color(0xFF9D4EDD);

  /// Top stop for hero CTA vertical purple gradient (`#A855F7`).
  static const Color ctaPurpleTop = Color(0xFFA855F7);

  /// Bottom stop for hero CTA vertical purple gradient (`#6B21A8`).
  static const Color ctaPurpleBottom = Color(0xFF6B21A8);

  /// Soft lavender text and badge tint (`#D4BBFF`).
  static const Color purpleSoft = Color(0xFFD4BBFF);

  /// Hero card gradient start (`#1F1640`).
  static const Color heroGradientStart = Color(0xFF1F1640);

  /// Hero card gradient end (`#16273E`).
  static const Color heroGradientEnd = Color(0xFF16273E);

  // ─── Gold & Campfire Amber Rewards ──────────────────────────────────────────
  /// Radiant gold for XP payouts, stars, and boss portals (`#FFBE0B`).
  static const Color goldRewards = Color(0xFFFFBE0B);

  /// Warm campfire amber for gradients and secondary reward text (`#FFBA4B`).
  static const Color amberAccent = Color(0xFFFFBA4B);

  /// Soft pale gold for badge labels (`#FFDDB1`).
  static const Color goldSoft = Color(0xFFFFDDB1);

  /// Deep amber-brown for text on bright gold pills (`#291800`).
  static const Color onGoldDark = Color(0xFF291800);

  // ─── Typography & Outlines ──────────────────────────────────────────────────
  /// Crisp primary text (`#FFFFFF`).
  static const Color primaryText = Color(0xFFFFFFFF);

  /// Soft off-white surface text (`#DCE3F1`).
  static const Color onSurface = Color(0xFFDCE3F1);

  /// Muted secondary text for descriptions and metadata (`#8F9CAE`).
  static const Color secondaryText = Color(0xFF8F9CAE);

  /// Mint-tinted muted text (`#B9CAC4`).
  static const Color onSurfaceVariant = Color(0xFFB9CAC4);

  /// Default structural border and divider color (`#263342`).
  static const Color outline = Color(0xFF263342);

  /// Subtle teal-tinted border variant (`#3A4A46`).
  static const Color outlineVariant = Color(0xFF3A4A46);

  // ─── Semantic Accents ───────────────────────────────────────────────────────
  /// Forest emerald for completed checks (`#10B981`).
  static const Color emeraldSuccess = Color(0xFF10B981);

  /// Ruby flare for hard difficulty, lives, and ruby currency (`#EF4444`).
  static const Color rubyDanger = Color(0xFFEF4444);

  /// Soft coral for error/hard chips (`#FFB4AB`).
  static const Color errorSoft = Color(0xFFFFB4AB);

  /// Spectral azure for passive/ghost waypoints (`#38BDF8`).
  static const Color spectralAzure = Color(0xFF38BDF8);
}
