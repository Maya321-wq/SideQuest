import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/data/game_state_repository.dart';
import 'package:sidequest/core/models/field_objective.dart';

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

  test('closely spaced reward claims grant XP only once', () async {
    const questId = 'quest_whispering_shrine';
    final xpBefore = repository.playerProfile.totalXp;
    final reward = repository.getQuestById(questId).xpReward;
    completeObjectives(repository, questId);

    final claims = await Future.wait([
      Future<int>(() => repository.completeQuest(questId)),
      Future<int>(() => repository.completeQuest(questId)),
    ]);

    expect(claims.where((amount) => amount == reward), hasLength(1));
    expect(claims.where((amount) => amount == 0), hasLength(1));
    expect(repository.playerProfile.totalXp, xpBefore + reward);
  });

  test('a different quest can still grant its own reward', () {
    const firstQuestId = 'quest_whispering_shrine';
    const secondQuestId = 'quest_silent_wanderer';
    final xpBefore = repository.playerProfile.totalXp;
    final firstReward = repository.getQuestById(firstQuestId).xpReward;
    final secondReward = repository.getQuestById(secondQuestId).xpReward;

    completeObjectives(repository, firstQuestId);
    expect(repository.completeQuest(firstQuestId), firstReward);
    completeObjectives(repository, secondQuestId);
    expect(repository.completeQuest(secondQuestId), secondReward);

    expect(
      repository.playerProfile.totalXp,
      xpBefore + firstReward + secondReward,
    );
    expect(repository.getQuestById(firstQuestId).isCompleted, isTrue);
    expect(repository.getQuestById(secondQuestId).isCompleted, isTrue);
  });

  test('an incomplete quest cannot complete or claim its reward', () {
    const questId = 'quest_whispering_shrine';
    final xpBefore = repository.playerProfile.totalXp;

    expect(repository.completeQuest(questId), 0);
    expect(repository.getQuestById(questId).isCompleted, isFalse);
    expect(repository.playerProfile.totalXp, xpBefore);
  });
}
