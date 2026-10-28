import 'package:flutter/material.dart';
import '../models/achievement_badge.dart';
import '../models/equipment_item.dart';
import '../models/field_objective.dart';
import '../models/player_profile.dart';
import '../models/quest.dart';
import '../models/required_artifact.dart';
import '../models/stage_node.dart';

/// Authentic SideQuest seed data matching the Google Stitch screenshots and
/// the Mystic Grove RPG system specification.
abstract final class MockData {
  /// Local asset path for the supplied fantasy map landscape (`Image_12_4b399613.png`).
  static const String adventureMapBackgroundAsset =
      'assets/images/adventure_map_bg.png';

  // ─── Initial Player Profile ─────────────────────────────────────────────────
  static const PlayerProfile initialPlayerProfile = PlayerProfile(
    id: 'hero_kaelen_01',
    name: 'Kaelen Swiftwind',
    mapAlias: 'Little Fox',
    classTitle: 'Mystic Scout',
    nextClassTitle: 'Arch-Seeker',
    currentChapter: 'CHAPTER 3: THE MIST LANDS',
    level: 12,
    currentXp: 650,
    requiredXp: 900,
    totalXp: 5420,
    completedQuestsCount: 42,
    streakDays: 7,
    unlockedBadgesCount: 16,
    totalBadgesCount: 32,
    rubies: 150,
    energy: 2000,
  );

  // ─── Equipped Artifacts (Hero's Journey Rail) ───────────────────────────────
  static const List<EquipmentItem> initialEquipment = <EquipmentItem>[
    EquipmentItem(
      id: 'eq_adventure_hood',
      name: 'Adventure Hood',
      fullTitle: 'Ancient Runic Adventure Hood',
      tier: ItemTier.epic,
      description:
          'Embroidered forest-wool cowl stitched with golden ward runes that dampen footsteps along nocturnal trails.',
      statBoostLabel: '+15% Stealth & Mist Resistance',
      icon: Icons.shield_moon_rounded,
      isEquipped: true,
      hasIndicatorDot: true,
    ),
    EquipmentItem(
      id: 'eq_traveler_satchel',
      name: 'Satchel',
      fullTitle: "Traveler's Alchemical Satchel",
      tier: ItemTier.rare,
      description:
          'Supple leather expedition pack fitted with brass buckles and twin crystal phial holsters for field herbs.',
      statBoostLabel: '+2 Herb & Relic Slots',
      icon: Icons.backpack_rounded,
      isEquipped: true,
    ),
    EquipmentItem(
      id: 'eq_mystic_lantern',
      name: 'Lantern',
      fullTitle: 'Mystic Filigree Lantern',
      tier: ItemTier.legendary,
      description:
          'Antique brass lantern housing an ever-burning starlight ember that reveals hidden rune inscriptions in deep fog.',
      statBoostLabel: '+25% Rune Discovery & Active Glow',
      icon: Icons.flare_rounded,
      isEquipped: true,
      hasIndicatorDot: true,
    ),
    EquipmentItem(
      id: 'eq_brass_compass',
      name: 'Compass',
      fullTitle: 'Celestial Brass Rune Compass',
      tier: ItemTier.uncommon,
      description:
          'Precision navigation instrument engraved with star charts whose needle locks onto nearby ley-line shrines.',
      statBoostLabel: '+10% Waypoint Accuracy',
      icon: Icons.explore_rounded,
      isEquipped: true,
    ),
  ];

