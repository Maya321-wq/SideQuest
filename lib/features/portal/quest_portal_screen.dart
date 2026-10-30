import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/data/game_state_repository.dart';
import '../../core/models/field_objective.dart';
import '../../core/models/player_profile.dart';
import '../../core/models/quest.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/glass_container.dart';
import '../shared/xp_progress_bar.dart';

class QuestPortalScreen extends StatefulWidget {
  const QuestPortalScreen({
    super.key,
    required this.repository,
    required this.questId,
    this.now,
  });

  final GameStateRepository repository;
  final String questId;
  final DateTime Function()? now;

  @override
  State<QuestPortalScreen> createState() => _QuestPortalScreenState();
}

class _QuestPortalScreenState extends State<QuestPortalScreen> {
  final Map<String, Timer> _objectiveTimers = {};
  final Map<String, DateTime> _objectiveDeadlines = {};
  final Map<String, int> _objectiveTotalSeconds = {};
  final Map<String, int> _objectiveInitialRemainingSeconds = {};
  final Map<String, double> _objectiveInitialProgress = {};

  DateTime get _now => widget.now?.call() ?? DateTime.now();

  Quest? get _quest {
    for (final quest in widget.repository.quests) {
      if (quest.id == widget.questId) return quest;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    widget.repository.addListener(_syncObjectiveTimers);
    _syncObjectiveTimers();
  }

  @override
  void didUpdateWidget(covariant QuestPortalScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repository != widget.repository ||
        oldWidget.questId != widget.questId) {
      oldWidget.repository.removeListener(_syncObjectiveTimers);
      _cancelAllObjectiveTimers();
      widget.repository.addListener(_syncObjectiveTimers);
      _syncObjectiveTimers();
    }
  }

  @override
  void dispose() {
    widget.repository.removeListener(_syncObjectiveTimers);
    _cancelAllObjectiveTimers();
    super.dispose();
  }

  void _syncObjectiveTimers() {
    final quest = _quest;
    if (quest == null || !quest.isAccepted || quest.isCompleted) {
      _cancelAllObjectiveTimers();
      return;
    }

    final activeTimedObjectives = <String>{};
    for (final objective in quest.objectives) {
      if (objective.status != ObjectiveStatus.inProgress ||
          objective.remainingSeconds <= 0) {
        continue;
      }

      activeTimedObjectives.add(objective.id);
      if (_objectiveTimers.containsKey(objective.id)) continue;

      final totalSeconds = objective.progress >= 1
          ? objective.remainingSeconds
          : (objective.remainingSeconds / (1 - objective.clampedProgress))
              .ceil();
      _objectiveTotalSeconds[objective.id] = totalSeconds;
      _objectiveInitialRemainingSeconds[objective.id] =
          objective.remainingSeconds;
      _objectiveInitialProgress[objective.id] = objective.clampedProgress;
      _objectiveDeadlines[objective.id] =
          _now.add(Duration(seconds: objective.remainingSeconds));
      _objectiveTimers[objective.id] = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _updateTimedObjective(objective.id),
      );
    }

