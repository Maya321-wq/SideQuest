import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';

/// Supported glow presets for [GlassContainer].
enum GlassGlowType {
  none,
  mint,
  purple,
  gold,
}

/// Reusable dark glass-style container surface for the Mystic Grove theme.
///
/// Avoids expensive real-time `BackdropFilter` blurs by default to maintain
/// 60fps performance across scrollable lists on Android and Chrome, using
/// layered translucent fills, crisp 1px rim borders, and optional colored glow.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.borderRadius = AppDecorations.radiusCard,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.gradient,
    this.glowType = GlassGlowType.none,
    this.onTap,
    this.width,
    this.height,
    this.clipBehavior = Clip.antiAlias,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final Gradient? gradient;
  final GlassGlowType glowType;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Clip clipBehavior;
  final String? semanticLabel;

  List<BoxShadow> _resolveShadows() {
    switch (glowType) {
      case GlassGlowType.mint:
        return AppDecorations.mintGlow();
      case GlassGlowType.purple:
        return AppDecorations.purpleGlow(offset: Offset.zero);
      case GlassGlowType.gold:
        return AppDecorations.goldGlow();
      case GlassGlowType.none:
        return AppDecorations.cardShadow;
    }
  }

  Color _resolveBorderColor() {
    if (borderColor != null) return borderColor!;
    switch (glowType) {
      case GlassGlowType.mint:
        return AppColors.mintAccent.withValues(alpha: 0.45);
      case GlassGlowType.purple:
        return AppColors.purpleSoft.withValues(alpha: 0.38);
      case GlassGlowType.gold:
        return AppColors.goldRewards.withValues(alpha: 0.45);
      case GlassGlowType.none:
        return AppColors.outline.withValues(alpha: 0.75);
    }
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius resolvedRadius =
        BorderRadius.all(Radius.circular(borderRadius));

    Widget content = Container(
      width: width,
      height: height,
      decoration: AppDecorations.glassSurface(
        color: backgroundColor,
        borderColor: _resolveBorderColor(),
        borderRadius: borderRadius,
        borderWidth: borderWidth,
        gradient: gradient,
        boxShadow: _resolveShadows(),
      ),
      clipBehavior: clipBehavior,
      child: Material(
        type: MaterialType.transparency,
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                borderRadius: resolvedRadius,
                splashColor: AppColors.mintAccent.withValues(alpha: 0.12),
                highlightColor: AppColors.purpleAccent.withValues(alpha: 0.08),
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              )
            : Padding(
                padding: padding,
                child: child,
              ),
      ),
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (semanticLabel != null) {
      return Semantics(
        container: true,
        button: onTap != null,
        label: semanticLabel,
        child: content,
      );
    }

    return content;
  }
}
