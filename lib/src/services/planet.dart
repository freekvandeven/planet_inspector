import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:planet_inspector/src/models/planet.dart';
import 'package:planet_inspector/src/services/planet_caching.dart';

// statenotifier provider for all the planets
final planetsProvider = StateNotifierProvider<PlanetService, AllPlanets>(
  (ref) => LocalPlanetService(ref.read(cachedPlanetAssetsProvider.notifier)),
);

@immutable
class AllPlanets {
  const AllPlanets({
    required this.planets,
    this.selectedPlanetIndex,
  });
  final int? selectedPlanetIndex;
  final List<PlanetModel> planets;

  AllPlanets copyWith({
    int? selectedPlanetIndex,
    List<PlanetModel>? planets,
  }) {
    return AllPlanets(
      selectedPlanetIndex: selectedPlanetIndex ?? this.selectedPlanetIndex,
      planets: planets ?? this.planets,
    );
  }
}

abstract class PlanetService extends StateNotifier<AllPlanets> {
  PlanetService() : super(const AllPlanets(planets: []));

  void selectPlanet(int index);

  void selectNextPlanet() {}

  Future<void> fetchPlanets();
}

class LocalPlanetService extends PlanetService {
  LocalPlanetService(this._planetAssetCachingService) : super();

  final PlanetAssetCachingService _planetAssetCachingService;

  @override
  void selectPlanet(int index) {
    state = state.copyWith(selectedPlanetIndex: index);
  }

  @override
  void selectNextPlanet() {
    state = state.copyWith(
      selectedPlanetIndex:
          (state.selectedPlanetIndex! + 1) % state.planets.length,
    );
  }

  @override
  Future<void> fetchPlanets() async {
    await Future.delayed(const Duration(seconds: 1));
    state = const AllPlanets(
      planets: [
        PlanetModel(
          name: 'Earth',
          shortDescription: 'The third planet from the sun',
          fullDescription: 'The third planet from the sun',
          color: Colors.blue,
          history: 'The third planet from the sun',
          assetLocation: 'assets/planets/earth/earth.obj',
        ),
        PlanetModel(
          name: 'Moon',
          shortDescription: 'The moon is Earth\'s only natural satellite',
          fullDescription: 'The moon is Earth\'s only natural satellite',
          color: Colors.grey,
          history: 'The moon is Earth\'s only natural satellite',
          assetLocation: 'assets/planets/moon/moon.obj',
        ),
        PlanetModel(
          name: 'Mars',
          shortDescription: 'The fourth planet from the sun',
          fullDescription: 'The fourth planet from the sun',
          color: Colors.deepOrange,
          history: 'The fourth planet from the sun',
          assetLocation: 'assets/planets/mars/mars.obj',
        ),
        PlanetModel(
          name: 'Venus',
          shortDescription: 'The fourth planet from the sun',
          fullDescription: 'The fourth planet from the sun',
          color: Colors.pink,
          history: 'The fourth planet from the sun',
          assetLocation: 'assets/planets/venus/venus.obj',
        ),
        PlanetModel(
          name: 'Mercury',
          shortDescription: 'The fourth planet from the sun',
          fullDescription: 'The fourth planet from the sun',
          color: Colors.purple,
          history: 'The fourth planet from the sun',
          assetLocation: 'assets/planets/mercury/mercury.obj',
        ),
        PlanetModel(
          name: 'Pluto',
          shortDescription: 'The fourth planet from the sun',
          fullDescription: 'The fourth planet from the sun',
          color: Colors.deepOrange,
          history: 'The fourth planet from the sun',
          assetLocation: 'assets/planets/pluto/pluto.obj',
        ),
      ],
    );
    await _planetAssetCachingService.cachePlanetAssets(state.planets);
  }
}
