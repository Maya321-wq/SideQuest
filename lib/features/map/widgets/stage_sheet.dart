import 'package:flutter/material.dart';
import '../../../core/models/stage_node.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/glass_container.dart';

/// Floating stage information card anchored near the bottom of the Adventure Map.
///
/// Displays the selected stage's status banner ("BOSS PORTAL UNLOCKED"),
/// XP reward tag ("+250 XP"), stage title ("Stage 21: Whispering Grove"),
/// description, requisite pills ("Est. 3 min", "3 Lives", "Legendary Relic"),
/// and the primary "Start Quest" CTA button.
class StageSheet extends StatelessWidget {
  const StageSheet({
    super.key,
    required this.stage,
    required this.onStartQuest,
  });

  final StageNode stage;
  final VoidCallback onStartQuest;

  @override
  Widget build(BuildContext context) {
    final bool isLocked = stage.isLocked;
    final bool isBoss = stage.isBossStage;

    final Color accentColor = isLocked
        ? AppColors.secondaryText
        : (isBoss ? AppColors.amberAccent : AppColors.mintAccent);

    return GlassContainer(
      gradient: AppDecorations.stageSheetGradient,
      borderRadius: AppDecorations.radiusLg,
      borderColor: accentColor.withValues(alpha: 0.42),
      glowType: isBoss ? GlassGlowType.gold : GlassGlowType.mint,
      padding: const EdgeInsets.all(16.0),
      semanticLabel: '${stage.title}, reward ${stage.xpReward} XP',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Top status & XP reward header row
          Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.35),
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.6),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      stage.statusBannerText.toUpperCase(),
                      style: AppTypography.labelSm.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                // +250 XP gold pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.5,
                    vertical: 3.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.amberAccent.withValues(alpha: 0.18),
                    borderRadius: AppDecorations.borderRadiusPill,
                    border: Border.all(
                      color: AppColors.amberAccent.withValues(alpha: 0.55),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.military_tech_rounded,
                        size: 13,
                        color: AppColors.amberAccent,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '+${stage.xpReward} XP',
                        style: AppTypography.labelSm.copyWith(
                          fontFamily: AppTypography.displayFontFamily,
                          color: AppColors.goldSoft,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Stage Title & Teaser
          Text(
            stage.title,
            style: AppTypography.heading.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            stage.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          // Quest requisite & loot mini pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                _RequisiteMiniPill(
                  icon: Icons.timer_outlined,
                  iconColor: AppColors.mintAccent,
                  label: stage.estimatedTimeLabel,
                ),
                const SizedBox(width: 8),
                _RequisiteMiniPill(
                  icon: Icons.favorite_rounded,
                  iconColor: AppColors.rubyDanger,
                  label: stage.livesLabel,
                ),
                const SizedBox(width: 8),
                _RequisiteMiniPill(
                  icon: Icons.stars_rounded,
                  iconColor: AppColors.goldSoft,
                  label: stage.lootLabel,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Start Quest CTA button
          AppButton(
            label: isLocked
                ? 'Complete Previous Stage to Unlock'
                : (stage.isCompleted ? 'Replay Stage Quest' : 'Start Quest'),
            leadingIcon:
                isLocked ? Icons.lock_outline_rounded : Icons.play_arrow_rounded,
            isEnabled: !isLocked,
            onPressed: isLocked ? null : onStartQuest,
          ),
        ],
      ),
    );
  }
}

class _RequisiteMiniPill extends StatelessWidget {
  const _RequisiteMiniPill({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 4.5),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh.withValues(alpha: 0.85),
        borderRadius: AppDecorations.borderRadiusSm,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
