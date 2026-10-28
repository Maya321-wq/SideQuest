import 'package:flutter/material.dart';
import '../../../core/models/quest.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/glass_container.dart';

/// Featured Legendary Hero Quest card displayed on the Quest Discovery screen
/// (`Awakening of the Starlight Core` in `Image_4_b964d41a.png` / `Image_5_6e435b77.html`).
class FeaturedQuestCard extends StatelessWidget {
  const FeaturedQuestCard({
    super.key,
    required this.quest,
    required this.onAcceptAndOpen,
    required this.onCardTap,
  });

  final Quest quest;
  final VoidCallback onAcceptAndOpen;
  final VoidCallback onCardTap;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      onTap: onCardTap,
      padding: EdgeInsets.zero,
      borderRadius: AppDecorations.radiusCard,
      backgroundColor: AppColors.mainSurface,
      borderColor: AppColors.purpleSoft.withValues(alpha: 0.32),
      glowType: GlassGlowType.purple,
      semanticLabel:
          'Featured Expedition: ${quest.title}, ${quest.xpReward} XP',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // ─── Top Hero Illustration Banner (176px) ─────────────────────────
          SizedBox(
            height: 176,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _FeaturedBannerArtwork(assetPath: quest.bannerAssetPath),
                // Atmospheric bottom gradient fade into card body
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.transparent,
                        AppColors.mainSurface.withValues(alpha: 0.45),
                        AppColors.mainSurface,
                      ],
                      stops: const <double>[0.25, 0.72, 1.0],
                    ),
                  ),
                ),
                // Top-left floating badge: "Daily Legendary Quest • 30m"
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLowest.withValues(alpha: 0.84),
                      borderRadius: AppDecorations.borderRadiusPill,
                      border: Border.all(
                        color: AppColors.amberAccent.withValues(alpha: 0.45),
                        width: 1.0,
                      ),
                      boxShadow: AppDecorations.goldGlow(
                        opacity: 0.30,
                        blur: 14,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          Icons.military_tech_rounded,
                          size: 14,
                          color: AppColors.amberAccent,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          quest.tierLabel,
                          style: AppTypography.labelSm.copyWith(
                            color: AppColors.goldSoft,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Top-right floating difficulty badge: "Difficulty: Hard"
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLowest.withValues(alpha: 0.84),
                      borderRadius: AppDecorations.borderRadiusPill,
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.45),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      'Difficulty: ${quest.difficulty.label}',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.errorSoft,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── Featured Quest Body ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  quest.title,
                  style: AppTypography.heading.copyWith(
                    color: AppColors.onMintLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  quest.description,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                // Tags & Bounties Rail (+450 XP, Reward: Star Shard, Sunken Falls)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: <Widget>[
                    _RewardChip(
                      icon: Icons.bolt_rounded,
                      label: '+${quest.xpReward} XP',
                      textColor: AppColors.amberAccent,
                    ),
                    _RewardChip(
                      icon: Icons.diamond_outlined,
                      label: quest.bonusReward,
                      textColor: AppColors.mintAccent,
                    ),
                    _RewardChip(
                      icon: Icons.pin_drop_outlined,
                      label: quest.locationName,
                      textColor: AppColors.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Glowing Purple Hero CTA Button
                AppButton(
                  label: quest.isCompleted
                      ? 'Quest Completed'
                      : (quest.isAccepted ? 'Continue Quest' : 'Accept Quest'),
                  leadingIcon: quest.isCompleted
                      ? Icons.check_circle_rounded
                      : Icons.gavel_rounded,
                  onPressed: onAcceptAndOpen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardChip extends StatelessWidget {
  const _RewardChip({
    required this.icon,
    required this.label,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedBannerArtwork extends StatelessWidget {
  const _FeaturedBannerArtwork({this.assetPath});

  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    if (assetPath != null && assetPath!.isNotEmpty) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _FallbackStarlightCavernBanner(),
      );
    }
    return const _FallbackStarlightCavernBanner();
  }
}

class _FallbackStarlightCavernBanner extends StatelessWidget {
  const _FallbackStarlightCavernBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF1A103C),
            Color(0xFF0E2A38),
            Color(0xFF151C26),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _CrystalCavernPainter(),
      ),
    );
  }
}

class _CrystalCavernPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Cyan waterfall & crystal glow
    final Paint cyanGlow = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          AppColors.mintAccent.withValues(alpha: 0.35),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.65, size.height * 0.42),
          radius: size.width * 0.42,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.42),
      size.width * 0.42,
      cyanGlow,
    );

    // Purple crystal spires glow
    final Paint purpleGlow = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          AppColors.purpleGlowLight.withValues(alpha: 0.32),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.28, size.height * 0.48),
          radius: size.width * 0.36,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.28, size.height * 0.48),
      size.width * 0.36,
      purpleGlow,
    );

    // Stylized crystal silhouettes
    final Paint crystalPaint = Paint()
      ..color = AppColors.mintAccent.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    final Path crystal1 = Path()
      ..moveTo(size.width * 0.46, size.height * 0.78)
      ..lineTo(size.width * 0.50, size.height * 0.22)
      ..lineTo(size.width * 0.54, size.height * 0.78)
      ..close();
    canvas.drawPath(crystal1, crystalPaint);

    final Path crystal2 = Path()
      ..moveTo(size.width * 0.55, size.height * 0.78)
      ..lineTo(size.width * 0.58, size.height * 0.36)
      ..lineTo(size.width * 0.61, size.height * 0.78)
      ..close();
    canvas.drawPath(crystal2, crystalPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
