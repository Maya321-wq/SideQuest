import 'package:flutter/material.dart';
import '../../core/data/game_state_repository.dart';
import '../../core/models/achievement_badge.dart';
import '../../core/models/equipment_item.dart';
import '../../core/models/player_profile.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_chip.dart';
import '../../core/widgets/glass_container.dart';
import '../shared/metric_card.dart';
import 'widgets/badge_tile.dart';
import 'widgets/hero_header.dart';

/// Primary Tab 3: Hero's Journey Screen (`Image_6_61dfc242.png` / `Image_7_6effded9.html`).
///
/// Renders:
/// - Top App Bar ("Your Journey").
/// - [HeroHeader] ("Kaelen Swiftwind", Level 12 Mystic Scout, XP progress bar).
/// - 4-column lifetime statistics ribbon (`5,420 Total XP`, `42 Quests`, `7 Days Streak`, `16/32 Badges`).
/// - "Equipped Artifacts" horizontal rail with 4 inspectable 72×72 artifact tiles.
/// - "Badges of Honor" section with filter chips (`All`, `Recent`, `Mystic`, `Mastery`)
///   and a 2-column responsive grid of [BadgeTile] items that open a detail bottom sheet.
/// - "Hero's Chronicle" milestone banner CTA at the bottom.
class HeroJourneyScreen extends StatelessWidget {
  const HeroJourneyScreen({
    super.key,
    required this.repository,
  });

  final GameStateRepository repository;