  // ─── Badges of Honor (Hero's Journey 2x3 Grid) ──────────────────────────────
  static const List<AchievementBadge> initialBadges = <AchievementBadge>[
    AchievementBadge(
      id: 'badge_first_light',
      title: 'First Light',
      description: 'Complete your inaugural dawn journey',
      loreDetails:
          'Awarded to scouts who step onto the cobblestone path before sunrise and attune their first waystone.',
      category: BadgeCategory.recent,
      xpBonus: 100,
      icon: Icons.light_mode_rounded,
      isUnlocked: true,
      accentStyle: BadgeAccentStyle.gold,
      isRecent: true,
    ),
    AchievementBadge(
      id: 'badge_shadow_walker',
      title: 'Shadow Walker',
      description: 'Explore 5 nocturnal trail paths',
      loreDetails:
          'Granted for navigating five twilight expeditions through the Mist Lands without losing your lantern flame.',
      category: BadgeCategory.mystic,
      xpBonus: 150,
      icon: Icons.dark_mode_rounded,
      isUnlocked: true,
      currentProgress: 5,
      targetProgress: 5,
      accentStyle: BadgeAccentStyle.purple,
      isRecent: true,
    ),
    AchievementBadge(
      id: 'badge_rune_keeper',
      title: 'Rune Keeper',
      description: 'Decipher ancient forest monoliths',
      loreDetails:
          'Earned by translating the glowing cyan glyphs carved into the Sanctuary Ruins and Whispering Shrine.',
      category: BadgeCategory.mystic,
      xpBonus: 250,
      icon: Icons.diamond_rounded,
      isUnlocked: true,
      currentProgress: 3,
      targetProgress: 3,
      accentStyle: BadgeAccentStyle.mint,
    ),
    AchievementBadge(
      id: 'badge_forest_guardian',
      title: 'Forest Guardian',
      description: 'Protect 10 wilderness shrines',
      loreDetails:
          'Bestowed by the elders of Lichen Hollow for tending sacred moss clearings and restoring 10 grove wards.',
      category: BadgeCategory.mastery,
      xpBonus: 180,
      icon: Icons.eco_rounded,
      isUnlocked: true,
      currentProgress: 10,
      targetProgress: 10,
      accentStyle: BadgeAccentStyle.teal,
    ),
    AchievementBadge(
      id: 'badge_dragon_tamer',
      title: 'Dragon Tamer',
      description: 'Conquer 5 Wyrm caverns',
      loreDetails:
          'Venture into the high crystalline crags and calm five slumbering elemental drakes.',
      category: BadgeCategory.mastery,
      xpBonus: 400,
      icon: Icons.pets_rounded,
      isUnlocked: false,
      currentProgress: 2,
      targetProgress: 5,
      accentStyle: BadgeAccentStyle.mint,
    ),
    AchievementBadge(
      id: 'badge_high_summoner',
      title: 'High Summoner',
      description: 'Summon celestial familiars',
      loreDetails:
          'Channel starlight shards at ten arcane beacons to bond with astral spirit companions.',
      category: BadgeCategory.mystic,
      xpBonus: 500,
      icon: Icons.auto_awesome_rounded,
      isUnlocked: false,
      currentProgress: 7,
      targetProgress: 10,
      accentStyle: BadgeAccentStyle.purple,
    ),
  ];

