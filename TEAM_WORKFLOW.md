# SideQuest Team Workflow

## Screen ownership
- Member 1: lib/features/adventure_map/
- Member 2: lib/features/quest_discovery/
- Member 3: lib/features/quest_portal/
- Member 4: lib/features/hero_journey/

## Shared foundation
The integration lead coordinates:
- lib/main.dart
- lib/app/
- lib/shared/
- pubspec.yaml

Ask before changing shared models, navigation, dependencies, or game state.

## Git rules
- Do not commit directly to main during feature development.
- Create a feature branch for each task.
- Pull the latest main before starting work.
- Push feature branches and open Pull Requests.
- Test changes before requesting review.

## Navigation
Bottom tabs: Map, Quests, Discovery, Journey.
Quest Portal opens as a detail screen from a selected quest.
