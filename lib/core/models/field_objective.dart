import 'package:flutter/material.dart';

/// Completion state of a [FieldObjective] inside the Quest Portal.
enum ObjectiveStatus {
  completed(label: 'Done'),
  inProgress(label: 'In Progress'),
  locked(label: 'Locked');

  const ObjectiveStatus({required this.label});

  final String label;
}

/// Immutable model representing a single checklist objective on the Quest Portal screen.
@immutable
class FieldObjective {
  const FieldObjective({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    this.progress = 0.0,
    this.remainingSeconds = 0,
    this.isGpsVerified = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final ObjectiveStatus status;

  /// Progress value clamped in `[0.0, 1.0]`.
  final double progress;

  /// Remaining timer seconds for timed objectives (e.g., `320` -> `05:20`).
  final int remainingSeconds;

  /// Whether this objective was verified via simulated proximity GPS.
  final bool isGpsVerified;

  double get clampedProgress => progress.clamp(0.0, 1.0);

  int get percentage => (clampedProgress * 100).round();

  bool get isCompleted => status == ObjectiveStatus.completed;

  String get formattedRemainingTime {
    final int safeSeconds = remainingSeconds < 0 ? 0 : remainingSeconds;
    final int minutes = safeSeconds ~/ 60;
    final int seconds = safeSeconds % 60;
    final String mm = minutes.toString().padLeft(2, '0');
    final String ss = seconds.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  FieldObjective copyWith({
    String? id,
    String? title,
    String? subtitle,
    ObjectiveStatus? status,
    double? progress,
    int? remainingSeconds,
    bool? isGpsVerified,
  }) {
    return FieldObjective(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isGpsVerified: isGpsVerified ?? this.isGpsVerified,
    );
  }
}