  // ─── Quests (Portal Briefing, Featured Expedition, and Discovery Feed) ─────
  static const List<Quest> initialQuests = <Quest>[
    // 1. Primary Quest Portal / Stage 21 Quest: Whispering Shrine Expedition
    Quest(
      id: 'quest_whispering_shrine',
      title: 'Whispering Shrine Expedition',
      locationOverline: 'SANCTUARY RUINS',
      bannerTitle: 'The Whispering Shrine',
      nodeCode: 'Active Discovery Node #08',
      scoutNoteCode: 'Scout Note #44',
      description:
          'Encounter the Ancient Forest Specter at the overgrown moss sanctuary and reclaim the lost Sun Rune.',
      briefing:
          'Venture beyond the Lantern Trail into the shadowed moss sanctuary. Find tranquility amidst ancient stones, brew herbal potion, and record the whispers of the grove. The forest senses your resolve.',
      optimalPeriod: 'Optimal completion period: Dusk to Midnight',
      category: QuestCategory.mysticGrove,
      disciplineTag: 'Mindful Lore',
      disciplineSubtitle: 'Arcane Attunement',
      difficulty: QuestDifficulty.mythicIII,
      difficultySubtitle: 'Intense Focus',
      tierLabel: 'Epic Tier',
      secondaryTag: 'Mystic Arcana',
      durationMinutes: 25,
      durationSubtitle: 'Outdoor Pacing',
      distanceLabel: '0.2 leagues',
      locationName: 'Whispering Grove Shrine',
      xpReward: 350,
      bonusReward: 'Ancient Rune Drop',
      icon: Icons.auto_stories_rounded,
      isAccepted: true,
      isGpsSynchronized: true,
      objectives: <FieldObjective>[
        FieldObjective(
          id: 'obj_ws_1',
          title: 'Journey to the ancient stone archway',
          subtitle: 'Verified via Proximity GPS (Waypoint Lantern #12)',
          status: ObjectiveStatus.completed,
          progress: 1.0,
          remainingSeconds: 0,
          isGpsVerified: true,
        ),
        FieldObjective(
          id: 'obj_ws_2',
          title: 'Spend 15 minutes in silent observation',
          subtitle: 'Attune your senses to the ambient forest resonance',
          status: ObjectiveStatus.inProgress,
          progress: 0.66,
          remainingSeconds: 320, // 05:20
        ),
        FieldObjective(
          id: 'obj_ws_3',
          title: 'Inscribe one revelation into your field journal',
          subtitle: 'Unlocks upon completing silent observation phase',
          status: ObjectiveStatus.locked,
          progress: 0.0,
        ),
      ],
      requiredArtifacts: <RequiredArtifact>[
        RequiredArtifact(
          id: 'req_lantern',
          name: 'Lantern',
          statusLabel: 'Active Glow',
          icon: Icons.flare_rounded,
          isEquipped: true,
        ),
        RequiredArtifact(
          id: 'req_compass',
          name: 'Rune Compass',
          statusLabel: 'Calibrated',
          icon: Icons.explore_rounded,
          isEquipped: true,
          useAmberAccent: true,
        ),
        RequiredArtifact(
          id: 'req_parchment',
          name: 'Field Parchment',
          statusLabel: 'Ready',
          icon: Icons.menu_book_rounded,
          isEquipped: false,
        ),
      ],
    ),

    // 2. Featured Expedition on Quest Discovery: Awakening of the Starlight Core
    Quest(
      id: 'quest_starlight_core',
      title: 'Awakening of the Starlight Core',
      locationOverline: 'SUNKEN CRYSTAL CAVERNS',
      bannerTitle: 'Starlight Core Sanctum',
      nodeCode: 'Legendary Bounty Node #01',
      scoutNoteCode: 'Scout Note #51',
      description:
          'Venture into the sunken crystal caverns at dusk and attune the celestial pillars before midnight.',
      briefing:
          'Descend beneath Sunken Falls where luminescent cyan cascades feed the subterranean lake. Align all three prism obelisks before the midnight tide submerges the chamber.',
      optimalPeriod: 'Optimal completion period: Twilight to Midnight',
      category: QuestCategory.ancientRuins,
      disciplineTag: 'Arcane Mastery',
      disciplineSubtitle: 'Celestial Resonance',
      difficulty: QuestDifficulty.hard,
      difficultySubtitle: 'High Vigilance',
      tierLabel: 'Daily Legendary Quest • 30m',
      secondaryTag: 'Starlight Relic',
      durationMinutes: 30,
      durationSubtitle: 'Subterranean Trail',
      distanceLabel: '0.6 leagues',
      locationName: 'Sunken Falls',
      xpReward: 450,
      bonusReward: 'Reward: Star Shard',
      icon: Icons.auto_awesome_rounded,
      isFeatured: true,
      objectives: <FieldObjective>[
        FieldObjective(
          id: 'obj_sc_1',
          title: 'Reach the Sunken Falls overlook before dusk',
          subtitle: 'Verified via Proximity GPS (Waterfall Beacon #04)',
          status: ObjectiveStatus.completed,
          progress: 1.0,
          isGpsVerified: true,
        ),
        FieldObjective(
          id: 'obj_sc_2',
          title: 'Channel lantern light across the three crystal pillars',
          subtitle: 'Hold steady focus for 10 minutes of rhythmic breathing',
          status: ObjectiveStatus.inProgress,
          progress: 0.50,
          remainingSeconds: 300,
        ),
        FieldObjective(
          id: 'obj_sc_3',
          title: 'Harvest the resonated Star Shard from the central altar',
          subtitle: 'Unlocks once all three pillars are attuned',
          status: ObjectiveStatus.locked,
          progress: 0.0,
        ),
      ],
      requiredArtifacts: <RequiredArtifact>[
        RequiredArtifact(
          id: 'req_sc_lantern',
          name: 'Lantern',
          statusLabel: 'Active Glow',
          icon: Icons.flare_rounded,
          isEquipped: true,
        ),
        RequiredArtifact(
          id: 'req_sc_compass',
          name: 'Rune Compass',
          statusLabel: 'Calibrated',
          icon: Icons.explore_rounded,
          isEquipped: true,
          useAmberAccent: true,
        ),
      ],
    ),

    // 3. Discovery Card 1: The Silent Wanderer
    Quest(
      id: 'quest_silent_wanderer',
      title: 'The Silent Wanderer',
      locationOverline: 'SHRINE OF WHISPERS',
      bannerTitle: 'Rune Shrine of Whispers',
      nodeCode: 'Active Discovery Node #11',
      scoutNoteCode: 'Scout Note #29',
      description:
          'Walk an unhurried path without checking your crystal mirror and listen to the wind through the pines.',
      briefing:
          'Step away from the bustle of the outpost. Follow the moss-lined footpath to the Rune Shrine of Whispers in complete silence, observing three natural wonders along the way.',
      optimalPeriod: 'Optimal completion period: Dawn or Dusk',
      category: QuestCategory.mysticGrove,
      disciplineTag: 'Mindful',
      disciplineSubtitle: 'Stillness Practice',
      difficulty: QuestDifficulty.gentle,
      difficultySubtitle: 'Calm Pacing',
      tierLabel: 'Rare Tier',
      secondaryTag: 'Mindful Path',
      durationMinutes: 20,
      durationSubtitle: 'Gentle Stroll',
      distanceLabel: '0.3 leagues',
      locationName: 'Rune Shrine of Whispers',
      xpReward: 180,
      bonusReward: 'Badge: Lotus',
      icon: Icons.self_improvement_rounded,
      objectives: <FieldObjective>[
        FieldObjective(
          id: 'obj_sw_1',
          title: 'Arrive at the Rune Shrine of Whispers trailhead',
          subtitle: 'Verified via Proximity GPS (Shrine Marker #03)',
          status: ObjectiveStatus.completed,
          progress: 1.0,
          isGpsVerified: true,
        ),
        FieldObjective(
          id: 'obj_sw_2',
          title: 'Complete a 20-minute unhurried mindful walk',
          subtitle: 'Keep all arcane devices stowed in your satchel',
          status: ObjectiveStatus.inProgress,
          progress: 0.75,
          remainingSeconds: 180,
        ),
      ],
      requiredArtifacts: <RequiredArtifact>[
        RequiredArtifact(
          id: 'req_sw_hood',
          name: 'Adventure Hood',
          statusLabel: 'Equipped',
          icon: Icons.shield_moon_rounded,
          isEquipped: true,
        ),
        RequiredArtifact(
          id: 'req_sw_compass',
          name: 'Rune Compass',
          statusLabel: 'Calibrated',
          icon: Icons.explore_rounded,
          isEquipped: true,
          useAmberAccent: true,
        ),
      ],
    ),

    // 4. Discovery Card 2: Herbalist's Solitude
    Quest(
      id: 'quest_herbalist_solitude',
      title: "Herbalist's Solitude",
      locationOverline: 'LICHEN HOLLOW',
      bannerTitle: 'Lichen Hollow Grove',
      nodeCode: 'Active Discovery Node #14',
      scoutNoteCode: 'Scout Note #38',
      description:
          'Forage bioluminescent dew-fern leaves along the hollow and steep a restorative campfire elixir.',
      briefing:
          'Lichen Hollow blooms with silver-tipped moon ferns after rain. Gather fresh botanicals along the creek bed and catalogue their restorative properties in your herbalist ledger.',
      optimalPeriod: 'Optimal completion period: Late Afternoon',
      category: QuestCategory.wilderness,
      disciplineTag: 'Crafting',
      disciplineSubtitle: 'Botanical Alchemy',
      difficulty: QuestDifficulty.moderate,
      difficultySubtitle: 'Steady Focus',
      tierLabel: 'Epic Tier',
      secondaryTag: 'Alchemical Guild',
      durationMinutes: 45,
      durationSubtitle: 'Foraging Trail',
      distanceLabel: '1.1 leagues',
      locationName: 'Lichen Hollow Grove',
      xpReward: 260,
      bonusReward: 'Elixir ×2',
      icon: Icons.spa_rounded,
      objectives: <FieldObjective>[
        FieldObjective(
          id: 'obj_hs_1',
          title: 'Locate the bioluminescent fern bank in Lichen Hollow',
          subtitle: 'Verified via Proximity GPS (Hollow Creek #07)',
          status: ObjectiveStatus.completed,
          progress: 1.0,
          isGpsVerified: true,
        ),
        FieldObjective(
          id: 'obj_hs_2',
          title: 'Spend 25 minutes sketching and steeping botanicals',
          subtitle: 'Maintain steady warmth over the portable brazier',
          status: ObjectiveStatus.inProgress,
          progress: 0.60,
          remainingSeconds: 240,
        ),
      ],
      requiredArtifacts: <RequiredArtifact>[
        RequiredArtifact(
          id: 'req_hs_satchel',
          name: 'Satchel',
          statusLabel: 'Vials Ready',
          icon: Icons.backpack_rounded,
          isEquipped: true,
        ),
        RequiredArtifact(
          id: 'req_hs_parchment',
          name: 'Field Parchment',
          statusLabel: 'Equipped',
          icon: Icons.menu_book_rounded,
          isEquipped: true,
          useAmberAccent: true,
        ),
      ],
    ),

    // 5. Discovery Card 3: Echoes in the Gloom
    Quest(
      id: 'quest_echoes_gloom',
      title: 'Echoes in the Gloom',
      locationOverline: 'MISTY CAVERN',
      bannerTitle: 'Misty Cavern Threshold',
      nodeCode: 'Active Discovery Node #19',
      scoutNoteCode: 'Scout Note #62',
      description:
          'Trace the acoustic resonance of the cavern threshold and map the hidden campfire alcove.',
      briefing:
          'At the edge of the Mist Lands, ancient scouts carved acoustic chambers into the cliffside. Raise your lantern at the threshold and follow the harmonic echo to the hidden hearth.',
      optimalPeriod: 'Optimal completion period: Evening Twilight',
      category: QuestCategory.campfireLore,
      disciplineTag: 'Exploration',
      disciplineSubtitle: 'Acoustic Cartography',
      difficulty: QuestDifficulty.gentle,
      difficultySubtitle: 'Light Reconnaissance',
      tierLabel: 'Uncommon Tier',
      secondaryTag: 'Cavern Lore',
      durationMinutes: 15,
      durationSubtitle: 'Recon Pacing',
      distanceLabel: '0.8 leagues',
      locationName: 'Misty Cavern Threshold',
      xpReward: 140,
      bonusReward: 'Rune Echo',
      icon: Icons.visibility_rounded,
      objectives: <FieldObjective>[
        FieldObjective(
          id: 'obj_eg_1',
          title: 'Reach the Misty Cavern Threshold',
          subtitle: 'Verified via Proximity GPS (Cavern Arch #19)',
          status: ObjectiveStatus.completed,
          progress: 1.0,
          isGpsVerified: true,
        ),
        FieldObjective(
          id: 'obj_eg_2',
          title: 'Record the harmonic echo interval for 10 minutes',
          subtitle: 'Stand still near the resonant basalt pillar',
          status: ObjectiveStatus.inProgress,
          progress: 0.80,
          remainingSeconds: 120,
        ),
      ],
      requiredArtifacts: <RequiredArtifact>[
        RequiredArtifact(
          id: 'req_eg_lantern',
          name: 'Lantern',
          statusLabel: 'Active Glow',
          icon: Icons.flare_rounded,
          isEquipped: true,
        ),
      ],
    ),
  ];

