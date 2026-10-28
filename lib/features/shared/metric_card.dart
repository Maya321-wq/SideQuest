import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_container.dart';

/// Layout modes for [MetricCard].
enum MetricCardLayout {
  /// Two-column detailed bento tile used in Quest Portal
  /// (icon + label on top row, bold value + subtitle below).
  portalBento,

  /// Four-column centered compact stat tile used in Hero's Journey
  /// (centered icon, bold value, and bottom label).
  journeyRibbon,
}

/// Reusable icon, label, and value metric tile supporting both the 2-column
/// Quest Portal bento grid and the 4-column Hero's Journey lifetime stats ribbon.
class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.subtitleIcon,
    this.iconColor = AppColors.mintAccent,
    this.valueColor = AppColors.primaryText,
    this.subtitleColor,
    this.layout = MetricCardLayout.portalBento,
    this.glowType = GlassGlowType.none,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final IconData? subtitleIcon;
  final Color iconColor;
  final Color valueColor;
  final Color? subtitleColor;
  final MetricCardLayout layout;
  final GlassGlowType glowType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (layout == MetricCardLayout.journeyRibbon) {
      return GlassContainer(
        onTap: onTap,
        glowType: glowType,
        borderRadius: AppDecorations.radiusMd,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        semanticLabel: '$label: $value',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 18,
              color: iconColor,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.button.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return GlassContainer(
      onTap: onTap,
      glowType: glowType,
      borderRadius: AppDecorations.radiusMd,
      padding: const EdgeInsets.all(14.0),
      semanticLabel: '$label: $value ${subtitle ?? ''}'.trim(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: AppDecorations.borderRadiusSm,
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.heading.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 3),
            Row(
              children: <Widget>[
                if (subtitleIcon != null) ...<Widget>[
                  Icon(
                    subtitleIcon,
                    size: 13,
                    color: subtitleColor ?? AppColors.mintAccent,
                  ),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: (subtitleIcon != null
                            ? AppTypography.labelSm
                            : AppTypography.caption)
                        .copyWith(
                      color: subtitleColor ?? AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
