import 'package:flutter/material.dart';
import '../../../core/models/achievement_badge.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_typography.dart';

/// Individual achievement badge tile in the 2×3 "Badges of Honor" grid on the
/// Hero's Journey screen (`First Light`, `Shadow Walker`, `Rune Keeper`,
/// `Forest Guardian`, `Dragon Tamer`, `High Summoner`).
class BadgeTile extends StatelessWidget {
  const BadgeTile({
    super.key,
    required this.badge,
    required this.onTap,
  });

  final AchievementBadge badge;
  final VoidCallback onTap;

  Color _resolveAccentColor() {
    switch (badge.accentStyle) {
      case BadgeAccentStyle.gold:
        return AppColors.amberAccent;
      case BadgeAccentStyle.purple:
        return AppColors.purpleSoft;
      case BadgeAccentStyle.mint:
        return AppColors.mintAccent;
      case BadgeAccentStyle.teal:
        return AppColors.mintDim;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = _resolveAccentColor();
    final bool unlocked = badge.isUnlocked;

    return Semantics(
      button: true,
      label: unlocked
          ? '${badge.title}, Unlocked, +${badge.xpBonus} XP Claimed'
          : '${badge.title}, Locked, progress ${badge.progressLabel}',
      child: Opacity(
        opacity: unlocked ? 1.0 : 0.82,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppDecorations.borderRadiusMd,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: unlocked
                    ? AppColors.mainSurface.withValues(alpha: 0.92)
                    : AppColors.surfaceLowest.withValues(alpha: 0.82),
                borderRadius: AppDecorations.borderRadiusMd,
                border: Border.all(
                  color: unlocked
                      ? accent.withValues(alpha: 0.42)
                      : AppColors.outlineVariant.withValues(alpha: 0.32),
                  width: 1.0,
                ),
                boxShadow: unlocked
                    ? <BoxShadow>[
                        BoxShadow(
                          color: accent.withValues(alpha: 0.14),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Top row: Icon Pod + Check or Lock Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: unlocked
                              ? accent.withValues(alpha: 0.18)
                              : AppColors.surfaceHigh,
                          borderRadius: AppDecorations.borderRadiusSm,
                          border: Border.all(
                            color: unlocked
                                ? accent
                                : AppColors.outlineVariant
                                    .withValues(alpha: 0.45),
                            width: 1.0,
                          ),
                          boxShadow: unlocked
                              ? <BoxShadow>[
                                  BoxShadow(
                                    color: accent.withValues(alpha: 0.32),
                                    blurRadius: 10,
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          badge.icon,
                          size: 22,
                          color: unlocked ? accent : AppColors.secondaryText,
                        ),
                      ),
                      Icon(
                        unlocked
                            ? Icons.check_circle_rounded
                            : Icons.lock_outline_rounded,
                        size: 16,
                        color: unlocked
                            ? AppColors.mintAccent
                            : AppColors.secondaryText,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Bottom section: Title, Description, and XP Claimed / Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        badge.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.button.copyWith(
                          color: unlocked
                              ? AppColors.onSurface
                              : AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        badge.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          color: unlocked
                              ? AppColors.onSurfaceVariant
                              : AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (unlocked)
                        Text(
                          '+${badge.xpBonus} XP Claimed',
                          style: AppTypography.labelSm.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Progress',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                Text(
                                  badge.progressLabel,
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.secondaryText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.surfaceHigh,
                                borderRadius: AppDecorations.borderRadiusPill,
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: badge.progressRatio,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: badge.accentStyle ==
                                            BadgeAccentStyle.purple
                                        ? AppColors.purpleSoft
                                            .withValues(alpha: 0.65)
                                        : AppColors.secondaryText,
                                    borderRadius:
                                        AppDecorations.borderRadiusPill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
