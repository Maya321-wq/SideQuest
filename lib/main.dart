import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/data/game_state_repository.dart';
import 'core/navigation/app_routes.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';
import 'core/widgets/app_bottom_nav_bar.dart';
import 'features/discovery/quest_discovery_screen.dart';
import 'features/journey/hero_journey_screen.dart';
import 'features/map/adventure_map_screen.dart';
import 'features/portal/quest_portal_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.mainSurface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SideQuestApp());
}

/// Root SideQuest application widget.
///
/// Owns the single shared [GameStateRepository] instance and configures the
/// Mystic Grove RPG dark theme (`#0D141E` canvas, `#151C26` surfaces, `#00F5D4`
/// mint accents, `#5541A8` purple accents, and `#FFBE0B` gold rewards) along
/// with the 4-tab [SideQuestShell] and the pushed [AppRoutes.questPortal] route.
class SideQuestApp extends StatefulWidget {
  const SideQuestApp({super.key});

  @override
  State<SideQuestApp> createState() => _SideQuestAppState();
}

class _SideQuestAppState extends State<SideQuestApp> {
  late final GameStateRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = GameStateRepository();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.questPortal:
        final Object? args = settings.arguments;
        String questId = AppRoutes.defaultPortalQuestId;
        if (args is QuestPortalRouteArgs && args.questId.isNotEmpty) {
          questId = args.questId;
        } else if (args is String && args.isNotEmpty) {
          questId = args;
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => QuestPortalScreen(
            repository: _repository,
            questId: questId,
          ),
        );

      case AppRoutes.shell:
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => SideQuestShell(
            repository: _repository,
          ),
        );
    }
  }

  ThemeData _buildMysticGroveTheme() {
    const ColorScheme colorScheme = ColorScheme.dark(
      primary: AppColors.mintAccent,
      onPrimary: AppColors.onMintDark,
      primaryContainer: AppColors.purpleContainer,
      onPrimaryContainer: AppColors.primaryText,
      secondary: AppColors.purpleAccent,
      onSecondary: AppColors.primaryText,
      secondaryContainer: AppColors.elevatedSurface,
      onSecondaryContainer: AppColors.purpleSoft,
      tertiary: AppColors.goldRewards,
      onTertiary: AppColors.onGoldDark,
      surface: AppColors.mainSurface,
      onSurface: AppColors.onSurface,
      error: AppColors.rubyDanger,
      onError: AppColors.primaryText,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.mainSurface,
      cardColor: AppColors.mainSurface,
      dividerColor: AppColors.outline,
      textTheme: AppTypography.textTheme,
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.elevatedSurface,
        contentTextStyle: AppTypography.label,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SideQuest — Mystic Grove RPG',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: _buildMysticGroveTheme(),
      darkTheme: _buildMysticGroveTheme(),
      initialRoute: AppRoutes.shell,
      onGenerateRoute: _onGenerateRoute,
    );
  }
}

/// Persistent 4-tab application shell (`Map`, `Quests`, `Discovery`, `Journey`).
///
/// Uses an [IndexedStack] so scroll positions, search text, and UI state are
/// preserved across tab switches while observing the shared [GameStateRepository].
class SideQuestShell extends StatelessWidget {
  const SideQuestShell({
    super.key,
    required this.repository,
  });

  final GameStateRepository repository;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: repository,
      builder: (BuildContext context, Widget? _) {
        final int currentIndex =
            repository.selectedTabNotifier.value.clamp(0, 3);

        return PopScope(
          canPop: currentIndex == 0,
          onPopInvokedWithResult: (bool didPop, Object? _) {
            if (!didPop && currentIndex != 0) {
              repository.setSelectedTab(0);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: IndexedStack(
              index: currentIndex,
              children: <Widget>[
                // Tab 0: Adventure Map
                AdventureMapScreen(repository: repository),

                // Tab 1: Quests (Accepted / Active Quests Log)
                QuestDiscoveryScreen(
                  repository: repository,
                  activeOnly: true,
                ),

                // Tab 2: Discovery (Full Bounty Board & Exploration)
                QuestDiscoveryScreen(
                  repository: repository,
                  activeOnly: false,
                ),

                // Tab 3: Hero's Journey (Profile, Artifacts, Badges of Honor)
                HeroJourneyScreen(repository: repository),
              ],
            ),
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: currentIndex,
              activeQuestCount: repository.activeQuestsCount,
              onTabSelected: repository.setSelectedTab,
            ),
          ),
        );
      },
    );
  }
}
