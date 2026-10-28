import 'package:flutter/material.dart';
import '../../../core/models/player_profile.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_container.dart';
import '../../shared/xp_progress_bar.dart';

/// Hero Profile Card displayed at the top of the Hero's Journey screen
/// (`Kaelen Swiftwind`, `Level 12 Mystic Scout`, `650 / 900 XP`,
/// `72% to Level 13 Arch-Seeker` in `Image_6_61dfc242.png` / `Image_7_6effded9.html`).
class HeroHeader extends StatelessWidget {
  const HeroHeader({
    super.key,
    required this.profile,
    this.onEditTap,
  });

  final PlayerProfile profile;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      gradient: AppDecorations.heroCardGradient,
      borderRadius: AppDecorations.radiusCard,
      borderColor: AppColors.purpleSoft.withValues(alpha: 0.35),
      glowType: GlassGlowType.purple,
      padding: const EdgeInsets.all(16.0),
      semanticLabel:
          '${profile.name}, Level ${profile.level} ${profile.classTitle}',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // ─── Left: 80x80 Circular Hero Avatar with Gold/Mint/Purple Frame ──
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: <Color>[
                      AppColors.amberAccent,
                      AppColors.mintAccent,
                      AppColors.purpleSoft,
                    ],
                  ),
                  boxShadow: AppDecorations.goldGlow(
                    opacity: 0.38,
                    blur: 16,
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        Color(0xFF1E3A4C),
                        AppColors.surfaceHigh,
                      ],
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: profile.avatarAssetPath != null
                      ? Image.asset(
                          profile.avatarAssetPath!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const _DefaultFoxHeroAvatar(),
                        )
                      : const _DefaultFoxHeroAvatar(),
                ),
              ),
              // Scout Class Shield Emblem Badge
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.purpleContainer,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.purpleSoft,
                      width: 1.2,
                    ),
                    boxShadow: AppDecorations.cardShadow,
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    size: 15,
                    color: AppColors.mintAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // ─── Right: Name, Tier Title Badge, and XP Progress Bar ───────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        profile.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.heading.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (onEditTap != null)
                      InkWell(
                        onTap: onEditTap,
                        borderRadius: AppDecorations.borderRadiusSm,
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                // Tier Title Pill: "Level 12 Mystic Scout"
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLowest.withValues(alpha: 0.72),
                    borderRadius: AppDecorations.borderRadiusPill,
                    border: Border.all(
                      color: AppColors.purpleSoft.withValues(alpha: 0.32),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.mintAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Level ${profile.level} ${profile.classTitle}',
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.purpleSoft,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Detailed XP Progress Bar
                XpProgressBar(
                  currentXp: profile.currentXp,
                  requiredXp: profile.requiredXp,
                  footerNote:
                      '${profile.xpPercentage}% to Level ${profile.level + 1} ${profile.nextClassTitle}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultFoxHeroAvatar extends StatelessWidget {
  const _DefaultFoxHeroAvatar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: 8,
          right: 10,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.mintAccent.withValues(alpha: 0.65),
              shape: BoxShape.circle,
            ),
          ),
        ),
        const Icon(
          Icons.pets_rounded,
          size: 38,
          color: AppColors.amberAccent,
        ),
      ],
    );
  }
}
