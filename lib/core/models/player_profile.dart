import 'package:flutter/material.dart';

/// Immutable model representing the player's hero profile, level/XP progress,
/// lifetime statistics, and map HUD currencies.
@immutable
class PlayerProfile {
  const PlayerProfile({
    required this.id,
    required this.name,
    required this.mapAlias,
    required this.classTitle,
    required this.nextClassTitle,
    required this.currentChapter,
    required this.level,
    required this.currentXp,
    required this.requiredXp,
    required this.totalXp,
    required this.completedQuestsCount,
    required this.streakDays,
    required this.unlockedBadgesCount,
    required this.totalBadgesCount,
    required this.rubies,
    required this.energy,
    this.avatarAssetPath,
  });

  final String id;

  /// Full character name displayed on Hero's Journey (`Kaelen Swiftwind`).
  final String name;

  /// Compact alias displayed in the Adventure Map HUD (`Little Fox`).
  final String mapAlias;

  /// Current class rank (`Mystic Scout`).
  final String classTitle;

  /// Next rank milestone (`Arch-Seeker`).
  final String nextClassTitle;

  /// Active story chapter subtitle (`CHAPTER 3: THE MIST LANDS`).
  final String currentChapter;

  final int level;
  final int currentXp;
  final int requiredXp;
  final int totalXp;
  final int completedQuestsCount;
  final int streakDays;
  final int unlockedBadgesCount;
  final int totalBadgesCount;
  final int rubies;
  final int energy;
  final String? avatarAssetPath;

  double get xpProgressRatio {
    if (requiredXp <= 0) return 0.0;
    return (currentXp / requiredXp).clamp(0.0, 1.0);
  }

  int get xpPercentage => (xpProgressRatio * 100).round();

  String get formattedTotalXp {
    final String raw = totalXp.toString();
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return raw.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  PlayerProfile copyWith({
    String? id,
    String? name,
    String? mapAlias,
    String? classTitle,
    String? nextClassTitle,
    String? currentChapter,
    int? level,
    int? currentXp,
    int? requiredXp,
    int? totalXp,
    int? completedQuestsCount,
    int? streakDays,
    int? unlockedBadgesCount,
    int? totalBadgesCount,
    int? rubies,
    int? energy,
    String? avatarAssetPath,
  }) {
    return PlayerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      mapAlias: mapAlias ?? this.mapAlias,
      classTitle: classTitle ?? this.classTitle,
      nextClassTitle: nextClassTitle ?? this.nextClassTitle,
      currentChapter: currentChapter ?? this.currentChapter,
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      requiredXp: requiredXp ?? this.requiredXp,
      totalXp: totalXp ?? this.totalXp,
      completedQuestsCount: completedQuestsCount ?? this.completedQuestsCount,
      streakDays: streakDays ?? this.streakDays,
      unlockedBadgesCount: unlockedBadgesCount ?? this.unlockedBadgesCount,
      totalBadgesCount: totalBadgesCount ?? this.totalBadgesCount,
      rubies: rubies ?? this.rubies,
      energy: energy ?? this.energy,
      avatarAssetPath: avatarAssetPath ?? this.avatarAssetPath,
    );
  }
}