  // ─── Adventure Map Stage Nodes (Stages 15 to 22) ───────────────────────────
  static const List<StageNode> initialStages = <StageNode>[
    StageNode(
      stageNumber: 15,
      title: "Stage 15: Ember's Camp",
      description:
          'Rest by the crackling hearth and attune your compass before entering the deeper Mist Lands.',
      status: StageStatus.completed,
      xpReward: 120,
      linkedQuestId: 'quest_echoes_gloom',
      normalizedX: 0.45,
      normalizedY: 0.79,
      statusBannerText: 'STAGE CLEARED',
      estimatedTimeLabel: 'Est. 10 min',
      livesLabel: '3 Lives',
      lootLabel: 'Campfire Emblem',
    ),
    StageNode(
      stageNumber: 16,
      title: "Stage 16: Myston's Spire",
      description:
          'Ascend the mist-wreathed watchtower and chart the surrounding bioluminescent canopy.',
      status: StageStatus.completed,
      xpReward: 150,
      linkedQuestId: 'quest_silent_wanderer',
      normalizedX: 0.40,
      normalizedY: 0.68,
      statusBannerText: 'STAGE CLEARED',
      estimatedTimeLabel: 'Est. 15 min',
      livesLabel: '3 Lives',
      lootLabel: 'Spire Sigil',
    ),
    StageNode(
      stageNumber: 17,
      title: 'Stage 17: Lichen Ford',
      description:
          'Cross the glowing turquoise stepping stones and gather dew-fern essence along the bank.',
      status: StageStatus.completed,
      xpReward: 175,
      linkedQuestId: 'quest_herbalist_solitude',
      normalizedX: 0.63,
      normalizedY: 0.59,
      statusBannerText: 'STAGE CLEARED',
      estimatedTimeLabel: 'Est. 20 min',
      livesLabel: '3 Lives',
      lootLabel: 'Elixir ×2',
    ),
    StageNode(
      stageNumber: 18,
      title: 'Stage 18: Sacred Clearing',
      description:
          'Meditate beneath the ancient willow boughs where mana crystals hum with serene energy.',
      status: StageStatus.completed,
      xpReward: 180,
      linkedQuestId: 'quest_silent_wanderer',
      normalizedX: 0.51,
      normalizedY: 0.49,
      statusBannerText: 'STAGE CLEARED',
      estimatedTimeLabel: 'Est. 20 min',
      livesLabel: '3 Lives',
      lootLabel: 'Badge: Lotus',
    ),
    StageNode(
      stageNumber: 19,
      title: 'Stage 19: Echoing Gorge',
      description:
          'Navigate the canyon bridge using your Rune Compass to pierce the nocturnal fog.',
      status: StageStatus.completed,
      xpReward: 200,
      linkedQuestId: 'quest_echoes_gloom',
      normalizedX: 0.50,
      normalizedY: 0.38,
      statusBannerText: 'STAGE CLEARED',
      estimatedTimeLabel: 'Est. 15 min',
      livesLabel: '3 Lives',
      lootLabel: 'Rune Echo',
    ),
    StageNode(
      stageNumber: 20,
      title: 'Stage 20: Sunken Gateway',
      description:
          'Unseal the outer stone archway guarding the approach to the Whispering Grove sanctum.',
      status: StageStatus.completed,
      xpReward: 220,
      linkedQuestId: 'quest_starlight_core',
      normalizedX: 0.60,
      normalizedY: 0.29,
      statusBannerText: 'RECENT VICTORY',
      estimatedTimeLabel: 'Est. 25 min',
      livesLabel: '3 Lives',
      lootLabel: 'Star Shard',
    ),
    StageNode(
      stageNumber: 21,
      title: 'Stage 21: Whispering Grove',
      description:
          'Encounter the Ancient Forest Specter to reclaim the lost Sun Rune.',
      status: StageStatus.active,
      xpReward: 250,
      linkedQuestId: 'quest_whispering_shrine',
      normalizedX: 0.75,
      normalizedY: 0.18,
      shortTag: 'Boss Lair',
      statusBannerText: 'BOSS PORTAL UNLOCKED',
      estimatedTimeLabel: 'Est. 3 min',
      livesLabel: '3 Lives',
      lootLabel: 'Legendary Relic',
      isBossStage: true,
    ),
    StageNode(
      stageNumber: 22,
      title: 'Stage 22: Starlight Sanctum',
      description:
          'Locked until Stage 21: Whispering Grove is conquered. Ascend to the high astral altar.',
      status: StageStatus.locked,
      xpReward: 450,
      linkedQuestId: 'quest_starlight_core',
      normalizedX: 0.59,
      normalizedY: 0.09,
      statusBannerText: 'LOCKED WAYPOINT',
      estimatedTimeLabel: 'Est. 30 min',
      livesLabel: '3 Lives',
      lootLabel: 'Astral Crown',
    ),
  ];
}
