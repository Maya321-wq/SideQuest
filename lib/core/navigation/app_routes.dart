import 'package:flutter/material.dart';

/// Centralized route names and navigation argument contracts for SideQuest.
///
/// The primary four tabs (Map, Quests, Discovery, Journey) live inside the
/// root application shell (`AppRoutes.shell`), while Quest Portal is pushed
/// above the shell via `AppRoutes.questPortal`.
abstract final class AppRoutes {
  /// Root 4-tab application shell route (`/`).
  static const String shell = '/';

  /// Separate pushed route for the Quest Portal briefing screen (`/quest-portal`).
  static const String questPortal = '/quest-portal';

  /// Default quest ID opened if no arguments are supplied to Quest Portal.
  static const String defaultPortalQuestId = 'quest_whispering_shrine';

  /// Pushes the Quest Portal route onto the root [Navigator] with [questId].
  static Future<void> openQuestPortal(
    BuildContext context, {
    required String questId,
  }) {
    return Navigator.of(context).pushNamed(
      questPortal,
      arguments: QuestPortalRouteArgs(questId: questId),
    );
  }
}

/// Strongly-typed route arguments for [AppRoutes.questPortal].
@immutable
class QuestPortalRouteArgs {
  const QuestPortalRouteArgs({required this.questId});

  final String questId;
}
