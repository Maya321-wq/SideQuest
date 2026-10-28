import 'package:flutter/material.dart';

/// Immutable model representing a recommended or required artifact for a quest
/// on the Quest Portal screen (e.g., Lantern, Rune Compass, Field Parchment).
@immutable
class RequiredArtifact {
  const RequiredArtifact({
    required this.id,
    required this.name,
    required this.statusLabel,
    required this.icon,
    this.isEquipped = true,
    this.useAmberAccent = false,
  });

  final String id;
  final String name;
  final String statusLabel;
  final IconData icon;
  final bool isEquipped;
  final bool useAmberAccent;

  RequiredArtifact copyWith({
    String? id,
    String? name,
    String? statusLabel,
    IconData? icon,
    bool? isEquipped,
    bool? useAmberAccent,
  }) {
    return RequiredArtifact(
      id: id ?? this.id,
      name: name ?? this.name,
      statusLabel: statusLabel ?? this.statusLabel,
      icon: icon ?? this.icon,
      isEquipped: isEquipped ?? this.isEquipped,
      useAmberAccent: useAmberAccent ?? this.useAmberAccent,
    );
  }
}
