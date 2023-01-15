import 'package:flutter/material.dart';

@immutable
class Planet {
  const Planet({
    required this.name,
    required this.shortDescription,
    required this.fullDescription,
    required this.color,
    required this.history,
    required this.assetLocation,
  });

  final String name;
  final String shortDescription;
  final String fullDescription;
  final Color color;
  final String history;
  final String assetLocation;

  Planet copyWith({
    String? name,
    String? shortDescription,
    String? fullDescription,
    Color? color,
    String? history,
    String? assetLocation,
  }) {
    return Planet(
      name: name ?? this.name,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      color: color ?? this.color,
      history: history ?? this.history,
      assetLocation: assetLocation ?? this.assetLocation,
    );
  }
}
