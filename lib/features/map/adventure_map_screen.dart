import 'dart:ui' show PathMetric;
import 'package:flutter/material.dart';
import '../../core/data/game_state_repository.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/player_profile.dart';
import '../../core/models/stage_node.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../shared/currency_pill.dart';
import '../shared/xp_progress_bar.dart';
import 'widgets/stage_node_widget.dart';
import 'widgets/stage_sheet.dart';

/// Primary Tab 0: Adventure Map Screen matching the Stitch reference
/// (`Image_8_0298af91.png` / `Image_9_5c432e9d.html`).
///
/// Renders:
/// - Full-screen fantasy landscape (`assets/images/adventure_map_bg.png`) with
///   a custom-painted twilight fallback if the local asset is missing.
/// - Glowing dashed S-curve path connecting Stages 15 through 22.
/// - Interactive Mana Well bonus crystal touchpoint.
/// - Top App Bar ("Your Journey" / "CHAPTER 3: THE MIST LANDS") and compact
///   Hero & Resource HUD rail ("Little Fox", Level 12, XP bar, 150 Rubies, 2,000 Energy).
/// - Floating [StageSheet] for the selected stage (defaulting to Stage 21: Whispering Grove)
///   that opens the pushed [AppRoutes.questPortal] route on "Start Quest".
class AdventureMapScreen extends StatelessWidget {
  const AdventureMapScreen({
    super.key,
    required this.repository,
  });

  final GameStateRepository repository;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (BuildContext context, Widget? _) {
        final PlayerProfile player = repository.playerProfile;
        final List<StageNode> stages = repository.stages;
        final StageNode selectedStage = repository.selectedStage;

        return Container(
          color: AppColors.surfaceLowest,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // ─── Layer 0: Map Background + Vignette + Winding Trail ─────────
              _MapWorldCanvas(stages: stages),

              // ─── Layer 1: Interactive Stage Waypoints & Mana Well ───────────
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double width = constraints.maxWidth;
                  final double height = constraints.maxHeight;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      // Interactive Mana Well bonus touchpoint
                      Positioned(
                        left: 16,
                        top: height * 0.43,
                        child: _ManaWellTouchpoint(
                          isHarvested: repository.manaWellHarvested,
                          onTap: () {
                            final bool harvested = repository.harvestManaWell();
                            if (harvested && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: AppColors.elevatedSurface,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    'Mana Well harvested! +50 XP, +250 Energy, +10 Rubies',
                                    style: AppTypography.label,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),

                      // Stage Nodes 15..22
                      for (final StageNode stage in stages)
                        Positioned(
                          left: (width * stage.normalizedX) -
                              (stage.isBossStage ? 41 : 27),
                          top: (height * stage.normalizedY) -
                              (stage.isBossStage ? 41 : 29),
                          child: StageNodeWidget(
                            stage: stage,
                            isSelected:
                                stage.stageNumber == selectedStage.stageNumber,
                            onTap: () =>
                                repository.selectStage(stage.stageNumber),
                          ),
                        ),
                    ],
                  );
                },
              ),

              // ─── Layer 2: Top App Bar + Hero HUD Rail + Bottom Stage Sheet ──
              SafeArea(
                bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Top App Bar + Compact HUD Rail
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _MapTopAppBar(
                          chapterSubtitle: player.currentChapter,
                          onJumpToJourney: () => repository.setSelectedTab(3),
                          onNotificationsTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: AppColors.elevatedSurface,
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  'Stage 21 Boss Portal is active in the Whispering Grove!',
                                  style: AppTypography.label,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: _CompactHeroHudRail(
                            player: player,
                            onProfileTap: () => repository.setSelectedTab(3),
                          ),
                        ),
                      ],
                    ),

