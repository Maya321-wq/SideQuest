import 'package:flutter/material.dart';

/// Filterable categories for the "Badges of Honor" section on Hero's Journey.
enum BadgeCategory {
  all(label: 'All'),
  recent(label: 'Recent'),
  mystic(label: 'Mystic'),
  mastery(label: 'Mastery');

  const BadgeCategory({required this.label});

  final String label;
}

/// Visual accent palette for individual achievement badge tiles.
enum BadgeAccentStyle {
  gold,
  purple,
  mint,
  teal,
}

/// Immutable model representing an achievement badge on the Hero's Journey screen.
@immutable
class AchievementBadge {
  const AchievementBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.loreDetails,
    required this.category,
    required this.xpBonus,
    required this.icon,
    required this.isUnlocked,
    this.currentProgress = 1,
    this.targetProgress = 1,
    this.accentStyle = BadgeAccentStyle.mint,
    this.isRecent = false,
  });

  final String id;
  final String title;
  final String description;
  final String loreDetails;
  final BadgeCategory category;
  final int xpBonus;
  final IconData icon;
  final bool isUnlocked;
  final int currentProgress;
  final int targetProgress;
  final BadgeAccentStyle accentStyle;
  final bool isRecent;

  double get progressRatio {
    if (targetProgress <= 0) return 0.0;
    return (currentProgress / targetProgress).clamp(0.0, 1.0);
  }

  String get progressLabel => '$currentProgress / $targetProgress';

  AchievementBadge copyWith({
    String? id,
    String? title,
    String? description,
    String? loreDetails,
    BadgeCategory? category,
    int? xpBonus,
    IconData? icon,
    bool? isUnlocked,
    int? currentProgress,
    int? targetProgress,
    BadgeAccentStyle? accentStyle,
    bool? isRecent,
  }) {
    return AchievementBadge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      loreDetails: loreDetails ?? this.loreDetails,
      category: category ?? this.category,
      xpBonus: xpBonus ?? this.xpBonus,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      currentProgress: currentProgress ?? this.currentProgress,
      targetProgress: targetProgress ?? this.targetProgress,
      accentStyle: accentStyle ?? this.accentStyle,
      isRecent: isRecent ?? this.isRecent,
    );
  }
}
