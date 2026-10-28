import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../theme/app_typography.dart';

/// Visual variants for [AppButton].
enum AppButtonVariant {
  /// Vertical royal purple gradient (`#A855F7` -> `#6B21A8`) used on
  /// "Start Quest", "Accept Quest", and "Awesome!".
  primaryPurple,

  /// Horizontal purple-to-cyan gradient (`#6C04DE` -> `#00F5D4`) used on
  /// the Quest Portal "ENTER PORTAL" CTA.
  portalGradient,

  /// Outlined dark slate secondary button (e.g., "Embark >" or "Save").
  secondaryOutlined,

  /// Minimal ghost button for inline actions (e.g., "View All >").
  ghost,
}

/// Reusable Mystic Grove RPG button supporting primary purple/cyan gradients,
/// secondary outlined surfaces, ghost actions, icons, and loading/disabled states.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primaryPurple,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isEnabled = true,
    this.fullWidth = true,
    this.height = 48.0,
    this.borderRadius,
    this.padding,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isEnabled;
  final bool fullWidth;
  final double height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;

  bool get _canInteract => isEnabled && !isLoading && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final bool isGradient = variant == AppButtonVariant.primaryPurple ||
        variant == AppButtonVariant.portalGradient;

    final double resolvedRadius = borderRadius ??
        (isGradient ? AppDecorations.radiusPill : AppDecorations.radiusMd);

    final EdgeInsetsGeometry resolvedPadding = padding ??
        EdgeInsets.symmetric(
          horizontal: variant == AppButtonVariant.ghost ? 8.0 : 18.0,
          vertical: 10.0,
        );

    final Color foregroundColor = _resolveForegroundColor();

    final Widget buttonContent = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (isLoading) ...<Widget>[
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          ),
          const SizedBox(width: 10),
        ] else if (leadingIcon != null) ...<Widget>[
          Icon(
            leadingIcon,
            size: 19,
            color: foregroundColor,
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: (variant == AppButtonVariant.portalGradient
                    ? AppTypography.heading
                    : AppTypography.button)
                .copyWith(
              color: foregroundColor,
              fontSize: variant == AppButtonVariant.secondaryOutlined ? 12 : 14,
            ),
          ),
        ),
        if (!isLoading && trailingIcon != null) ...<Widget>[
          const SizedBox(width: 6),
          Icon(
            trailingIcon,
            size: 16,
            color: foregroundColor,
          ),
        ],
      ],
    );

    return Semantics(
      button: true,
      enabled: _canInteract,
      label: semanticLabel ?? label,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: _canInteract ? 1.0 : 0.48,
        child: Container(
          width: fullWidth ? double.infinity : null,
          height: height,
          decoration: _buildDecoration(resolvedRadius),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: _canInteract ? onPressed : null,
              borderRadius: BorderRadius.all(Radius.circular(resolvedRadius)),
              splashColor: AppColors.primaryText.withValues(alpha: 0.16),
              highlightColor: AppColors.primaryText.withValues(alpha: 0.08),
              child: Padding(
                padding: resolvedPadding,
                child: buttonContent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveForegroundColor() {
    switch (variant) {
      case AppButtonVariant.primaryPurple:
        return AppColors.primaryText;
      case AppButtonVariant.portalGradient:
        return AppColors.primaryText;
      case AppButtonVariant.secondaryOutlined:
        return AppColors.onMintLight;
      case AppButtonVariant.ghost:
        return AppColors.mintAccent;
    }
  }

  BoxDecoration _buildDecoration(double radius) {
    final BorderRadius resolvedBorderRadius =
        BorderRadius.all(Radius.circular(radius));

    switch (variant) {
      case AppButtonVariant.primaryPurple:
        return BoxDecoration(
          gradient: AppDecorations.primaryCtaGradient,
          borderRadius: resolvedBorderRadius,
          border: Border.all(
            color: AppColors.primaryText.withValues(alpha: 0.30),
            width: 1.0,
          ),
          boxShadow: _canInteract ? AppDecorations.purpleGlow() : null,
        );
      case AppButtonVariant.portalGradient:
        return BoxDecoration(
          gradient: AppDecorations.portalCtaGradient,
          borderRadius: resolvedBorderRadius,
          border: Border.all(
            color: AppColors.primaryText.withValues(alpha: 0.32),
            width: 1.0,
          ),
          boxShadow: _canInteract
              ? <BoxShadow>[
                  ...AppDecorations.purpleGlow(opacity: 0.38),
                  ...AppDecorations.mintGlow(opacity: 0.22),
                ]
              : null,
        );
      case AppButtonVariant.secondaryOutlined:
        return BoxDecoration(
          color: AppColors.surfaceHigh.withValues(alpha: 0.90),
          borderRadius: resolvedBorderRadius,
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.70),
            width: 1.0,
          ),
        );
      case AppButtonVariant.ghost:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: resolvedBorderRadius,
        );
    }
  }
}
