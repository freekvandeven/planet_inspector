import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:planet_inspector/src/models/planet.dart';

// statenotifier provider for all the planets
final planetsProvider = StateNotifierProvider<PlanetService, List<Planet>>(
  (ref) => LocalPlanetService(),
);

abstract class PlanetService extends StateNotifier<List<Planet>> {
  PlanetService() : super([]);

  Future<void> fetchPlanets();
}

class LocalPlanetService extends PlanetService {
  LocalPlanetService() : super();

  @override
  Future<void> fetchPlanets() async {
    await Future.delayed(const Duration(seconds: 1));
    state = [
      // earth
      const Planet(
          name: 'Earth',
          shortDescription: 'The third planet from the sun',
          fullDescription: 'The third planet from the sun',
          color: Colors.blue,
          history: 'The third planet from the sun',
          assetLocation: 'assets/earth.png'),

      // moon
      const Planet(
        name: 'Moon',
        shortDescription: 'The moon is Earth\'s only natural satellite',
        fullDescription: 'The moon is Earth\'s only natural satellite',
        color: Colors.grey,
        history: 'The moon is Earth\'s only natural satellite',
        assetLocation: 'assets/moon.png',
      ),

      // mars
      const Planet(
        name: 'Mars',
        shortDescription: 'The fourth planet from the sun',
        fullDescription: 'The fourth planet from the sun',
        color: Colors.deepOrange,
        history: 'The fourth planet from the sun',
        assetLocation: 'assets/mars.png',
      ),
    ];
  }
}
