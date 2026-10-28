import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';

/// Reusable animated XP progress bar used in both the Hero's Journey profile
/// header and the Adventure Map compact HUD rail.
///
/// Clamps progress strictly to the `0.0 - 1.0` range.
class XpProgressBar extends StatelessWidget {
  const XpProgressBar({
    super.key,
    required this.currentXp,
    required this.requiredXp,
    this.showHeaderLabels = true,
    this.headerLabel = 'XP Progress',
    this.footerNote,
    this.showPercentageInFooter = false,
    this.compact = false,
    this.barHeight,
    this.gradient,
  });

  final int currentXp;
  final int requiredXp;
  final bool showHeaderLabels;
  final String headerLabel;
  final String? footerNote;
  final bool showPercentageInFooter;
  final bool compact;
  final double? barHeight;
  final Gradient? gradient;

  /// Clamped progress ratio in `[0.0, 1.0]`.
  double get progress {
    if (requiredXp <= 0) return 0.0;
    return (currentXp / requiredXp).clamp(0.0, 1.0);
  }

  int get percentage => (progress * 100).round();

  @override
  Widget build(BuildContext context) {
    final double resolvedHeight = barHeight ?? (compact ? 6.0 : 10.0);
    final Gradient resolvedGradient = gradient ??
        (compact
            ? AppDecorations.goldGradient
            : AppDecorations.xpBarGradient);

    return Semantics(
      label: '$headerLabel: $currentXp of $requiredXp XP ($percentage percent)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showHeaderLabels) ...<Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  compact ? '$currentXp XP' : headerLabel,
                  style: AppTypography.labelSm.copyWith(
                    fontSize: compact ? 9 : 10,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  compact ? '$requiredXp' : '$currentXp / $requiredXp XP',
                  style: AppTypography.labelSm.copyWith(
                    fontSize: compact ? 9 : 10,
                    color: compact
                        ? AppColors.onSurfaceVariant
                        : AppColors.amberAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? 3.0 : 5.0),
          ],
          Container(
            height: resolvedHeight,
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: AppDecorations.borderRadiusPill,
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.35),
                width: 1.0,
              ),
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double fillWidth = constraints.maxWidth * progress;
                return Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeOutCubic,
                    width: fillWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: resolvedGradient,
                      borderRadius: AppDecorations.borderRadiusPill,
                      boxShadow: AppDecorations.goldGlow(
                        opacity: 0.45,
                        blur: compact ? 6 : 10,
                      ),
                    ),
                    child: !compact && fillWidth > 12
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 7,
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryText,
                                borderRadius: AppDecorations.borderRadiusPill,
                              ),
                            ),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          if (!compact && (footerNote != null || showPercentageInFooter)) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              footerNote ?? '$percentage% to next level',
              textAlign: TextAlign.right,
              style: AppTypography.labelSm.copyWith(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.85),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
