import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/data/game_state_repository.dart';
import 'package:sidequest/core/models/field_objective.dart';
import 'package:sidequest/features/portal/quest_portal_screen.dart';

void completeObjectives(GameStateRepository repository, String questId) {
  final quest = repository.getQuestById(questId);
  for (final objective in quest.objectives) {
    repository.updateObjectiveProgress(
      questId: questId,
      objectiveId: objective.id,
      progress: 1,
      remainingSeconds: 0,
      status: ObjectiveStatus.completed,
    );
  }
}

void main() {
  late GameStateRepository repository;

  setUp(() {
    repository = GameStateRepository();
  });

  tearDown(() {
    repository.dispose();
  });

  testWidgets('shows objective states, progress, and quest details', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: QuestPortalScreen(
          repository: repository,
          questId: 'quest_whispering_shrine',
        ),
      ),
    );

    expect(find.text('Whispering Shrine Expedition'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('In Progress'), findsOneWidget);
    expect(find.text('Locked'), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
    expect(find.text('05:20'), findsOneWidget);
    expect(find.text('COMPLETE OBJECTIVE'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'timer expiry completes the objective and unlocks the next',
    (tester) async {
      var now = DateTime.utc(2026, 1, 1);
      final xpBefore = repository.playerProfile.totalXp;
      await tester.pumpWidget(
        MaterialApp(
          home: QuestPortalScreen(
            repository: repository,
            questId: 'quest_whispering_shrine',
            now: () => now,
          ),
        ),
      );

      now = now.add(const Duration(seconds: 321));
      await tester.pump(const Duration(seconds: 1));

      final quest = repository.getQuestById('quest_whispering_shrine');
      expect(quest.objectives[1].isCompleted, isTrue);
      expect(quest.completedObjectivesCount, 2);
      expect(quest.objectives[2].status.label, 'In Progress');
      expect(find.text('2 / 3'), findsOneWidget);
      expect(find.text('Locked'), findsNothing);
      expect(find.text('COMPLETE OBJECTIVE'), findsOneWidget);

      now = now.add(const Duration(seconds: 5));
      await tester.pump(const Duration(seconds: 5));
      expect(
        repository
            .getQuestById('quest_whispering_shrine')
            .completedObjectivesCount,
        2,
      );
      expect(repository.playerProfile.totalXp, xpBefore);
    },
  );

  testWidgets('does not expose completion for locked or completed objectives', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: QuestPortalScreen(
          repository: repository,
          questId: 'quest_whispering_shrine',
        ),
      ),
    );

    expect(find.text('COMPLETE OBJECTIVE'), findsNothing);
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Locked'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('timer updates remaining time once per tick', (tester) async {
    var now = DateTime.utc(2026, 1, 1);
    var repositoryNotifications = 0;
    void countNotifications() => repositoryNotifications++;
    repository.addListener(countNotifications);
    addTearDown(() => repository.removeListener(countNotifications));

    await tester.pumpWidget(
      MaterialApp(
        home: QuestPortalScreen(
          repository: repository,
          questId: 'quest_whispering_shrine',
          now: () => now,
        ),
      ),
    );

    repositoryNotifications = 0;
    now = now.add(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(repositoryNotifications, 1);
    expect(
      repository.getQuestById('quest_whispering_shrine').objectives[1]
          .remainingSeconds,
      319,
    );
    expect(find.text('05:19'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('does not run timers for a quest that has not been accepted', (
    tester,
  ) async {
    var now = DateTime.utc(2026, 1, 1);
    await tester.pumpWidget(
      MaterialApp(
        home: QuestPortalScreen(
          repository: repository,
          questId: 'quest_starlight_core',
          now: () => now,
        ),
      ),
    );

    now = now.add(const Duration(seconds: 10));
    await tester.pump(const Duration(seconds: 10));

    expect(
      repository.getQuestById('quest_starlight_core').objectives[1]
          .remainingSeconds,
      300,
    );
    expect(find.text('05:00'), findsOneWidget);
  });

  testWidgets('timer pauses on route exit and resumes from stored time', (
    tester,
  ) async {
    var now = DateTime.utc(2026, 1, 1);
    await tester.pumpWidget(
      MaterialApp(
        home: QuestPortalScreen(
          repository: repository,
          questId: 'quest_whispering_shrine',
          now: () => now,
        ),
      ),
    );

    now = now.add(const Duration(seconds: 10));
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    expect(
      repository.getQuestById('quest_whispering_shrine').objectives[1]
          .remainingSeconds,
      310,
    );

    now = now.add(const Duration(minutes: 1));
    await tester.pump(const Duration(minutes: 1));
    expect(
      repository.getQuestById('quest_whispering_shrine').objectives[1]
          .remainingSeconds,
      310,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: QuestPortalScreen(
          repository: repository,
          questId: 'quest_whispering_shrine',
          now: () => now,
        ),
      ),
    );
    expect(find.text('05:10'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('shows an error when the requested quest is not found', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: QuestPortalScreen(
          repository: repository,
          questId: 'missing-quest',
        ),
      ),
    );

    expect(find.text('This quest is no longer available.'), findsOneWidget);
    expect(find.text('Whispering Shrine Expedition'), findsNothing);
  });

  testWidgets('claims the configured XP reward once and updates progression', (
    tester,
  ) async {
    const questId = 'quest_whispering_shrine';
    final xpBefore = repository.playerProfile.totalXp;
    final completedCountBefore =
        repository.playerProfile.completedQuestsCount;
    final rubiesBefore = repository.playerProfile.rubies;
    final reward = repository.getQuestById(questId).xpReward;
    completeObjectives(repository, questId);

    await tester.pumpWidget(
      MaterialApp(
        home: QuestPortalScreen(repository: repository, questId: questId),
      ),
    );

    expect(find.text('CLAIM $reward XP REWARD'), findsOneWidget);
    await tester.tap(find.text('CLAIM $reward XP REWARD'));
    await tester.pump();

    final completedQuest = repository.getQuestById(questId);
    expect(completedQuest.isCompleted, isTrue);
    expect(repository.playerProfile.totalXp, xpBefore + reward);
    expect(
      repository.playerProfile.completedQuestsCount,
      completedCountBefore + 1,
    );
    expect(repository.playerProfile.level, 13);
    expect(repository.playerProfile.currentXp, 100);
    expect(repository.playerProfile.rubies, rubiesBefore + 15);
    expect(find.text('QUEST COMPLETED'), findsOneWidget);
    expect(find.text('$reward XP reward claimed'), findsOneWidget);
    expect(find.text('CLAIM $reward XP REWARD'), findsNothing);
    expect(find.text('Quest completed! +$reward XP awarded.'), findsOneWidget);

    expect(repository.completeQuest(questId), 0);
    expect(repository.playerProfile.totalXp, xpBefore + reward);

    await tester.pumpWidget(
      MaterialApp(
        home: QuestPortalScreen(repository: repository, questId: questId),
      ),
    );
    expect(find.text('QUEST COMPLETED'), findsOneWidget);
    expect(find.text('CLAIM $reward XP REWARD'), findsNothing);
    expect(repository.playerProfile.totalXp, xpBefore + reward);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('does not offer or award rewards for incomplete quests', (
    tester,
  ) async {
    const questId = 'quest_whispering_shrine';
    final xpBefore = repository.playerProfile.totalXp;

    await tester.pumpWidget(
      MaterialApp(
        home: QuestPortalScreen(repository: repository, questId: questId),
      ),
    );

    expect(find.textContaining('CLAIM '), findsNothing);
    expect(repository.completeQuest(questId), 0);
    expect(repository.playerProfile.totalXp, xpBefore);
    expect(find.textContaining('Quest completed!'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
}
