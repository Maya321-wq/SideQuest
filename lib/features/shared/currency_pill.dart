import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';

/// Supported HUD currency/resource types in SideQuest.
enum CurrencyType {
  /// Ruby gems (`150` in the Map HUD) with ruby flare accent.
  rubies,

  /// Arcane energy bolts (`2,000` in the Map HUD) with mint accent.
  energy,
}

/// Compact Ruby and Energy resource capsule displayed in the Adventure Map HUD.
class CurrencyPill extends StatelessWidget {
  const CurrencyPill({
    super.key,
    required this.type,
    required this.formattedAmount,
    this.onTap,
  });

  /// Convenience factory for a Ruby gem capsule.
  factory CurrencyPill.rubies({
    Key? key,
    required int amount,
    VoidCallback? onTap,
  }) {
    return CurrencyPill(
      key: key,
      type: CurrencyType.rubies,
      formattedAmount: _formatInt(amount),
      onTap: onTap,
    );
  }

  /// Convenience factory for an Energy bolt capsule.
  factory CurrencyPill.energy({
    Key? key,
    required int amount,
    VoidCallback? onTap,
  }) {
    return CurrencyPill(
      key: key,
      type: CurrencyType.energy,
      formattedAmount: _formatInt(amount),
      onTap: onTap,
    );
  }

  final CurrencyType type;
  final String formattedAmount;
  final VoidCallback? onTap;

  static String _formatInt(int value) {
    final String raw = value.toString();
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return raw.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final bool isRuby = type == CurrencyType.rubies;
    final Color accentColor =
        isRuby ? AppColors.rubyDanger : AppColors.mintAccent;
    final IconData iconData =
        isRuby ? Icons.diamond_rounded : Icons.bolt_rounded;
    final String semanticType = isRuby ? 'Rubies' : 'Energy';

    return Semantics(
      label: '$formattedAmount $semanticType',
      button: onTap != null,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDecorations.borderRadiusSm,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.5,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh.withValues(alpha: 0.92),
              borderRadius: AppDecorations.borderRadiusSm,
              border: Border.all(
                color: accentColor.withValues(alpha: 0.25),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  iconData,
                  size: 15,
                  color: accentColor,
                ),
                const SizedBox(width: 4),
                Text(
                  formattedAmount,
                  style: AppTypography.label.copyWith(
                    fontFamily: AppTypography.displayFontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