  void _showEquipmentDetailSheet(BuildContext context, EquipmentItem item) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        final Color tierColor = _resolveTierColor(item.tier);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GlassContainer(
            backgroundColor: AppColors.mainSurface,
            borderRadius: AppDecorations.radiusXl,
            borderColor: tierColor.withValues(alpha: 0.55),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHigh,
                        borderRadius: AppDecorations.borderRadiusMd,
                        border: Border.all(color: tierColor),
                      ),
                      child: Icon(item.icon, size: 28, color: tierColor),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item.fullTitle,
                            style: AppTypography.heading.copyWith(
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.tier.label,
                            style: AppTypography.labelSm.copyWith(
                              color: tierColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  item.description,
                  style: AppTypography.body.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    borderRadius: AppDecorations.borderRadiusSm,
                  ),
                  child: Text(
                    item.statBoostLabel,
                    style: AppTypography.label.copyWith(
                      color: AppColors.mintAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                AppButton(
                  label: item.isEquipped ? 'Unequip Artifact' : 'Equip Artifact',
                  leadingIcon: item.isEquipped
                      ? Icons.remove_circle_outline_rounded
                      : Icons.check_circle_outline_rounded,
                  onPressed: () {
                    repository.toggleEquipmentItem(item.id);
                    Navigator.of(sheetContext).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBadgeDetailSheet(BuildContext context, AchievementBadge badge) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GlassContainer(
            backgroundColor: AppColors.mainSurface,
            borderRadius: AppDecorations.radiusXl,
            borderColor: badge.isUnlocked
                ? AppColors.mintAccent.withValues(alpha: 0.55)
                : AppColors.outlineVariant,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHigh,
                        borderRadius: AppDecorations.borderRadiusMd,
                        border: Border.all(
                          color: badge.isUnlocked
                              ? AppColors.amberAccent
                              : AppColors.outlineVariant,
                        ),
                      ),
                      child: Icon(
                        badge.icon,
                        size: 26,
                        color: badge.isUnlocked
                            ? AppColors.amberAccent
                            : AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            badge.title,
                            style: AppTypography.heading.copyWith(
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            badge.isUnlocked
                                ? 'Unlocked • +${badge.xpBonus} XP Claimed'
                                : 'Locked • Progress ${badge.progressLabel}',
                            style: AppTypography.labelSm.copyWith(
                              color: badge.isUnlocked
                                  ? AppColors.mintAccent
                                  : AppColors.amberAccent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  badge.loreDetails,
                  style: AppTypography.body.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                AppButton(
                  label: 'Close Scroll',
                  variant: AppButtonVariant.secondaryOutlined,
                  onPressed: () => Navigator.of(sheetContext).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Color _resolveTierColor(ItemTier tier) {
    switch (tier) {
      case ItemTier.epic:
        return AppColors.mintAccent;
      case ItemTier.rare:
        return AppColors.purpleSoft;
      case ItemTier.legendary:
        return AppColors.amberAccent;
      case ItemTier.uncommon:
        return AppColors.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (BuildContext context, Widget? _) {
        final PlayerProfile profile = repository.playerProfile;
        final List<EquipmentItem> equipment = repository.equipment;
        final List<AchievementBadge> badges = repository.filteredBadges;
        final BadgeCategory selectedBadgeCategory =
            repository.selectedBadgeCategoryNotifier.value;

        return Container(
          color: AppColors.background,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                // Top App Bar
                _JourneyTopAppBar(
                  onBackTap: () => repository.setSelectedTab(0),
                ),

                // Main Scrollable Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 28.0),
                    children: <Widget>[
                      // 1. Hero Profile Header Card
                      HeroHeader(profile: profile),
                      const SizedBox(height: 14),

                      // 2. 4-Column Lifetime Stats Ribbon
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: MetricCard(
                              layout: MetricCardLayout.journeyRibbon,
                              icon: Icons.bolt_rounded,
                              iconColor: AppColors.mintAccent,
                              value: profile.formattedTotalXp,
                              label: 'Total XP',
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: MetricCard(
                              layout: MetricCardLayout.journeyRibbon,
                              icon: Icons.task_alt_rounded,
                              iconColor: AppColors.purpleSoft,
                              value: '${profile.completedQuestsCount}',
                              label: 'Quests',
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: MetricCard(
                              layout: MetricCardLayout.journeyRibbon,
                              icon: Icons.local_fire_department_rounded,
                              iconColor: AppColors.amberAccent,
                              value: '${profile.streakDays} Days',
                              label: 'Streak',
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: MetricCard(
                              layout: MetricCardLayout.journeyRibbon,
                              icon: Icons.military_tech_rounded,
                              iconColor: AppColors.mintDim,
                              value:
                                  '${profile.unlockedBadgesCount}/${profile.totalBadgesCount}',
                              label: 'Badges',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // 3. Equipped Artifacts Horizontal Rail
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.gavel_rounded,
                                size: 20,
                                color: AppColors.mintAccent,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Equipped Artifacts',
                                style: AppTypography.heading.copyWith(
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _showEquipmentDetailSheet(
                              context,
                              equipment.first,
                            ),
                            borderRadius: AppDecorations.borderRadiusSm,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'View All',
                                    style: AppTypography.label.copyWith(
                                      color: AppColors.mintAccent,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 16,
                                    color: AppColors.mintAccent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: equipment.map((EquipmentItem item) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: _EquipmentSlotPod(
                                item: item,
                                tierColor: _resolveTierColor(item.tier),
                                onTap: () =>
                                    _showEquipmentDetailSheet(context, item),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 4. Badges of Honor Section Header + Filter Chips
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(
                                Icons.workspace_premium_rounded,
                                size: 20,
                                color: AppColors.amberAccent,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Badges of Honor',
                                style: AppTypography.heading.copyWith(
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.amberAccent.withValues(alpha: 0.16),
                              borderRadius: AppDecorations.borderRadiusPill,
                              border: Border.all(
                                color: AppColors.amberAccent
                                    .withValues(alpha: 0.35),
                              ),
                            ),
                            child: Text(
                              '${profile.unlockedBadgesCount} / ${profile.totalBadgesCount} Unlocked',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.goldSoft,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: BadgeCategory.values
                              .map((BadgeCategory category) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: AppChip(
                                label: category.label,
                                isSelected: category == selectedBadgeCategory,
                                accent: AppChipAccent.purple,
                                compact: true,
                                onTap: () =>
                                    repository.setBadgeCategory(category),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 2x3 Achievement Badge Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: badges.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 1.18,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final AchievementBadge badge = badges[index];
                          return BadgeTile(
                            badge: badge,
                            onTap: () => _showBadgeDetailSheet(context, badge),
                          );
                        },
                      ),
                      const SizedBox(height: 18),

                      // 5. Hero's Chronicle Banner CTA
                      GlassContainer(
                        gradient: LinearGradient(
                          colors: <Color>[
                            AppColors.purpleContainer.withValues(alpha: 0.38),
                            AppColors.surfaceContainer,
                            AppColors.mainSurface,
                          ],
                        ),
                        borderColor:
                            AppColors.purpleSoft.withValues(alpha: 0.32),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.purpleContainer,
                                      shape: BoxShape.circle,
                                      boxShadow: AppDecorations.purpleGlow(
                                        opacity: 0.45,
                                        blur: 12,
                                        offset: Offset.zero,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.auto_stories_rounded,
                                      size: 20,
                                      color: AppColors.purpleSoft,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Hero's Chronicle",
                                          style: AppTypography.button.copyWith(
                                            color: AppColors.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Review 12 past chapter milestones',
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            AppButton(
                              label: 'Read',
                              fullWidth: false,
                              height: 36,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: AppColors.elevatedSurface,
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      'Opening Chapter 3: The Mist Lands chronicle...',
                                      style: AppTypography.label,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _JourneyTopAppBar extends StatelessWidget {
  const _JourneyTopAppBar({required this.onBackTap});

  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.85),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.32),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: onBackTap,
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
          Text(
            'Your Journey',
            style: AppTypography.heading.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: AppDecorations.iconButtonDecoration(),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                const Icon(
                  Icons.notifications_none_rounded,
                  size: 20,
                  color: AppColors.mintAccent,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.mintAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EquipmentSlotPod extends StatelessWidget {
  const _EquipmentSlotPod({
    required this.item,
    required this.tierColor,
    required this.onTap,
  });

  final EquipmentItem item;
  final Color tierColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasGlow =
        item.tier == ItemTier.epic || item.tier == ItemTier.legendary;

    return Semantics(
      button: true,
      label: '${item.name}, ${item.tier.label}',
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              onTap: onTap,
              borderRadius: AppDecorations.borderRadiusItem,
              child: Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: AppColors.mainSurface.withValues(alpha: 0.92),
                  borderRadius: AppDecorations.borderRadiusItem,
                  border: Border.all(
                    color: hasGlow
                        ? tierColor.withValues(alpha: 0.85)
                        : AppColors.outlineVariant.withValues(alpha: 0.45),
                    width: hasGlow ? 1.4 : 1.0,
                  ),
                  boxShadow: hasGlow
                      ? <BoxShadow>[
                          BoxShadow(
                            color: tierColor.withValues(alpha: 0.25),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: AppDecorations.borderRadiusSm,
                        gradient: RadialGradient(
                          colors: <Color>[
                            tierColor.withValues(alpha: 0.24),
                            AppColors.surfaceLowest,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          item.icon,
                          size: 32,
                          color: tierColor,
                        ),
                      ),
                    ),
                    if (item.hasIndicatorDot)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: tierColor,
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: tierColor.withValues(alpha: 0.8),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              item.tier.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTypography.labelSm.copyWith(
                color: tierColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
