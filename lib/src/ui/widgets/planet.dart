import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:planet_inspector/src/models/planet.dart';

class Planet extends HookWidget {
  const Planet({
    required this.planet,
    required this.interative,
    this.rotationDuration = const Duration(seconds: 50),
    this.scale = 9.0,
    super.key,
  });

  final Duration rotationDuration;
  final PlanetModel planet;
  final bool interative;
  final double scale;

  @override
  Widget build(BuildContext context) {
    var scene = useState<Scene?>(null);

    var earth = useState<Object?>(null);

    var controller = useAnimationController(
      duration: rotationDuration,
    );
    useListenable(controller).addListener(() {
      if (!interative) {
        if (earth.value != null) {
          earth.value?.rotation.x = controller.value * -360;
          earth.value?.updateTransform();
          scene.value?.update();
        }
      }
    });

    useEffect(
      () {
        controller.repeat();
        return null;
      },
      const [],
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Cube(
        onObjectCreated: (object) {},
        onSceneCreated: (scn) {
          scene.value = scn;
          if (interative) {
            scene.value?.camera.position.z = 20;
          } else {
            scene.value?.camera.position.z = 13;
          }
          earth.value = Object(
            name: planet.name,
            scale: Vector3(scale, scale, scale),
            backfaceCulling: false,
            fileName: planet.assetLocation,
          );
          scene.value?.world.add(earth.value!);
        },
        interactive: interative,
      ),
    );
  }
}