                    // Floating Active Stage Sheet
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
                      child: StageSheet(
                        stage: selectedStage,
                        onStartQuest: () {
                          repository.acceptQuest(selectedStage.linkedQuestId);
                          AppRoutes.openQuestPortal(
                            context,
                            questId: selectedStage.linkedQuestId,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MapTopAppBar extends StatelessWidget {
  const _MapTopAppBar({
    required this.chapterSubtitle,
    required this.onJumpToJourney,
    required this.onNotificationsTap,
  });

  final String chapterSubtitle;
  final VoidCallback onJumpToJourney;
  final VoidCallback onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.82),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.32),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Semantics(
            button: true,
            label: 'View Hero Journey',
            child: InkWell(
              onTap: onJumpToJourney,
              borderRadius: AppDecorations.borderRadiusMd,
              child: Container(
                width: 40,
                height: 40,
                decoration: AppDecorations.iconButtonDecoration(),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Your Journey',
                style: AppTypography.heading.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                chapterSubtitle,
                style: AppTypography.labelSm.copyWith(
                  color: AppColors.mintAccent,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          Semantics(
            button: true,
            label: 'Notifications',
            child: InkWell(
              onTap: onNotificationsTap,
              borderRadius: AppDecorations.borderRadiusMd,
              child: Container(
                width: 40,
                height: 40,
                decoration: AppDecorations.iconButtonDecoration(),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.notifications_none_rounded,
                      size: 20,
                      color: AppColors.onSurface,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.amberAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.background,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactHeroHudRail extends StatelessWidget {
  const _CompactHeroHudRail({
    required this.player,
    required this.onProfileTap,
  });

  final PlayerProfile player;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: AppColors.mainSurface.withValues(alpha: 0.88),
        borderRadius: AppDecorations.borderRadiusMd,
        border: Border.all(
          color: AppColors.primaryText.withValues(alpha: 0.12),
          width: 1.0,
        ),
        boxShadow: AppDecorations.cardShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Left: Little Fox avatar + level badge + compact XP bar
          Flexible(
            child: InkWell(
              onTap: onProfileTap,
              borderRadius: AppDecorations.borderRadiusSm,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Container(
                        width: 44,
                        height: 44,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHighest,
                          borderRadius: AppDecorations.borderRadiusSm,
                          border: Border.all(
                            color: AppColors.amberAccent.withValues(alpha: 0.75),
                            width: 1.5,
                          ),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                AppColors.heroGradientStart,
                                AppColors.elevatedSurface,
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.pets_rounded,
                            size: 22,
                            color: AppColors.amberAccent,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLowest,
                            borderRadius: AppDecorations.borderRadiusPill,
                            border: Border.all(
                              color: AppColors.amberAccent,
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            '${player.level}',
                            style: AppTypography.labelSm.copyWith(
                              fontFamily: AppTypography.displayFontFamily,
                              fontSize: 9,
                              color: AppColors.amberAccent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: SizedBox(
                      width: 102,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            player.mapAlias,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.label.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          XpProgressBar(
                            currentXp: player.currentXp,
                            requiredXp: player.requiredXp,
                            compact: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            height: 32,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: AppColors.outlineVariant.withValues(alpha: 0.45),
          ),
          // Right: Ruby & Energy CurrencyPills
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CurrencyPill.rubies(amount: player.rubies),
              const SizedBox(width: 6),
              CurrencyPill.energy(amount: player.energy),
            ],
          ),
        ],
      ),
    );
  }
}

class _ManaWellTouchpoint extends StatelessWidget {
  const _ManaWellTouchpoint({
    required this.isHarvested,
    required this.onTap,
  });

  final bool isHarvested;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: !isHarvested,
      label: isHarvested ? 'Mana Well Depleted' : 'Harvest Mana Well',
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: isHarvested ? null : onTap,
          borderRadius: AppDecorations.borderRadiusMd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest.withValues(alpha: 0.78),
              borderRadius: AppDecorations.borderRadiusMd,
              border: Border.all(
                color: isHarvested
                    ? AppColors.outlineVariant.withValues(alpha: 0.35)
                    : AppColors.mintAccent.withValues(alpha: 0.45),
                width: 1.0,
              ),
              boxShadow: isHarvested
                  ? null
                  : AppDecorations.mintGlow(opacity: 0.22, blur: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.mintAccent.withValues(alpha: 0.18),
                    borderRadius: AppDecorations.borderRadiusSm,
                  ),
                  child: Icon(
                    Icons.diamond_rounded,
                    size: 18,
                    color: isHarvested
                        ? AppColors.secondaryText
                        : AppColors.mintAccent,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Mana Well',
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.onMintLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      isHarvested ? 'Harvested' : 'Harvestable',
                      style: AppTypography.labelSm.copyWith(
                        fontSize: 9,
                        color: isHarvested
                            ? AppColors.secondaryText
                            : AppColors.mintDim,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapWorldCanvas extends StatelessWidget {
  const _MapWorldCanvas({required this.stages});

  final List<StageNode> stages;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Supplied fantasy landscape asset with rich atmospheric fallback
        Image.asset(
          MockData.adventureMapBackgroundAsset,
          fit: BoxFit.cover,
          errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
          ) {
            return const _FallbackMysticLandscape();
          },
        ),
        // Dark twilight readability vignette overlay
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.surfaceLowest.withValues(alpha: 0.85),
                AppColors.surfaceLowest.withValues(alpha: 0.28),
                AppColors.surfaceLowest.withValues(alpha: 0.92),
              ],
              stops: const <double>[0.0, 0.45, 1.0],
            ),
          ),
        ),
        // Winding dashed cyan S-curve trail connecting stages
        CustomPaint(
          painter: _WindingTrailPainter(stages: stages),
        ),
      ],
    );
  }
}

class _FallbackMysticLandscape extends StatelessWidget {
  const _FallbackMysticLandscape();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF0A192F),
            Color(0xFF0D2838),
            Color(0xFF09131E),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _FallbackForestSilhouettePainter(),
      ),
    );
  }
}

class _FallbackForestSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Distant glowing mist pools
    final Paint mistPaint = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          AppColors.mintAccent.withValues(alpha: 0.22),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.55, size.height * 0.42),
          radius: size.width * 0.55,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.42),
      size.width * 0.55,
      mistPaint,
    );

    final Paint purpleMist = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          AppColors.purpleContainer.withValues(alpha: 0.20),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.25, size.height * 0.25),
          radius: size.width * 0.45,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.25),
      size.width * 0.45,
      purpleMist,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WindingTrailPainter extends CustomPainter {
  const _WindingTrailPainter({required this.stages});

  final List<StageNode> stages;

  @override
  void paint(Canvas canvas, Size size) {
    if (stages.length < 2) return;

    final List<Offset> points = stages
        .map(
          (StageNode s) =>
              Offset(size.width * s.normalizedX, size.height * s.normalizedY),
        )
        .toList();

    final Path path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final Offset current = points[i];
      final Offset next = points[i + 1];
      final double midY = (current.dy + next.dy) / 2;
      path.cubicTo(
        current.dx,
        midY,
        next.dx,
        midY,
        next.dx,
        next.dy,
      );
    }

    // Outer diffused cyan trail glow
    final Paint glowPaint = Paint()
      ..color = AppColors.mintAccent.withValues(alpha: 0.24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(path, glowPaint);

    // Dashed inner bright cyan trail
    final Paint dashPaint = Paint()
      ..color = AppColors.mintBright.withValues(alpha: 0.78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      const double dashLength = 5.0;
      const double gapLength = 10.0;
      while (distance < metric.length) {
        final double end = (distance + dashLength).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), dashPaint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WindingTrailPainter oldDelegate) =>
      oldDelegate.stages != stages;
}
