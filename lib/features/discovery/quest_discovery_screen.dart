import 'package:flutter/material.dart';
import '../../core/data/game_state_repository.dart';
import '../../core/models/quest.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_chip.dart';
import '../../core/widgets/glass_container.dart';
import 'widgets/featured_quest_card.dart';
import 'widgets/quest_card.dart';

/// Primary Discovery & Quests Screen (`Image_4_b964d41a.png` / `Image_5_6e435b77.html`).
///
/// Supports both:
/// - **Tab 2 (Discovery):** Full Bounty Board with search bar, category filter rail,
///   Featured Legendary Expedition (`Awakening of the Starlight Core`), filtered
///   Available Quests feed, empty state, and World Map Sync teaser card.
/// - **Tab 1 (Quests):** Active accepted quests view (`activeOnly: true`) so
///   the 4-tab shell (`Map`, `Quests`, `Discovery`, `Journey`) provides a dedicated
///   active quest board alongside full discovery.
class QuestDiscoveryScreen extends StatefulWidget {
  const QuestDiscoveryScreen({
    super.key,
    required this.repository,
    this.activeOnly = false,
  });

  final GameStateRepository repository;
  final bool activeOnly;

  @override
  State<QuestDiscoveryScreen> createState() => _QuestDiscoveryScreenState();
}

