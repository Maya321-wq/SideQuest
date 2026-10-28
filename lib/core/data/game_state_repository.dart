import 'package:flutter/foundation.dart';
import '../models/achievement_badge.dart';
import '../models/equipment_item.dart';
import '../models/field_objective.dart';
import '../models/player_profile.dart';
import '../models/quest.dart';
import '../models/required_artifact.dart';
import '../models/stage_node.dart';
import 'mock_data.dart';

/// Shared application state repository using Flutter's native [ChangeNotifier]
/// and [ValueNotifier] only.
///
/// Observed across Adventure Map, Quest Discovery, Quest Portal, and Hero's
/// Journey so that quest acceptance, objective progress, XP awards, badge
/// unlocks, and stage progression remain synchronized in real time.
class GameStateRepository extends ChangeNotifier {
  GameStateRepository()
      : _playerProfile = MockData.initialPlayerProfile,
        _quests = List<Quest>.of(MockData.initialQuests),
        _stages = List<StageNode>.of(MockData.initialStages),
        _equipment = List<EquipmentItem>.of(MockData.initialEquipment),
        _badges = List<AchievementBadge>.of(MockData.initialBadges),
        selectedTabNotifier = ValueNotifier<int>(0),
        selectedStageNumberNotifier = ValueNotifier<int>(21),
        searchQueryNotifier = ValueNotifier<String>(''),
        selectedQuestCategoryNotifier =
            ValueNotifier<QuestCategory>(QuestCategory.all),
        selectedBadgeCategoryNotifier =
            ValueNotifier<BadgeCategory>(BadgeCategory.all);

  PlayerProfile _playerProfile;
  final List<Quest> _quests;
  final List<StageNode> _stages;
  final List<EquipmentItem> _equipment;
  final List<AchievementBadge> _badges;
  bool _manaWellHarvested = false;

  /// Reactive notifiers for fine-grained UI controls.
  final ValueNotifier<int> selectedTabNotifier;
  final ValueNotifier<int> selectedStageNumberNotifier;
  final ValueNotifier<String> searchQueryNotifier;
  final ValueNotifier<QuestCategory> selectedQuestCategoryNotifier;
  final ValueNotifier<BadgeCategory> selectedBadgeCategoryNotifier;

  // ─── Read-Only State Getters ────────────────────────────────────────────────

  PlayerProfile get playerProfile => _playerProfile;
  List<Quest> get quests => List<Quest>.unmodifiable(_quests);
  List<StageNode> get stages => List<StageNode>.unmodifiable(_stages);
  List<EquipmentItem> get equipment => List<EquipmentItem>.unmodifiable(_equipment);
  List<AchievementBadge> get badges =>
      List<AchievementBadge>.unmodifiable(_badges);
  bool get manaWellHarvested => _manaWellHarvested;

  /// Featured legendary quest shown at the top of Quest Discovery.
  Quest get featuredQuest => _quests.firstWhere(
        (Quest q) => q.isFeatured,
        orElse: () => _quests.first,
      );

  /// Count of quests currently accepted or active in the realm.
  int get activeQuestsCount =>
      _quests.where((Quest q) => q.isAccepted && !q.isCompleted).length;

  /// Currently selected stage on the Adventure Map (defaults to Stage 21).
  StageNode get selectedStage {
    final int stageNum = selectedStageNumberNotifier.value;
    return _stages.firstWhere(
      (StageNode s) => s.stageNumber == stageNum,
      orElse: () => _stages.firstWhere(
        (StageNode s) => s.stageNumber == 21,
        orElse: () => _stages.last,
      ),
    );
  }

  /// Looks up a [Quest] by ID, falling back to `quest_whispering_shrine`.
  Quest getQuestById(String? questId) {
    if (questId == null || questId.isEmpty) {
      return _quests.first;
    }
    return _quests.firstWhere(
      (Quest q) => q.id == questId,
      orElse: () => _quests.first,
    );
  }

