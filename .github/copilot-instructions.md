# SideQuest — Copilot Project Instructions

## Source of truth
- Follow the SideQuest System Specification & Implementation Blueprint.
- Follow the actual Stitch screenshots in the design/ folder.
- The specification defines behavior and content; Stitch defines visual appearance.
- Do not invent a different design or replace the design with generic Material UI.

## Flutter architecture
- lib/core/theme/ contains global colors, typography and decorations.
- lib/core/widgets/ contains shared buttons, chips, glass containers and navigation.
- lib/core/models/ contains shared data models.
- lib/core/data/mock_data.dart contains sample game data.
- lib/core/navigation/ contains app navigation and shell.
- lib/features/shared/ contains shared XP bars, metric cards and currency pills.
- lib/features/map/ owns Adventure Map.
- lib/features/discovery/ owns Quest Discovery.
- lib/features/portal/ owns Quest Portal.
- lib/features/journey/ owns Hero's Journey.

## Visual design tokens
- Background: #0D141E
- Surface: #151C26
- Elevated surface: #1D2633
- Mint cyan: #00F5D4
- Purple: #5541A8
- Purple glow: #8A2BE2 and #9D4EDD
- Gold: #FFBE0B
- Primary text: #FFFFFF
- Secondary text: #8F9CAE
- Border: #263342

Use shared theme tokens rather than repeating color literals.

## Team boundaries
- Map developer edits lib/features/map/.
- Discovery developer edits lib/features/discovery/.
- Portal developer edits lib/features/portal/.
- Journey developer edits lib/features/journey/.
- Shared foundation files are coordinated by the integration lead.
- Do not edit other developers' feature folders without agreement.
- Do not replace main.dart, models, navigation or pubspec.yaml wholesale.

## Behavior
- Use mock data and local state for the MVP.
- Use the agreed ChangeNotifier approach.
- Simulate GPS and quest timers locally.
- Keep Quest Portal as a detail screen, not a fifth bottom-navigation tab.
- Preserve the specification's quest names, rewards, model fields and sample values.

## Quality checks
- Match the supplied Stitch screenshot as closely as possible.
- Keep layouts responsive at the agreed mobile viewport.
- Reuse shared widgets and avoid duplicated implementations.
- Format changed Dart files and run flutter analyze.
- Report changed files, tested behavior and unresolved visual differences.