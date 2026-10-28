import 'package:flutter/material.dart';
import '../../../core/models/quest.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_container.dart';

/// Individual available quest card in the Quest Discovery feed
/// (`The Silent Wanderer`, `Herbalist's Solitude`, `Echoes in the Gloom`).
class QuestCard extends StatelessWidget {
  const QuestCard({
    super.key,
    required this.quest,
    required this.onEmbark,
  });

  final Quest quest;
  final VoidCallback onEmbark;

  Color _resolveAccentColor() {
    switch (quest.difficulty) {
      case QuestDifficulty.gentle:
        return quest.category == QuestCategory.campfireLore
            ? AppColors.purpleSoft
            : AppColors.mintAccent;
      case QuestDifficulty.moderate:
        return AppColors.amberAccent;
      case QuestDifficulty.hard:
      case QuestDifficulty.mythicIII:
        return AppColors.goldRewards;
    }
  }

  GlassGlowType _resolvePodGlow() {
    switch (quest.difficulty) {
      case QuestDifficulty.gentle:
        return quest.category == QuestCategory.campfireLore
            ? GlassGlowType.purple
            : GlassGlowType.mint;
      case QuestDifficulty.moderate:
      case QuestDifficulty.hard:
      case QuestDifficulty.mythicIII:
        return GlassGlowType.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = _resolveAccentColor();
    final Color difficultyColor = quest.difficulty == QuestDifficulty.moderate
        ? AppColors.amberAccent
        : AppColors.mintAccent;

    return GlassContainer(
      onTap: onEmbark,
      padding: const EdgeInsets.all(16.0),
      borderRadius: AppDecorations.radiusCard,
      backgroundColor: AppColors.frostedSlate.withValues(alpha: 0.78),
      borderColor: AppColors.outlineVariant.withValues(alpha: 0.45),
      semanticLabel:
          '${quest.title}, ${quest.disciplineTag}, ${quest.durationMinutes} minutes, reward ${quest.xpReward} XP',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Top row: Icon Pod + Title/Tags + XP Reward Pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 48x48 Glowing Node Icon Pod
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceHighest.withValues(alpha: 0.85),
                  borderRadius: AppDecorations.borderRadiusMd,
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.45),
                    width: 1.0,
                  ),
                  boxShadow: _resolvePodGlow() == GlassGlowType.gold
                      ? AppDecorations.goldGlow(opacity: 0.25, blur: 14)
                      : (_resolvePodGlow() == GlassGlowType.mint
                          ? AppDecorations.mintGlow(opacity: 0.25, blur: 14)
                          : null),
                ),
                child: Icon(
                  quest.icon,
                  size: 24,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 12),

              // Title + Discipline Pill + Metadata Row
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: <Widget>[
                        Text(
                          quest.title,
                          style: AppTypography.cardTitle.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceHighest,
                            borderRadius: AppDecorations.borderRadiusPill,
                            border: Border.all(
                              color: AppColors.outlineVariant
                                  .withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            quest.disciplineTag,
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(
                              Icons.schedule_rounded,
                              size: 13,
                              color: AppColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${quest.durationMinutes} min',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '•',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          quest.difficulty.label,
                          style: AppTypography.caption.copyWith(
                            color: difficultyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '•',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(
                              Icons.near_me_outlined,
                              size: 13,
                              color: AppColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              quest.distanceLabel,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Right XP & Bonus Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '+${quest.xpReward} XP',
                    style: AppTypography.heading.copyWith(
                      color: AppColors.amberAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    quest.bonusReward,
                    style: AppTypography.labelSm.copyWith(
                      color: quest.bonusReward.contains('Elixir')
                          ? AppColors.mintAccent
                          : (quest.bonusReward.contains('Rune')
                              ? AppColors.purpleSoft
                              : AppColors.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.outlineVariant.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 10),

          // Bottom row: Location Name + Embark Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.explore_outlined,
                      size: 15,
                      color: accentColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        quest.locationName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: AppDecorations.borderRadiusSm,
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.45),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      quest.isCompleted
                          ? 'Completed'
                          : (quest.isAccepted ? 'Active' : 'Embark'),
                      style: AppTypography.labelSm.copyWith(
                        color: quest.isCompleted
                            ? AppColors.mintAccent
                            : AppColors.onMintLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 15,
                      color: AppColors.onMintLight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
