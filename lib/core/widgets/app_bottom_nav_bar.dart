import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../theme/app_typography.dart';

/// The four primary bottom-navigation tabs in the SideQuest application shell.
///
/// Note: Quest Portal is a pushed route (`Navigator.pushNamed`), never a tab.
enum AppNavTab {
  map(
    label: 'Map',
    icon: Icons.map_outlined,
    activeIcon: Icons.map_rounded,
  ),
  quests(
    label: 'Quests',
    icon: Icons.gavel_rounded,
    activeIcon: Icons.security_rounded,
  ),
  discovery(
    label: 'Discovery',
    icon: Icons.explore_outlined,
    activeIcon: Icons.explore_rounded,
  ),
  journey(
    label: 'Journey',
    icon: Icons.menu_book_outlined,
    activeIcon: Icons.auto_stories_rounded,
  );

  const AppNavTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

/// Persistent 4-tab bottom navigation bar matching the Google Stitch specs.
///
/// Active tab renders a rounded royal-purple pill (`#6C04DE` at 40% alpha) with
/// glowing mint (`#00F5D4`) icon and bold label.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.activeQuestCount,
  }) : assert(
          currentIndex >= 0 && currentIndex < 4,
          'AppBottomNavBar supports exactly 4 tabs (indices 0..3).',
        );

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final int? activeQuestCount;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    const List<AppNavTab> tabs = AppNavTab.values;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.mainSurface.withValues(alpha: 0.94),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDecorations.radiusCard),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.45),
            width: 1.0,
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.surfaceLowest.withValues(alpha: 0.85),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        top: 6.0,
        bottom: bottomInset > 0 ? bottomInset : 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List<Widget>.generate(tabs.length, (int index) {
          final AppNavTab tab = tabs[index];
          final bool isSelected = index == currentIndex;
          final bool showQuestBadge =
              tab == AppNavTab.quests && (activeQuestCount ?? 0) > 0;

          return Expanded(
            child: Semantics(
              button: true,
              selected: isSelected,
              label: '${tab.label} tab',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => onTabSelected(index),
                    borderRadius: AppDecorations.borderRadiusMd,
                    splashColor: AppColors.mintAccent.withValues(alpha: 0.14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.purpleContainer.withValues(alpha: 0.40)
                            : Colors.transparent,
                        borderRadius: AppDecorations.borderRadiusMd,
                        border: isSelected
                            ? Border.all(
                                color:
                                    AppColors.purpleSoft.withValues(alpha: 0.28),
                                width: 1.0,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Icon(
                                isSelected ? tab.activeIcon : tab.icon,
                                size: 22,
                                color: isSelected
                                    ? AppColors.mintAccent
                                    : AppColors.onSurfaceVariant,
                              ),
                              if (showQuestBadge)
                                Positioned(
                                  right: -6,
                                  top: -3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.mintAccent,
                                      borderRadius:
                                          AppDecorations.borderRadiusPill,
                                    ),
                                    child: Text(
                                      '$activeQuestCount',
                                      style: AppTypography.labelSm.copyWith(
                                        fontSize: 8,
                                        color: AppColors.onMintDark,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            tab.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.labelSm.copyWith(
                              color: isSelected
                                  ? AppColors.mintAccent
                                  : AppColors.onSurfaceVariant,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
