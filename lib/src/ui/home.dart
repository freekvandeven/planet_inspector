import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:planet_inspector/src/services/planet.dart';
import 'package:planet_inspector/src/ui/animated_vertical_text.dart';
import 'package:planet_inspector/src/ui/planet_slider.dart';
import 'package:planet_inspector/src/ui/widgets/constant_planet.dart';

class PlanetOverviewScreen extends HookConsumerWidget {
  const PlanetOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var loading = useState(true);
    var planets = ref.watch(planetsProvider).planets;
    var currentPlanet = useState(0);
    var targetPlanet = useState(0);
    var startupAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 3000),
      initialValue: 0.0,
      upperBound: 1.0,
    );
    var slidingAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
      initialValue: 0.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    var planetAppearingAnimation = useAnimation(
      CurvedAnimation(
        parent: startupAnimationController,
        curve: Curves.easeIn,
      ),
    );

    var listenable = useListenable(slidingAnimationController);
    listenable.addStatusListener(
      (status) {
        if (slidingAnimationController.isCompleted) {
          slidingAnimationController.reset();
          currentPlanet.value = targetPlanet.value;
        }
      },
    );

    useEffect(
      () {
        Future.delayed(Duration.zero, () async {
          await ref.read(planetsProvider.notifier).fetchPlanets();
        });
        return null;
      },
      const [],
    );
    var size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        GestureDetector(
          // on swipe left go to next planet
          // on swipe right go to previous planet
          onHorizontalDragUpdate: (details) {
            if (targetPlanet.value == currentPlanet.value) {
              if (details.delta.dx > 0) {
                targetPlanet.value = (currentPlanet.value - 1) % planets.length;
                // animation back
              } else {
                targetPlanet.value = (currentPlanet.value + 1) % planets.length;
              }
              slidingAnimationController.forward();
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          // icon search
                          Icon(Icons.search, color: Colors.black, size: 30.0),

                          Text(
                            'XORE',
                            style:
                                TextStyle(fontSize: 30.0, color: Colors.black),
                          ),

                          // icon enlarge
                          Icon(
                            Icons.fullscreen_sharp,
                            color: Colors.black,
                            size: 30.0,
                          ),
                        ],
                      ),
                      // vertical text of the planet
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      AnimatedVerticalText(
                        currentText: (planets.isNotEmpty)
                            ? planets[currentPlanet.value].name
                            : '',
                        targetText: (planets.isNotEmpty)
                            ? planets[targetPlanet.value].name
                            : '',
                        animationController: slidingAnimationController,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        // white helmet edge around the planet
        Positioned(
          top: size.height * 0.4,
          child: GestureDetector(
            onTap: () async {
              ref
                  .read(planetsProvider.notifier)
                  .selectPlanet(currentPlanet.value);
              await Navigator.of(context).pushNamed(
                '/planet',
              );
            },
            child: Container(
              width: size.width * 0.5,
              height: size.width * 0.5,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                // shadow to the bottom
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(0.0, 5.0),
                  ),
                ],
              ),
            ),
          ),
        ),
        // black background for the planet
        Positioned(
          top: size.height * 0.4 + size.width * 0.05,
          child: GestureDetector(
            onTap: () async {
              ref
                  .read(planetsProvider.notifier)
                  .selectPlanet(currentPlanet.value);
              await Navigator.of(context).pushNamed(
                '/planet',
              );
            },
            child: Container(
              width: size.width * 0.4,
              height: size.width * 0.4,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        if (planets.isNotEmpty) ...[
          for (var i = 0; i < 2; i++) ...[
            Positioned(
              top: size.height * 0.4 + size.width * 0.23,
              left: size.width * 0.35 + size.width * 0.3 * i,
              child: Opacity(
                opacity: planetAppearingAnimation,
                child: SizedBox(
                  width: size.width * 0.3,
                  height: size.width * 0.3,
                  child: ConstantPlanet(
                    planet: planets[i],
                    onSceneLoaded: () {},
                    onPlanetLoaded: () async {
                      Future.delayed(const Duration(seconds: 1), () {
                        loading.value = false;
                        startupAnimationController.forward(from: 0.0);
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ],
        // add a ring of shadow around the planet
        // add shadow within the transparent circle
        Positioned(
          top: size.height * 0.4 + size.width * 0.05,
          child: Container(
            width: size.width * 0.4,
            height: size.width * 0.4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  inset: true,
                  blurRadius: 10.0,
                  spreadRadius: 20.0,
                ),
              ],
            ),
          ),
        ),

        if (planets.isNotEmpty) ...[
          Column(
            children: [
              const Spacer(),
              PlanetSliderWidget(
                planetOrbitAnimationController: slidingAnimationController,
                planets: planets,
                currentPlanet: currentPlanet.value,
                targetPlanet: targetPlanet.value,
                onPlanetChanged: (selectedPlanet) {
                  if (targetPlanet.value == currentPlanet.value) {
                    // check if going forward or backward
                    targetPlanet.value = selectedPlanet;
                    slidingAnimationController.forward();
                  }
                },
                opacity: planetAppearingAnimation,
                height: size.height * 0.3,
                width: size.width,
              ),
            ],
          ),
        ],
        if (loading.value) ...[
          Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ]
      ],
    );
  }
}
