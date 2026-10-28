import 'package:flutter/material.dart';

/// Progression states for waypoints along the Adventure Map S-curve trail.
enum StageStatus {
  completed,
  active,
  locked,
}

/// Immutable model representing a stage node on the Adventure Map screen
/// (Stages 15 through 22, highlighting Stage 21: Whispering Grove).
@immutable
class StageNode {
  const StageNode({
    required this.stageNumber,
    required this.title,
    required this.description,
    required this.status,
    required this.xpReward,
    required this.linkedQuestId,
    required this.normalizedX,
    required this.normalizedY,
    this.shortTag,
    this.statusBannerText = 'STAGE WAYPOINT',
    this.estimatedTimeLabel = 'Est. 3 min',
    this.livesLabel = '3 Lives',
    this.lootLabel = 'Legendary Relic',
    this.isBossStage = false,
  });

  final int stageNumber;
  final String title;
  final String description;
  final StageStatus status;
  final int xpReward;
  final String linkedQuestId;

  /// Horizontal coordinate in `[0.0, 1.0]` relative to map canvas width.
  final double normalizedX;

  /// Vertical coordinate in `[0.0, 1.0]` relative to map canvas height.
  final double normalizedY;

  final String? shortTag;
  final String statusBannerText;
  final String estimatedTimeLabel;
  final String livesLabel;
  final String lootLabel;
  final bool isBossStage;

  bool get isLocked => status == StageStatus.locked;
  bool get isActive => status == StageStatus.active;
  bool get isCompleted => status == StageStatus.completed;

  StageNode copyWith({
    int? stageNumber,
    String? title,
    String? description,
    StageStatus? status,
    int? xpReward,
    String? linkedQuestId,
    double? normalizedX,
    double? normalizedY,
    String? shortTag,
    String? statusBannerText,
    String? estimatedTimeLabel,
    String? livesLabel,
    String? lootLabel,
    bool? isBossStage,
  }) {
    return StageNode(
      stageNumber: stageNumber ?? this.stageNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      xpReward: xpReward ?? this.xpReward,
      linkedQuestId: linkedQuestId ?? this.linkedQuestId,
      normalizedX: normalizedX ?? this.normalizedX,
      normalizedY: normalizedY ?? this.normalizedY,
      shortTag: shortTag ?? this.shortTag,
      statusBannerText: statusBannerText ?? this.statusBannerText,
      estimatedTimeLabel: estimatedTimeLabel ?? this.estimatedTimeLabel,
      livesLabel: livesLabel ?? this.livesLabel,
      lootLabel: lootLabel ?? this.lootLabel,
      isBossStage: isBossStage ?? this.isBossStage,
    );
  }
}
