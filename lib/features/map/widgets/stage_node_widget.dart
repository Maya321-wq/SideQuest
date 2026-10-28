import 'package:flutter/material.dart';
import '../../../core/models/stage_node.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_typography.dart';

/// Interactive waypoint node rendered along the Adventure Map S-curve trail.
///
/// Supports three visual states matching the Stitch Adventure Map reference:
/// - [StageStatus.completed]: Glowing cyan/mint flame sprite with numbered pill.
/// - [StageStatus.active] / Boss Portal (Stage 21): Pulsing gold orb with dashed
///   halo ring, crossed swords icon, pulsing stage badge, and "BOSS LAIR" tag.
/// - [StageStatus.locked]: Frosted dimmed lock circle (45% opacity).
class StageNodeWidget extends StatefulWidget {
  const StageNodeWidget({
    super.key,
    required this.stage,
    required this.isSelected,
    required this.onTap,
  });

  final StageNode stage;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<StageNodeWidget> createState() => _StageNodeWidgetState();
}

class _StageNodeWidgetState extends State<StageNodeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StageNode stage = widget.stage;

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label:
          'Stage ${stage.stageNumber}: ${stage.title}, status ${stage.status.name}',
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (BuildContext context, Widget? child) {
            final double pulse = _pulseController.value;
            if (stage.isBossStage || stage.isActive) {
              return _buildActiveBossNode(stage, pulse);
            }
            if (stage.isLocked) {
              return _buildLockedNode(stage);
            }
            return _buildCompletedFlameNode(stage, pulse);
          },
        ),
      ),
    );
  }

  Widget _buildActiveBossNode(StageNode stage, double pulse) {
    final double scale = 1.0 + (pulse * 0.06);
    final bool isCompletedBoss = stage.isCompleted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Transform.scale(
          scale: scale,
          child: SizedBox(
            width: 82,
            height: 82,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: <Widget>[
                // Outer radiating aura
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: isCompletedBoss
                        ? AppDecorations.mintGlow(
                            opacity: 0.45 + (pulse * 0.2),
                            blur: 26,
                          )
                        : AppDecorations.goldGlow(
                            opacity: 0.45 + (pulse * 0.25),
                            blur: 28,
                          ),
                  ),
                ),
                // Dashed outer ring
                CustomPaint(
                  size: const Size(74, 74),
                  painter: _DashedRingPainter(
                    color: isCompletedBoss
                        ? AppColors.mintAccent.withValues(alpha: 0.75)
                        : AppColors.amberAccent.withValues(alpha: 0.75),
                    rotationRadians: pulse * 1.5,
                  ),
                ),
                // Core glowing orb
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isCompletedBoss
                        ? const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: <Color>[
                              AppColors.mintDim,
                              AppColors.mintBright,
                            ],
                          )
                        : const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: <Color>[
                              Color(0xFFD97706),
                              AppColors.amberAccent,
                              AppColors.goldSoft,
                            ],
                          ),
                    border: Border.all(
                      color: widget.isSelected
                          ? AppColors.primaryText
                          : AppColors.primaryText.withValues(alpha: 0.85),
                      width: widget.isSelected ? 2.5 : 2.0,
                    ),
                  ),
                  child: Icon(
                    isCompletedBoss
                        ? Icons.verified_rounded
                        : Icons.gavel_rounded,
                    size: 28,
                    color: AppColors.surfaceLowest,
                  ),
                ),
                // Stage number pill at bottom of orb
                Positioned(
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: isCompletedBoss
                          ? const LinearGradient(
                              colors: <Color>[
                                AppColors.mintDim,
                                AppColors.mintAccent,
                              ],
                            )
                          : AppDecorations.goldGradient,
                      borderRadius: AppDecorations.borderRadiusPill,
                      border: Border.all(
                        color: AppColors.primaryText.withValues(alpha: 0.8),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryText,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${stage.stageNumber}',
                          style: AppTypography.labelSm.copyWith(
                            fontFamily: AppTypography.displayFontFamily,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onGoldDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (stage.shortTag != null) ...<Widget>[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest.withValues(alpha: 0.88),
              borderRadius: AppDecorations.borderRadiusSm,
              border: Border.all(
                color: AppColors.amberAccent.withValues(alpha: 0.45),
                width: 1.0,
              ),
            ),
            child: Text(
              stage.shortTag!.toUpperCase(),
              style: AppTypography.labelSm.copyWith(
                fontSize: 9,
                color: AppColors.goldSoft,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompletedFlameNode(StageNode stage, double pulse) {
    final double dy = (pulse - 0.5) * 4.0;
    return Transform.translate(
      offset: Offset(0, dy),
      child: SizedBox(
        width: 54,
        height: 58,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.mintAccent.withValues(
                  alpha: widget.isSelected ? 0.32 : 0.18,
                ),
                boxShadow: AppDecorations.mintGlow(
                  opacity: widget.isSelected ? 0.55 : 0.35,
                  blur: widget.isSelected ? 20 : 14,
                ),
              ),
            ),
            Icon(
              Icons.local_fire_department_rounded,
              size: widget.isSelected ? 38 : 34,
              color: widget.isSelected
                  ? AppColors.mintBright
                  : AppColors.mintAccent,
            ),
            Positioned(
              bottom: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.5,
                  vertical: 1.5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh.withValues(alpha: 0.94),
                  borderRadius: AppDecorations.borderRadiusPill,
                  border: Border.all(
                    color: widget.isSelected
                        ? AppColors.primaryText
                        : AppColors.mintAccent.withValues(alpha: 0.55),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  '${stage.stageNumber}',
                  style: AppTypography.labelSm.copyWith(
                    fontFamily: AppTypography.displayFontFamily,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mintBright,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedNode(StageNode stage) {
    return Opacity(
      opacity: widget.isSelected ? 0.85 : 0.50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceHigh.withValues(alpha: 0.85),
              border: Border.all(
                color: widget.isSelected
                    ? AppColors.mintAccent
                    : AppColors.outlineVariant,
                width: 1.2,
              ),
            ),
            child: const Icon(
              Icons.lock_rounded,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Stage ${stage.stageNumber}',
            style: AppTypography.labelSm.copyWith(
              fontSize: 9,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedRingPainter extends CustomPainter {
  const _DashedRingPainter({
    required this.color,
    required this.rotationRadians,
  });

  final Color color;
  final double rotationRadians;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width / 2) - 2;
    const int dashCount = 14;
    const double sweepPerDash = (3.14159265 * 2) / (dashCount * 2);

    for (int i = 0; i < dashCount; i++) {
      final double startAngle =
          rotationRadians + (i * sweepPerDash * 2);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepPerDash,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRingPainter oldDelegate) {
    return oldDelegate.rotationRadians != rotationRadians ||
        oldDelegate.color != color;
  }
}
