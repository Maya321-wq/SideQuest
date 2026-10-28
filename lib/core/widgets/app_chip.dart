import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../theme/app_typography.dart';

/// Accent color styles for selected [AppChip] instances.
enum AppChipAccent {
  /// Mint selected fill (`#00F5D4`) used on Quest Discovery category filters.
  mint,

  /// Royal purple selected fill (`#6C04DE`) used on Hero's Journey badge filters.
  purple,

  /// Gold/Amber pill used for reward and difficulty tags.
  gold,
}

/// Reusable selectable category chip and metadata pill.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.leadingIcon,
    this.accent = AppChipAccent.mint,
    this.compact = false,
    this.semanticLabel,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? leadingIcon;
  final AppChipAccent accent;
  final bool compact;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _resolveBackground();
    final Color borderColor = _resolveBorderColor();
    final Color foregroundColor = _resolveForegroundColor();

    final EdgeInsetsGeometry padding = compact
        ? const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0)
        : const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.5);

    return Semantics(
      button: onTap != null,
      selected: isSelected,
      label: semanticLabel ?? label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppDecorations.borderRadiusPill,
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
          boxShadow: isSelected ? _resolveGlow() : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppDecorations.borderRadiusPill,
            splashColor: AppColors.mintAccent.withValues(alpha: 0.16),
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (leadingIcon != null) ...<Widget>[
                    Icon(
                      leadingIcon,
                      size: compact ? 13 : 15,
                      color: foregroundColor,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    label,
                    style: (compact
                            ? AppTypography.labelSm
                            : AppTypography.label)
                        .copyWith(
                      color: foregroundColor,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveBackground() {
    if (!isSelected) {
      return AppColors.surfaceHigh.withValues(alpha: 0.72);
    }
    switch (accent) {
      case AppChipAccent.mint:
        return AppColors.mintAccent;
      case AppChipAccent.purple:
        return AppColors.purpleContainer;
      case AppChipAccent.gold:
        return AppColors.goldRewards.withValues(alpha: 0.22);
    }
  }

  Color _resolveBorderColor() {
    if (!isSelected) {
      return AppColors.outlineVariant.withValues(alpha: 0.45);
    }
    switch (accent) {
      case AppChipAccent.mint:
        return AppColors.mintBright;
      case AppChipAccent.purple:
        return AppColors.purpleSoft.withValues(alpha: 0.55);
      case AppChipAccent.gold:
        return AppColors.goldRewards.withValues(alpha: 0.65);
    }
  }

  Color _resolveForegroundColor() {
    if (!isSelected) {
      return AppColors.onSurfaceVariant;
    }
    switch (accent) {
      case AppChipAccent.mint:
        return AppColors.onMintDark;
      case AppChipAccent.purple:
        return AppColors.primaryText;
      case AppChipAccent.gold:
        return AppColors.goldSoft;
    }
  }

  List<BoxShadow>? _resolveGlow() {
    switch (accent) {
      case AppChipAccent.mint:
        return AppDecorations.mintGlow(opacity: 0.25, blur: 12);
      case AppChipAccent.purple:
        return AppDecorations.purpleGlow(
          opacity: 0.35,
          blur: 12,
          offset: Offset.zero,
        );
      case AppChipAccent.gold:
        return AppDecorations.goldGlow(opacity: 0.25, blur: 12);
    }
  }
}