    for (final objectiveId in _objectiveTimers.keys.toList()) {
      if (!activeTimedObjectives.contains(objectiveId)) {
        _cancelObjectiveTimer(objectiveId);
      }
    }
  }

  void _updateTimedObjective(String objectiveId) {
    if (!mounted) return;

    final quest = _quest;
    if (quest == null || !quest.isAccepted || quest.isCompleted) {
      _cancelObjectiveTimer(objectiveId);
      return;
    }

    FieldObjective? objective;
    for (final candidate in quest.objectives) {
      if (candidate.id == objectiveId) {
        objective = candidate;
        break;
      }
    }
    if (objective == null ||
        objective.status != ObjectiveStatus.inProgress) {
      _cancelObjectiveTimer(objectiveId);
      return;
    }

    final deadline = _objectiveDeadlines[objectiveId];
    final totalSeconds = _objectiveTotalSeconds[objectiveId];
    final initialRemainingSeconds =
        _objectiveInitialRemainingSeconds[objectiveId];
    final initialProgress = _objectiveInitialProgress[objectiveId];
    if (deadline == null ||
        totalSeconds == null ||
        initialRemainingSeconds == null ||
        initialProgress == null) {
      _cancelObjectiveTimer(objectiveId);
      return;
    }

    final remainingSeconds = _remainingSeconds(deadline);
    if (remainingSeconds == 0) {
      _cancelObjectiveTimer(objectiveId);
      _saveObjectiveTimerState(
        quest.id,
        objectiveId,
        0,
        totalSeconds,
        initialProgress,
        initialRemainingSeconds,
      );
      return;
    }
    if (remainingSeconds == objective.remainingSeconds) return;

    _saveObjectiveTimerState(
      quest.id,
      objectiveId,
      remainingSeconds,
      totalSeconds,
      initialProgress,
      initialRemainingSeconds,
    );
  }

  int _remainingSeconds(DateTime deadline) {
    final millisecondsRemaining = deadline.difference(_now).inMilliseconds;
    return millisecondsRemaining <= 0
        ? 0
        : (millisecondsRemaining / Duration.millisecondsPerSecond).ceil();
  }

  void _saveObjectiveTimerState(
    String questId,
    String objectiveId,
    int remainingSeconds,
    int totalSeconds,
    double initialProgress,
    int initialRemainingSeconds,
  ) {
    if (remainingSeconds == 0) {
      widget.repository.updateObjectiveProgress(
        questId: questId,
        objectiveId: objectiveId,
        progress: 1,
        remainingSeconds: 0,
        status: ObjectiveStatus.completed,
      );
      return;
    }

    final elapsedSeconds = initialRemainingSeconds - remainingSeconds;
    final progress = (initialProgress + elapsedSeconds / totalSeconds)
        .clamp(0.0, 1.0)
        .toDouble();
    widget.repository.updateObjectiveProgress(
      questId: questId,
      objectiveId: objectiveId,
      progress: progress,
      remainingSeconds: remainingSeconds,
      status: ObjectiveStatus.inProgress,
    );
  }

  void _cancelObjectiveTimer(String objectiveId) {
    _objectiveTimers.remove(objectiveId)?.cancel();
    _objectiveDeadlines.remove(objectiveId);
    _objectiveTotalSeconds.remove(objectiveId);
    _objectiveInitialRemainingSeconds.remove(objectiveId);
    _objectiveInitialProgress.remove(objectiveId);
  }

  void _cancelAllObjectiveTimers() {
    for (final timer in _objectiveTimers.values) {
      timer.cancel();
    }
    _objectiveTimers.clear();
    _objectiveDeadlines.clear();
    _objectiveTotalSeconds.clear();
    _objectiveInitialRemainingSeconds.clear();
    _objectiveInitialProgress.clear();
  }

  void _completeObjective(FieldObjective objective) {
    final quest = _quest;
    if (quest == null || quest.isCompleted) return;

    FieldObjective? currentObjective;
    for (final candidate in quest.objectives) {
      if (candidate.id == objective.id) {
        currentObjective = candidate;
        break;
      }
    }
    if (currentObjective?.status != ObjectiveStatus.inProgress) return;

    widget.repository.updateObjectiveProgress(
      questId: quest.id,
      objectiveId: objective.id,
      progress: 1,
      remainingSeconds: 0,
      status: ObjectiveStatus.completed,
    );
  }

  void _claimQuestReward() {
    final quest = _quest;
    if (quest == null) return;
    if (quest.isCompleted) {
      _showRewardFeedback('This quest reward has already been claimed.');
      return;
    }
    if (!quest.isAccepted || !quest.allObjectivesCompleted) {
      _showRewardFeedback(
        'Complete every quest objective before claiming its reward.',
      );
      return;
    }

    final awardedXp = widget.repository.completeQuest(quest.id);
    final message = awardedXp > 0
        ? 'Quest completed! +$awardedXp XP awarded.'
        : 'Reward could not be claimed. Please check the quest status.';
    _showRewardFeedback(message);
  }

  void _showRewardFeedback(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.elevatedSurface,
        behavior: SnackBarBehavior.floating,
        content: Text(message, style: AppTypography.label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
        title: Text('QUEST PORTAL', style: AppTypography.label),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: widget.repository,
        builder: (context, _) {
          final quest = _quest;
          if (quest == null) {
            return _PortalError(
              message: 'This quest is no longer available.',
            );
          }

          return _PortalContent(
            quest: quest,
            playerProfile: widget.repository.playerProfile,
            onCompleteObjective: _completeObjective,
            onClaimReward: _claimQuestReward,
          );
        },
      ),
    );
  }
}

