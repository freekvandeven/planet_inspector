import 'package:flutter_cube/flutter_cube.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:planet_inspector/src/models/cached_model_provider.dart';
import 'package:planet_inspector/src/models/planet.dart';

final cachedPlanetAssetsProvider = StateNotifierProvider<
    PlanetAssetCachingService, Map<String, CachedAssetModelProvider>>(
  (ref) => PlanetAssetCachingService(),
);

class PlanetAssetCachingService
    extends StateNotifier<Map<String, CachedAssetModelProvider>> {
  PlanetAssetCachingService() : super({});

  Future<void> cachePlanetAssets(List<PlanetModel> planets) async {
    var objects = <String, CachedAssetModelProvider>{};
    for (var planet in planets) {
      objects[planet.name] = CachedAssetModelProvider(
        planet.assetLocation,
      );
    }
    state = objects;
  }
}
