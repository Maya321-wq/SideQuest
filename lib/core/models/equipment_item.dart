import 'package:flutter/material.dart';

/// Rarity tiers for equipped artifacts on the Hero's Journey screen.
enum ItemTier {
  uncommon(label: 'Uncommon'),
  rare(label: 'Rare Tier'),
  epic(label: 'Epic Tier'),
  legendary(label: 'Legendary');

  const ItemTier({required this.label});

  final String label;
}

/// Immutable model representing an equipment item in the "Equipped Artifacts"
/// rail on the Hero's Journey screen.
@immutable
class EquipmentItem {
  const EquipmentItem({
    required this.id,
    required this.name,
    required this.fullTitle,
    required this.tier,
    required this.description,
    required this.statBoostLabel,
    required this.icon,
    this.imageAssetPath,
    this.isEquipped = true,
    this.hasIndicatorDot = false,
  });

  final String id;
  final String name;
  final String fullTitle;
  final ItemTier tier;
  final String description;
  final String statBoostLabel;
  final IconData icon;
  final String? imageAssetPath;
  final bool isEquipped;
  final bool hasIndicatorDot;

  EquipmentItem copyWith({
    String? id,
    String? name,
    String? fullTitle,
    ItemTier? tier,
    String? description,
    String? statBoostLabel,
    IconData? icon,
    String? imageAssetPath,
    bool? isEquipped,
    bool? hasIndicatorDot,
  }) {
    return EquipmentItem(
      id: id ?? this.id,
      name: name ?? this.name,
      fullTitle: fullTitle ?? this.fullTitle,
      tier: tier ?? this.tier,
      description: description ?? this.description,
      statBoostLabel: statBoostLabel ?? this.statBoostLabel,
      icon: icon ?? this.icon,
      imageAssetPath: imageAssetPath ?? this.imageAssetPath,
      isEquipped: isEquipped ?? this.isEquipped,
      hasIndicatorDot: hasIndicatorDot ?? this.hasIndicatorDot,
    );
  }
}
