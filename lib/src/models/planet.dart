import 'package:flutter/material.dart';

@immutable
class PlanetModel {
  const PlanetModel({
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

  PlanetModel copyWith({
    String? name,
    String? shortDescription,
    String? fullDescription,
    Color? color,
    String? history,
    String? assetLocation,
  }) {
    return PlanetModel(
      name: name ?? this.name,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      color: color ?? this.color,
      history: history ?? this.history,
      assetLocation: assetLocation ?? this.assetLocation,
    );
  }
}