  /// Returns non-featured quests filtered by search query and category.
  List<Quest> get filteredDiscoveryQuests {
    final String query = searchQueryNotifier.value.trim().toLowerCase();
    final QuestCategory category = selectedQuestCategoryNotifier.value;

    return _quests.where((Quest quest) {
      if (quest.isFeatured) return false;

      final bool matchesCategory =
          category == QuestCategory.all || quest.category == category;

      final bool matchesQuery = query.isEmpty ||
          quest.title.toLowerCase().contains(query) ||
          quest.description.toLowerCase().contains(query) ||
          quest.locationName.toLowerCase().contains(query) ||
          quest.disciplineTag.toLowerCase().contains(query) ||
          quest.bonusReward.toLowerCase().contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  /// Returns quests that have been accepted by the hero (for the Quests tab).
  List<Quest> get acceptedQuests =>
      _quests.where((Quest q) => q.isAccepted).toList();

  /// Returns achievement badges filtered by the selected [BadgeCategory].
  List<AchievementBadge> get filteredBadges {
    final BadgeCategory category = selectedBadgeCategoryNotifier.value;
    if (category == BadgeCategory.all) {
      return List<AchievementBadge>.unmodifiable(_badges);
    }
    if (category == BadgeCategory.recent) {
      return _badges.where((AchievementBadge b) => b.isRecent).toList();
    }
    return _badges
        .where((AchievementBadge b) => b.category == category)
        .toList();
  }

  // ─── Navigation & Filter Actions ────────────────────────────────────────────

  void setSelectedTab(int index) {
    if (index < 0 || index > 3) return;
    if (selectedTabNotifier.value != index) {
      selectedTabNotifier.value = index;
      notifyListeners();
    }
  }

  void selectStage(int stageNumber) {
    selectedStageNumberNotifier.value = stageNumber;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (searchQueryNotifier.value != query) {
      searchQueryNotifier.value = query;
      notifyListeners();
    }
  }

  void setQuestCategory(QuestCategory category) {
    if (selectedQuestCategoryNotifier.value != category) {
      selectedQuestCategoryNotifier.value = category;
      notifyListeners();
    }
  }

  void setBadgeCategory(BadgeCategory category) {
    if (selectedBadgeCategoryNotifier.value != category) {
      selectedBadgeCategoryNotifier.value = category;
      notifyListeners();
    }
  }

  // ─── Gameplay & State Mutations ─────────────────────────────────────────────

  /// Marks a quest as accepted so it appears in active quests.
  void acceptQuest(String questId) {
    final int index = _quests.indexWhere((Quest q) => q.id == questId);
    if (index == -1) return;

    final Quest current = _quests[index];
    if (!current.isAccepted) {
      _quests[index] = current.copyWith(isAccepted: true);
      notifyListeners();
    }
  }

  /// Toggles the saved/bookmarked status of a quest on the Quest Portal screen.
  void toggleQuestSaved(String questId) {
    final int index = _quests.indexWhere((Quest q) => q.id == questId);
    if (index == -1) return;

    final Quest current = _quests[index];
    _quests[index] = current.copyWith(isSaved: !current.isSaved);
    notifyListeners();
  }

  /// Toggles equipment state of a required artifact on the Quest Portal screen.
  void toggleRequiredArtifact(String questId, String artifactId) {
    final int qIndex = _quests.indexWhere((Quest q) => q.id == questId);
    if (qIndex == -1) return;

    final Quest quest = _quests[qIndex];
    final List<RequiredArtifact> updatedArtifacts =
        quest.requiredArtifacts.map((RequiredArtifact artifact) {
      if (artifact.id != artifactId) return artifact;
      final bool nextEquipped = !artifact.isEquipped;
      return artifact.copyWith(
        isEquipped: nextEquipped,
        statusLabel: nextEquipped ? 'Equipped' : 'Stowed',
      );
    }).toList();

    _quests[qIndex] = quest.copyWith(requiredArtifacts: updatedArtifacts);
    notifyListeners();
  }

  /// Toggles equipped state of an item on the Hero's Journey screen.
  void toggleEquipmentItem(String equipmentId) {
    final int index =
        _equipment.indexWhere((EquipmentItem e) => e.id == equipmentId);
    if (index == -1) return;

    final EquipmentItem current = _equipment[index];
    _equipment[index] = current.copyWith(
      isEquipped: !current.isEquipped,
      hasIndicatorDot: false,
    );
    notifyListeners();
  }

  /// Updates a specific [FieldObjective] inside a quest and automatically
  /// unlocks the next locked objective when an in-progress objective completes.
  void updateObjectiveProgress({
    required String questId,
    required String objectiveId,
    double? progress,
    int? remainingSeconds,
    ObjectiveStatus? status,
  }) {
    final int qIndex = _quests.indexWhere((Quest q) => q.id == questId);
    if (qIndex == -1) return;

    final Quest quest = _quests[qIndex];
    final List<FieldObjective> updatedObjectives =
        List<FieldObjective>.of(quest.objectives);

    final int objIndex =
        updatedObjectives.indexWhere((FieldObjective o) => o.id == objectiveId);
    if (objIndex == -1) return;

    final FieldObjective target = updatedObjectives[objIndex];
    final double nextProgress = (progress ?? target.progress).clamp(0.0, 1.0);
    final ObjectiveStatus nextStatus = status ??
        (nextProgress >= 1.0 ? ObjectiveStatus.completed : target.status);

    updatedObjectives[objIndex] = target.copyWith(
      progress: nextProgress,
      remainingSeconds:
          nextStatus == ObjectiveStatus.completed ? 0 : (remainingSeconds ?? target.remainingSeconds),
      status: nextStatus,
    );

    // If this objective just completed, unlock the next locked objective in sequence.
    if (nextStatus == ObjectiveStatus.completed &&
        objIndex + 1 < updatedObjectives.length &&
        updatedObjectives[objIndex + 1].status == ObjectiveStatus.locked) {
      updatedObjectives[objIndex + 1] = updatedObjectives[objIndex + 1].copyWith(
        status: ObjectiveStatus.inProgress,
        progress: 0.25,
      );
    }

    _quests[qIndex] = quest.copyWith(
      isAccepted: true,
      objectives: updatedObjectives,
    );
    notifyListeners();
  }

  /// Advances the next incomplete objective in [questId] (used for local timer/field
  /// simulation in Quest Portal).
  void advanceNextObjective(String questId) {
    final Quest quest = getQuestById(questId);
    for (final FieldObjective objective in quest.objectives) {
      if (!objective.isCompleted) {
        updateObjectiveProgress(
          questId: questId,
          objectiveId: objective.id,
          progress: 1.0,
          remainingSeconds: 0,
          status: ObjectiveStatus.completed,
        );
        return;
      }
    }
  }

  /// Completes all remaining objectives in [questId] so the quest becomes
  /// eligible for completion after simulated portal entry.
  void completeAllObjectives(String questId) {
    final int qIndex = _quests.indexWhere((Quest q) => q.id == questId);
    if (qIndex == -1) return;

    final Quest quest = _quests[qIndex];
    final List<FieldObjective> completedList = quest.objectives
        .map(
          (FieldObjective o) => o.copyWith(
            status: ObjectiveStatus.completed,
            progress: 1.0,
            remainingSeconds: 0,
          ),
        )
        .toList();

    _quests[qIndex] = quest.copyWith(
      isAccepted: true,
      objectives: completedList,
    );
    notifyListeners();
  }

  /// Completes [questId], awards XP ONLY if the quest is eligible for completion,
  /// updates player level/streak, and advances any linked Adventure Map stage.
  ///
  /// Returns the awarded XP amount (`0` if already completed or ineligible).
  int completeQuest(String questId) {
    final int qIndex = _quests.indexWhere((Quest q) => q.id == questId);
    if (qIndex == -1) return 0;

    final Quest quest = _quests[qIndex];
    if (!quest.isEligibleForCompletion) {
      return 0;
    }

    final int xpAwarded = quest.xpReward;
    _quests[qIndex] = quest.copyWith(
      isAccepted: true,
      isCompleted: true,
    );

    awardXp(
      xpAwarded,
      incrementCompletedQuests: true,
      rubyBonus: 15,
    );

    // Update any stage linked to this quest (e.g., Stage 21 -> completed, Stage 22 -> active).
    for (final StageNode stage in _stages) {
      if (stage.linkedQuestId == questId && stage.status == StageStatus.active) {
        updateStageStatus(stage.stageNumber, StageStatus.completed);
      }
    }

    // Advance locked badge progress to reflect heroic deed.
    _advanceLockedBadges();

    notifyListeners();
    return xpAwarded;
  }

  /// Awards [amount] XP to the shared [PlayerProfile], handling level-up overflow.
  void awardXp(
    int amount, {
    bool incrementCompletedQuests = false,
    int rubyBonus = 0,
  }) {
    if (amount <= 0) return;

    int newCurrentXp = _playerProfile.currentXp + amount;
    int newLevel = _playerProfile.level;
    int newRequiredXp = _playerProfile.requiredXp;
    String newClassTitle = _playerProfile.classTitle;

    while (newCurrentXp >= newRequiredXp) {
      newCurrentXp -= newRequiredXp;
      newLevel += 1;
      newRequiredXp += 150;
      if (newLevel >= 13) {
        newClassTitle = _playerProfile.nextClassTitle;
      }
    }

    _playerProfile = _playerProfile.copyWith(
      level: newLevel,
      currentXp: newCurrentXp,
      requiredXp: newRequiredXp,
      totalXp: _playerProfile.totalXp + amount,
      classTitle: newClassTitle,
      completedQuestsCount: incrementCompletedQuests
          ? _playerProfile.completedQuestsCount + 1
          : _playerProfile.completedQuestsCount,
      streakDays: incrementCompletedQuests
          ? _playerProfile.streakDays + 1
          : _playerProfile.streakDays,
      rubies: _playerProfile.rubies + rubyBonus,
    );

    notifyListeners();
  }

  /// Updates the [StageStatus] of [stageNumber] on the Adventure Map and unlocks
  /// the subsequent stage if [newStatus] is [StageStatus.completed].
  void updateStageStatus(int stageNumber, StageStatus newStatus) {
    final int sIndex =
        _stages.indexWhere((StageNode s) => s.stageNumber == stageNumber);
    if (sIndex == -1) return;

    _stages[sIndex] = _stages[sIndex].copyWith(
      status: newStatus,
      statusBannerText: newStatus == StageStatus.completed
          ? 'STAGE CONQUERED'
          : _stages[sIndex].statusBannerText,
    );

    if (newStatus == StageStatus.completed && sIndex + 1 < _stages.length) {
      final StageNode nextStage = _stages[sIndex + 1];
      if (nextStage.status == StageStatus.locked) {
        _stages[sIndex + 1] = nextStage.copyWith(
          status: StageStatus.active,
          statusBannerText: 'NEW PORTAL UNLOCKED',
        );
        selectedStageNumberNotifier.value = nextStage.stageNumber;
      }
    }

    notifyListeners();
  }

  /// Harvests the interactive Mana Well bonus crystal on the Adventure Map.
  bool harvestManaWell() {
    if (_manaWellHarvested) return false;
    _manaWellHarvested = true;
    _playerProfile = _playerProfile.copyWith(
      energy: _playerProfile.energy + 250,
      rubies: _playerProfile.rubies + 10,
    );
    awardXp(50);
    return true;
  }

  void _advanceLockedBadges() {
    int unlockedDelta = 0;
    for (int i = 0; i < _badges.length; i++) {
      final AchievementBadge badge = _badges[i];
      if (!badge.isUnlocked) {
        final int nextProg = badge.currentProgress + 1;
        final bool nowUnlocked = nextProg >= badge.targetProgress;
        if (nowUnlocked) {
          unlockedDelta += 1;
        }
        _badges[i] = badge.copyWith(
          currentProgress:
              nextProg > badge.targetProgress ? badge.targetProgress : nextProg,
          isUnlocked: nowUnlocked,
          isRecent: nowUnlocked ? true : badge.isRecent,
        );
      }
    }
    if (unlockedDelta > 0) {
      _playerProfile = _playerProfile.copyWith(
        unlockedBadgesCount: _playerProfile.unlockedBadgesCount + unlockedDelta,
      );
    }
  }

  @override
  void dispose() {
    selectedTabNotifier.dispose();
    selectedStageNumberNotifier.dispose();
    searchQueryNotifier.dispose();
    selectedQuestCategoryNotifier.dispose();
    selectedBadgeCategoryNotifier.dispose();
    super.dispose();
  }
}
