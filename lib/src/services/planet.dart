import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:planet_inspector/src/models/planet.dart';

// statenotifier provider for all the planets
final planetsProvider = StateNotifierProvider<PlanetService, AllPlanets>(
  (ref) => LocalPlanetService(),
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

  void selectPlanet(PlanetModel planet);

  Future<void> fetchPlanets();
}

class LocalPlanetService extends PlanetService {
  LocalPlanetService() : super();

  @override
  void selectPlanet(PlanetModel planet) {
    state = state.copyWith(selectedPlanetIndex: state.planets.indexOf(planet));
  }

  @override
  Future<void> fetchPlanets() async {
    await Future.delayed(const Duration(seconds: 1));
    state = const AllPlanets(
      planets: [
        // earth
        PlanetModel(
          name: 'Earth',
          shortDescription: 'The third planet from the sun',
          fullDescription: 'The third planet from the sun',
          color: Colors.blue,
          history: 'The third planet from the sun',
          assetLocation: 'assets/planets/earth/earth.obj',
        ),

        // moon
        PlanetModel(
          name: 'Moon',
          shortDescription: 'The moon is Earth\'s only natural satellite',
          fullDescription: 'The moon is Earth\'s only natural satellite',
          color: Colors.grey,
          history: 'The moon is Earth\'s only natural satellite',
          assetLocation: 'assets/planets/mars/mars.obj',
        ),

        // mars
        PlanetModel(
          name: 'Mars',
          shortDescription: 'The fourth planet from the sun',
          fullDescription: 'The fourth planet from the sun',
          color: Colors.deepOrange,
          history: 'The fourth planet from the sun',
          assetLocation: 'assets/planets/mars/mars.obj',
        ),

        // add 4 more planets
        // mars
        PlanetModel(
          name: 'Venus',
          shortDescription: 'The fourth planet from the sun',
          fullDescription: 'The fourth planet from the sun',
          color: Colors.pink,
          history: 'The fourth planet from the sun',
          assetLocation: 'assets/planets/earth/earth.obj',
        ),

        // mars
        PlanetModel(
          name: 'Venus2',
          shortDescription: 'The fourth planet from the sun',
          fullDescription: 'The fourth planet from the sun',
          color: Colors.deepOrange,
          history: 'The fourth planet from the sun',
          assetLocation: 'assets/planets/earth/earth.obj',
        ),

        // mars
        PlanetModel(
          name: 'Venus3',
          shortDescription: 'The fourth planet from the sun',
          fullDescription: 'The fourth planet from the sun',
          color: Colors.deepOrange,
          history: 'The fourth planet from the sun',
          assetLocation: 'assets/planets/mars/mars.obj',
        ),

        // mars
        PlanetModel(
          name: 'Venus4',
          shortDescription: 'The fourth planet from the sun',
          fullDescription: 'The fourth planet from the sun',
          color: Colors.deepOrange,
          history: 'The fourth planet from the sun',
          assetLocation: 'assets/planets/mars/mars.obj',
        ),
      ],
    );
  }
}
