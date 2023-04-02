import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:planet_inspector/src/models/planet.dart';
import 'package:planet_inspector/src/models/planet_controller.dart';
import 'package:planet_inspector/src/services/planet_caching.dart';

class Planet extends HookConsumerWidget {
  const Planet({
    required this.planet,
    required this.controller,
    this.rotationDuration = const Duration(seconds: 50),
    this.onPlanetLoaded,
    this.onSceneLoaded,
    super.key,
  });

  final Duration rotationDuration;
  final PlanetModel planet;
  final Function()? onPlanetLoaded;
  final Function()? onSceneLoaded;
  final PlanetController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var scene = useState<Scene?>(null);

    var planetObject = useState<Object?>(null);
    var horizontalAxis = useState(controller.horizontalRotating);
    // listen to the controller to determine if we should move the x or y axis
    useListenable(controller).addListener(() {
      horizontalAxis.value = controller.horizontalRotating;
    });

    var animationController = useAnimationController(
      duration: rotationDuration,
    );
    useListenable(animationController).addListener(() {
      if (planetObject.value != null) {
        if (horizontalAxis.value) {
          planetObject.value?.rotation.y = animationController.value * -360;
          planetObject.value?.rotation.x = 0;
        } else {
          planetObject.value?.rotation.x = animationController.value * -360;
          planetObject.value?.rotation.y = 0;
        }
        planetObject.value?.updateTransform();
        scene.value?.update();
      }
    });

    useEffect(
      () {
        animationController.repeat();
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