class _PortalContent extends StatelessWidget {
  const _PortalContent({
    required this.quest,
    required this.playerProfile,
    required this.onCompleteObjective,
    required this.onClaimReward,
  });

  final Quest quest;
  final PlayerProfile playerProfile;
  final ValueChanged<FieldObjective> onCompleteObjective;
  final VoidCallback onClaimReward;

  @override
  Widget build(BuildContext context) {
    final completedCount = quest.completedObjectivesCount;
    final objectiveCount = quest.objectives.length;
    final progress =
        objectiveCount == 0 ? 0.0 : completedCount / objectiveCount;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: [
        Text(
          quest.locationOverline,
          style: AppTypography.labelSm.copyWith(
            color: AppColors.mintAccent,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          quest.title,
          style: AppTypography.pageTitle.copyWith(
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          quest.briefing,
          style: AppTypography.body.copyWith(color: AppColors.secondaryText),
        ),
        const SizedBox(height: 18),
        _QuestSummary(quest: quest),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: Text(
                'FIELD OBJECTIVES',
                style: AppTypography.heading.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
            ),
            Text(
              '$completedCount / $objectiveCount',
              style: AppTypography.label.copyWith(
                color: AppColors.mintAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: AppDecorations.borderRadiusPill,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            backgroundColor: AppColors.elevatedSurface,
            color: AppColors.mintAccent,
          ),
        ),
        const SizedBox(height: 14),
        if (quest.objectives.isEmpty)
          const _EmptyObjectives()
        else
          for (final objective in quest.objectives)
            _ObjectiveCard(
              objective: objective,
              onComplete: () => onCompleteObjective(objective),
            ),
        if (quest.isCompleted ||
            (quest.isAccepted && quest.isEligibleForCompletion)) ...[
          const SizedBox(height: 8),
          _CompletionRewardCard(
            quest: quest,
            playerProfile: playerProfile,
            onClaimReward: onClaimReward,
          ),
        ],
        if (quest.requiredArtifacts.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            'REQUIRED ARTIFACTS',
            style: AppTypography.heading.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 10),
          for (final artifact in quest.requiredArtifacts)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                borderRadius: AppDecorations.radiusItem,
                child: Row(
                  children: [
                    Icon(artifact.icon, color: AppColors.mintAccent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        artifact.name,
                        style: AppTypography.label.copyWith(
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                    Text(
                      artifact.statusLabel,
                      style: AppTypography.labelSm.copyWith(
                        color: artifact.isEquipped
                            ? AppColors.mintAccent
                            : AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _QuestSummary extends StatelessWidget {
  const _QuestSummary({required this.quest});

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      gradient: AppDecorations.heroCardGradient,
      borderRadius: AppDecorations.radiusCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quest.bannerTitle,
            style: AppTypography.heading.copyWith(
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoPill(
                icon: Icons.schedule_rounded,
                label: '${quest.durationMinutes} min',
              ),
              _InfoPill(
                icon: Icons.stars_rounded,
                label: '${quest.xpReward} XP',
                color: AppColors.goldRewards,
              ),
              _InfoPill(
                icon: Icons.shield_moon_rounded,
                label: quest.difficulty.label,
                color: AppColors.purpleSoft,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            quest.optimalPeriod,
            style: AppTypography.labelSm.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionRewardCard extends StatelessWidget {
  const _CompletionRewardCard({
    required this.quest,
    required this.playerProfile,
    required this.onClaimReward,
  });

  final Quest quest;
  final PlayerProfile playerProfile;
  final VoidCallback onClaimReward;

  @override
  Widget build(BuildContext context) {
    final isClaimed = quest.isCompleted;

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      gradient: AppDecorations.heroCardGradient,
      borderRadius: AppDecorations.radiusCard,
      glowType: isClaimed ? GlassGlowType.gold : GlassGlowType.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isClaimed ? 'QUEST COMPLETED' : 'ALL OBJECTIVES COMPLETE',
            style: AppTypography.heading.copyWith(
              color: isClaimed ? AppColors.goldRewards : AppColors.mintAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isClaimed
                ? '${quest.xpReward} XP reward claimed'
                : 'Claim your ${quest.xpReward} XP quest reward.',
            style: AppTypography.body,
          ),
          if (isClaimed) ...[
            const SizedBox(height: 14),
            XpProgressBar(
              currentXp: playerProfile.currentXp,
              requiredXp: playerProfile.requiredXp,
              headerLabel: 'Level ${playerProfile.level} XP',
              footerNote: '${playerProfile.formattedTotalXp} total XP',
            ),
          ] else ...[
            const SizedBox(height: 14),
            AppButton(
              label: 'CLAIM ${quest.xpReward} XP REWARD',
              onPressed: onClaimReward,
              variant: AppButtonVariant.portalGradient,
              leadingIcon: Icons.stars_rounded,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
    this.color = AppColors.mintAccent,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.55),
        border: Border.all(color: AppColors.outline),
        borderRadius: AppDecorations.borderRadiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _ObjectiveCard extends StatelessWidget {
  const _ObjectiveCard({
    required this.objective,
    required this.onComplete,
  });

  final FieldObjective objective;
  final VoidCallback onComplete;

  Color get _statusColor => switch (objective.status) {
        ObjectiveStatus.completed => AppColors.emeraldSuccess,
        ObjectiveStatus.inProgress => AppColors.mintAccent,
        ObjectiveStatus.locked => AppColors.secondaryText,
      };

  IconData get _statusIcon => switch (objective.status) {
        ObjectiveStatus.completed => Icons.check_circle_rounded,
        ObjectiveStatus.inProgress => Icons.radio_button_checked_rounded,
        ObjectiveStatus.locked => Icons.lock_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final isInProgress = objective.status == ObjectiveStatus.inProgress;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassContainer(
        padding: const EdgeInsets.all(14),
        borderRadius: AppDecorations.radiusItem,
        glowType: isInProgress ? GlassGlowType.mint : GlassGlowType.none,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_statusIcon, color: _statusColor, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    objective.title,
                    style: AppTypography.label.copyWith(
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  objective.status.label,
                  style: AppTypography.labelSm.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                objective.subtitle,
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ),
            if (isInProgress) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: AppDecorations.borderRadiusPill,
                      child: LinearProgressIndicator(
                        value: objective.clampedProgress,
                        minHeight: 5,
                        backgroundColor: AppColors.elevatedSurface,
                        color: AppColors.mintAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${objective.percentage}% complete',
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                        if (objective.remainingSeconds > 0)
                          Text(
                            objective.formattedRemainingTime,
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.mintAccent,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (objective.remainingSeconds <= 0) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: AppButton(
                    label: 'COMPLETE OBJECTIVE',
                    onPressed: onComplete,
                    variant: AppButtonVariant.secondaryOutlined,
                    height: 40,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyObjectives extends StatelessWidget {
  const _EmptyObjectives();

  @override
  Widget build(BuildContext context) {
    return const GlassContainer(
      child: Text(
        'This quest has no objectives yet.',
        style: TextStyle(color: AppColors.secondaryText),
      ),
    );
  }
}

class _PortalError extends StatelessWidget {
  const _PortalError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(color: AppColors.secondaryText),
        ),
      ),
    );
  }
}
