import 'package:flutter/material.dart';
import 'field_objective.dart';
import 'required_artifact.dart';

/// Filterable quest realm/category chips on the Quest Discovery screen.
enum QuestCategory {
  all(
    label: 'All Quests',
    icon: Icons.auto_awesome_rounded,
  ),
  mysticGrove(
    label: 'Mystic Grove',
    icon: Icons.forest_rounded,
  ),
  ancientRuins(
    label: 'Ancient Ruins',
    icon: Icons.account_balance_rounded,
  ),
  wilderness(
    label: 'Wilderness',
    icon: Icons.landscape_rounded,
  ),
  campfireLore(
    label: 'Campfire Lore',
    icon: Icons.local_fire_department_rounded,
  );

  const QuestCategory({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

/// Difficulty tiers across Quest Discovery cards and the Quest Portal bento grid.
enum QuestDifficulty {
  gentle(label: 'Gentle'),
  moderate(label: 'Moderate'),
  hard(label: 'Hard'),
  mythicIII(label: 'Mythic III');

  const QuestDifficulty({required this.label});

  final String label;
}

/// Immutable model representing a SideQuest bounty/expedition across Discovery,
/// Map Stage links, and the Quest Portal briefing screen.
@immutable
class Quest {
  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.briefing,
    required this.category,
    required this.disciplineTag,
    required this.difficulty,
    required this.durationMinutes,
    required this.distanceLabel,
    required this.locationName,
    required this.xpReward,
    required this.bonusReward,
    required this.icon,
    required this.objectives,
    required this.requiredArtifacts,
    this.locationOverline = 'SANCTUARY RUINS',
    this.bannerTitle = 'The Whispering Shrine',
    this.nodeCode = 'Active Discovery Node #08',
    this.scoutNoteCode = 'Scout Note #44',
    this.optimalPeriod = 'Optimal completion period: Dusk to Midnight',
    this.durationSubtitle = 'Outdoor Pacing',
    this.difficultySubtitle = 'Intense Focus',
    this.disciplineSubtitle = 'Arcane Attunement',
    this.tierLabel = 'Epic Tier',
    this.secondaryTag = 'Mystic Arcana',
    this.bannerAssetPath,
    this.isFeatured = false,
    this.isAccepted = false,
    this.isCompleted = false,
    this.isSaved = false,
    this.isGpsSynchronized = true,
  });

  final String id;
  final String title;
  final String description;
  final String briefing;
  final QuestCategory category;
  final String disciplineTag;
  final QuestDifficulty difficulty;
  final int durationMinutes;
  final String distanceLabel;
  final String locationName;
  final int xpReward;
  final String bonusReward;
  final IconData icon;
  final List<FieldObjective> objectives;
  final List<RequiredArtifact> requiredArtifacts;

  // Portal header & bento metadata
  final String locationOverline;
  final String bannerTitle;
  final String nodeCode;
  final String scoutNoteCode;
  final String optimalPeriod;
  final String durationSubtitle;
  final String difficultySubtitle;
  final String disciplineSubtitle;
  final String tierLabel;
  final String secondaryTag;
  final String? bannerAssetPath;

  // State flags
  final bool isFeatured;
  final bool isAccepted;
  final bool isCompleted;
  final bool isSaved;
  final bool isGpsSynchronized;

  int get completedObjectivesCount =>
      objectives.where((FieldObjective o) => o.isCompleted).length;

  int get equippedArtifactsCount =>
      requiredArtifacts.where((RequiredArtifact a) => a.isEquipped).length;

  bool get allObjectivesCompleted =>
      objectives.isNotEmpty &&
      completedObjectivesCount == objectives.length;

  /// A quest is eligible to award XP when all objectives are completed and
  /// its reward has not already been claimed.
  bool get isEligibleForCompletion => allObjectivesCompleted && !isCompleted;

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    String? briefing,
    QuestCategory? category,
    String? disciplineTag,
    QuestDifficulty? difficulty,
    int? durationMinutes,
    String? distanceLabel,
    String? locationName,
    int? xpReward,
    String? bonusReward,
    IconData? icon,
    List<FieldObjective>? objectives,
    List<RequiredArtifact>? requiredArtifacts,
    String? locationOverline,
    String? bannerTitle,
    String? nodeCode,
    String? scoutNoteCode,
    String? optimalPeriod,
    String? durationSubtitle,
    String? difficultySubtitle,
    String? disciplineSubtitle,
    String? tierLabel,
    String? secondaryTag,
    String? bannerAssetPath,
    bool? isFeatured,
    bool? isAccepted,
    bool? isCompleted,
    bool? isSaved,
    bool? isGpsSynchronized,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      briefing: briefing ?? this.briefing,
      category: category ?? this.category,
      disciplineTag: disciplineTag ?? this.disciplineTag,
      difficulty: difficulty ?? this.difficulty,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      distanceLabel: distanceLabel ?? this.distanceLabel,
      locationName: locationName ?? this.locationName,
      xpReward: xpReward ?? this.xpReward,
      bonusReward: bonusReward ?? this.bonusReward,
      icon: icon ?? this.icon,
      objectives: objectives ?? this.objectives,
      requiredArtifacts: requiredArtifacts ?? this.requiredArtifacts,
      locationOverline: locationOverline ?? this.locationOverline,
      bannerTitle: bannerTitle ?? this.bannerTitle,
      nodeCode: nodeCode ?? this.nodeCode,
      scoutNoteCode: scoutNoteCode ?? this.scoutNoteCode,
      optimalPeriod: optimalPeriod ?? this.optimalPeriod,
      durationSubtitle: durationSubtitle ?? this.durationSubtitle,
      difficultySubtitle: difficultySubtitle ?? this.difficultySubtitle,
      disciplineSubtitle: disciplineSubtitle ?? this.disciplineSubtitle,
      tierLabel: tierLabel ?? this.tierLabel,
      secondaryTag: secondaryTag ?? this.secondaryTag,
      bannerAssetPath: bannerAssetPath ?? this.bannerAssetPath,
      isFeatured: isFeatured ?? this.isFeatured,
      isAccepted: isAccepted ?? this.isAccepted,
      isCompleted: isCompleted ?? this.isCompleted,
      isSaved: isSaved ?? this.isSaved,
      isGpsSynchronized: isGpsSynchronized ?? this.isGpsSynchronized,
    );
  }
}