class _QuestDiscoveryScreenState extends State<QuestDiscoveryScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.repository.searchQueryNotifier.value,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openPortal(BuildContext context, Quest quest, {bool accept = false}) {
    if (accept) {
      widget.repository.acceptQuest(quest.id);
    }
    AppRoutes.openQuestPortal(context, questId: quest.id);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repository,
      builder: (BuildContext context, Widget? _) {
        final Quest featured = widget.repository.featuredQuest;
        final QuestCategory selectedCategory =
            widget.repository.selectedQuestCategoryNotifier.value;
        final List<Quest> displayedQuests = widget.activeOnly
            ? widget.repository.acceptedQuests
            : widget.repository.filteredDiscoveryQuests;

        return Container(
          color: AppColors.background,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                // Shared TopAppBar
                _DiscoveryTopAppBar(
                  onBackTap: () => widget.repository.setSelectedTab(0),
                  onNotificationTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.elevatedSurface,
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          '${widget.repository.activeQuestsCount} active quests synchronized with your regional compass.',
                          style: AppTypography.label,
                        ),
                      ),
                    );
                  },
                ),

                // Scrollable Bounty Board Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 28.0),
                    children: <Widget>[
                      // Overline + Screen Title + Active Count Pill
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.activeOnly
                                    ? 'ACCEPTED BOUNTIES & EXPEDITIONS'
                                    : 'BOUNTY BOARD & EXPLORATION',
                                style: AppTypography.labelSm.copyWith(
                                  color: AppColors.mintAccent,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.9,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.activeOnly
                                    ? 'Active Quests'
                                    : 'Quest Discovery',
                                style: AppTypography.headlineMd.copyWith(
                                  color: AppColors.onMintLight,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.mainSurface,
                              borderRadius: AppDecorations.borderRadiusPill,
                              border: Border.all(
                                color:
                                    AppColors.mintAccent.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: AppColors.mintAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${widget.repository.activeQuestsCount + 10} Active',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.mintAccent,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (!widget.activeOnly) ...<Widget>[
                        const SizedBox(height: 12),
                        // Search Input & Filter Tune Button
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.mainSurface
                                      .withValues(alpha: 0.92),
                                  borderRadius: AppDecorations.borderRadiusMd,
                                  border: Border.all(
                                    color: AppColors.outlineVariant
                                        .withValues(alpha: 0.45),
                                  ),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: widget.repository.setSearchQuery,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.onSurface,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 11,
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(
                                      Icons.search_rounded,
                                      size: 18,
                                      color: AppColors.secondaryText,
                                    ),
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.close_rounded,
                                              size: 16,
                                              color: AppColors.secondaryText,
                                            ),
                                            onPressed: () {
                                              _searchController.clear();
                                              widget.repository
                                                  .setSearchQuery('');
                                            },
                                          )
                                        : null,
                                    hintText:
                                        'Search adventures, runes, regions...',
                                    hintStyle: AppTypography.caption.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Semantics(
                              button: true,
                              label: 'Reset Quest Filters',
                              child: InkWell(
                                onTap: () {
                                  _searchController.clear();
                                  widget.repository.setSearchQuery('');
                                  widget.repository
                                      .setQuestCategory(QuestCategory.all);
                                },
                                borderRadius: AppDecorations.borderRadiusMd,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration:
                                      AppDecorations.iconButtonDecoration(),
                                  child: const Icon(
                                    Icons.tune_rounded,
                                    size: 20,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Horizontal Category Filter Rail
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: QuestCategory.values
                                .map((QuestCategory category) {
                              final bool isSelected =
                                  category == selectedCategory;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: AppChip(
                                  label: category.label,
                                  leadingIcon: category.icon,
                                  isSelected: isSelected,
                                  accent: AppChipAccent.mint,
                                  onTap: () => widget.repository
                                      .setQuestCategory(category),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Featured Expedition Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.stars_rounded,
                                  size: 15,
                                  color: AppColors.amberAccent,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'FEATURED EXPEDITION',
                                  style: AppTypography.labelSm.copyWith(
                                    color: AppColors.amberAccent,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Resets 11h 24m',
                              style: AppTypography.labelSm.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Featured Quest Card
                        FeaturedQuestCard(
                          quest: featured,
                          onCardTap: () => _openPortal(context, featured),
                          onAcceptAndOpen: () =>
                              _openPortal(context, featured, accept: true),
                        ),
                      ],

                      const SizedBox(height: 22),

                      // Available Quests Section Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            widget.activeOnly
                                ? 'In-Progress & Accepted'
                                : 'Available Quests',
                            style: AppTypography.heading.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            widget.activeOnly
                                ? '${displayedQuests.length} Tracked'
                                : 'Sorted by Nearby',
                            style: AppTypography.labelSm.copyWith(
                              color: AppColors.mintAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Filtered Quest Cards or Empty State
                      if (displayedQuests.isEmpty)
                        _EmptyDiscoveryState(
                          onReset: () {
                            _searchController.clear();
                            widget.repository.setSearchQuery('');
                            widget.repository
                                .setQuestCategory(QuestCategory.all);
                            if (widget.activeOnly) {
                              widget.repository.setSelectedTab(2);
                            }
                          },
                        )
                      else
                        ...displayedQuests.map(
                          (Quest quest) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: QuestCard(
                              quest: quest,
                              onEmbark: () =>
                                  _openPortal(context, quest, accept: true),
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      // World Map Sync Teaser Card
                      GlassContainer(
                        gradient: AppDecorations.heroCardGradient,
                        borderColor:
                            AppColors.purpleSoft.withValues(alpha: 0.35),
                        onTap: () => widget.repository.setSelectedTab(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'WORLD MAP SYNC',
                                    style: AppTypography.labelSm.copyWith(
                                      color: AppColors.mintAccent,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.9,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Track Active Waypoints',
                                    style: AppTypography.heading.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Pin your accepted bounties directly to the live regional compass.',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color:
                                    AppColors.mintAccent.withValues(alpha: 0.18),
                                borderRadius: AppDecorations.borderRadiusMd,
                                border: Border.all(
                                  color: AppColors.mintAccent,
                                  width: 1.0,
                                ),
                                boxShadow: AppDecorations.mintGlow(
                                  opacity: 0.28,
                                  blur: 14,
                                ),
                              ),
                              child: const Icon(
                                Icons.map_outlined,
                                size: 24,
                                color: AppColors.mintAccent,
                              ),
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

class _DiscoveryTopAppBar extends StatelessWidget {
  const _DiscoveryTopAppBar({
    required this.onBackTap,
    required this.onNotificationTap,
  });

  final VoidCallback onBackTap;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.85),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.30),
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
          InkWell(
            onTap: onNotificationTap,
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
                      decoration: const BoxDecoration(
                        color: AppColors.mintAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDiscoveryState extends StatelessWidget {
  const _EmptyDiscoveryState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.explore_off_rounded,
            size: 40,
            color: AppColors.mintAccent,
          ),
          const SizedBox(height: 10),
          Text(
            'No Matching Quests Found',
            style: AppTypography.heading.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 6),
          Text(
            'No bounties in this region match your current rune filter or search terms.',
            textAlign: TextAlign.center,
            style: AppTypography.caption,
          ),
          const SizedBox(height: 14),
          AppButton(
            label: 'Show All Quests',
            variant: AppButtonVariant.secondaryOutlined,
            fullWidth: false,
            height: 40,
            onPressed: onReset,
          ),
        ],
      ),
    );
  }
}
