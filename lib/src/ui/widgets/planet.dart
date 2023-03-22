import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:planet_inspector/src/models/planet.dart';

class Planet extends HookWidget {
  const Planet({
    required this.planet,
    required this.interative,
    super.key,
  });
  final PlanetModel planet;
  final bool interative;

  @override
  Widget build(BuildContext context) {
    var scene = useState<Scene?>(null);

    var earth = useState<Object?>(null);

    var controller = useAnimationController(
      duration: const Duration(seconds: 50),
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
      child: TweenAnimationBuilder<double>(
        duration: Duration.zero,
        curve: Curves.easeIn,
        tween: Tween(begin: 0, end: 1),
        builder: (context, animation, child) {
          return Opacity(
            opacity: animation,
            child: Cube(
              onObjectCreated: (object) {},
              onSceneCreated: (scn) {
                scene.value = scn;
                if (interative) {
                  scene.value?.camera.position.z = 20;
                } else {
                  scene.value?.camera.position.z = 13;
                }

                // model from https://free3d.com/3d-model/planet-earth-99065.html
                earth.value = Object(
                  name: 'earth',
                  scale: Vector3(8.0, 8.0, 8.0),
                  backfaceCulling: false,
                  fileName: planet.assetLocation,
                );

                scene.value?.world.add(earth.value!);
              },
              interactive: interative,
            ),
          );
        },
      ),
    );
  }
}
