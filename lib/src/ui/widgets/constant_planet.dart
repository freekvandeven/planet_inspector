import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:planet_inspector/src/models/planet.dart';
import 'package:planet_inspector/src/services/planet_caching.dart';

class ConstantPlanet extends HookConsumerWidget {
  const ConstantPlanet({
    required this.planet,
    this.rotationDuration = const Duration(seconds: 50),
    this.onPlanetLoaded,
    this.onSceneLoaded,
    super.key,
  });

  final Duration rotationDuration;
  final PlanetModel planet;
  final Function()? onPlanetLoaded;
  final Function()? onSceneLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var scene = useState<Scene?>(null);

    var planetObject = useState<Object?>(null);

    var controller = useAnimationController(
      duration: rotationDuration,
    );
    useListenable(controller).addListener(() {
      if (planetObject.value != null) {
        planetObject.value?.rotation.y = controller.value * -360;
        planetObject.value?.updateTransform();
        scene.value?.update();
      }
    });

    useEffect(
      () {
        controller.repeat();
        return null;
      },
      const [],
    );

    return Cube(
      onObjectCreated: (object) {
        onPlanetLoaded?.call();
      },
      onSceneCreated: (scn) {
        scene.value = scn;
        scene.value?.camera.position.z = 20;

        // get the cached planet asset
        var cachedPlanets = ref.watch(cachedPlanetAssetsProvider);
        var planetAsset = cachedPlanets[planet.name]!;
        planetObject.value = Object(
          name: planet.name,
          modelfile: planetAsset,
          scale: Vector3(20, 20, 20),
          backfaceCulling: false,
        );
        scene.value?.world.add(planetObject.value!);
        onSceneLoaded?.call();
      },
      interactive: false,
    );
  }
}
