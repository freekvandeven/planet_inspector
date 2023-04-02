import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:planet_inspector/src/models/planet_controller.dart';
import 'package:planet_inspector/src/services/planet.dart';
import 'package:planet_inspector/src/services/planet_opacity.dart';
import 'package:planet_inspector/src/services/planet_position.dart';
import 'package:planet_inspector/src/services/planet_size.dart';
import 'package:planet_inspector/src/ui/animated_vertical_text.dart';
import 'package:planet_inspector/src/ui/widgets/planet.dart';
import 'package:planet_inspector/src/ui/widgets/planet_slider.dart';

class PlanetOverviewScreen extends HookConsumerWidget {
  const PlanetOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var removeFacades = useState(false);
    var loading = useState(true);
    var homeScreen = useState(true);
    var planets = ref.watch(planetsProvider).planets;
    var currentPlanet = useState(0);
    var targetPlanet = useState(0);
    var planetsLoaded = useState(0);
    var planetController = useState(PlanetController());
    var movingForward = useState(true);
    var startupAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
      initialValue: 0.0,
      upperBound: 1.0,
    );
    var slidingAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
      initialValue: 0.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    var sceneTransitionAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 2000),
      initialValue: 0.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    var sceneTransitionAnimation = useAnimation(
      CurvedAnimation(
        parent: sceneTransitionAnimationController,
        curve: Curves.easeIn,
      ),
    );
    var planetAppearingAnimation = useAnimation(
      CurvedAnimation(
        parent: startupAnimationController,
        curve: Curves.easeIn,
      ),
    );
    var slidingAnimation = useAnimation(
      CurvedAnimation(
        parent: slidingAnimationController,
        curve: Curves.easeInOut,
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
    var sceneTransitionListenable =
        useListenable(sceneTransitionAnimationController);
    sceneTransitionListenable.addStatusListener(
      (status) {
        if (sceneTransitionAnimationController.isCompleted) {
          sceneTransitionAnimationController.reset();
          homeScreen.value = !homeScreen.value;
          planetController.value.changePlanetRotation();
        }
      },
    );

    useEffect(
      () {
        Future.delayed(Duration.zero, () async {
          await ref.read(planetsProvider.notifier).fetchPlanets();
        });
        return () => planetController.dispose();
      },
      const [],
    );
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (homeScreen.value) {
          return true;
        } else {
          homeScreen.value = true;
          planetController.value.changePlanetRotation();
          return false;
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: (details) {
          // if swiping up
          if (details.delta.dy > 0) {
            if (homeScreen.value && sceneTransitionAnimation == 0.0) {
              sceneTransitionAnimationController.forward();
            }
            if (!homeScreen.value && slidingAnimation == 0.0) {
              targetPlanet.value = (currentPlanet.value + 1) % planets.length;
              movingForward.value = true;
              slidingAnimationController.forward();
            }
          }
        },
        onHorizontalDragUpdate: (details) {
          if (targetPlanet.value == currentPlanet.value && homeScreen.value) {
            if (details.delta.dx > 0) {
              targetPlanet.value = (currentPlanet.value - 1) % planets.length;
              movingForward.value = false;
            } else {
              targetPlanet.value = (currentPlanet.value + 1) % planets.length;
              movingForward.value = true;
            }
            slidingAnimationController.forward();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                color: homeScreen.value ? Colors.white : Colors.black,
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
                          children: [
                            IconButton(
                              onPressed: () {
                                removeFacades.value = !removeFacades.value;
                              },
                              icon: Icon(
                                Icons.search,
                                color: homeScreen.value
                                    ? Colors.black
                                    : Colors.white,
                                size: 30.0,
                              ),
                            ),
                            Text(
                              'XORE',
                              style: TextStyle(
                                fontSize: 30.0,
                                color: homeScreen.value
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.fullscreen_sharp,
                              color: homeScreen.value
                                  ? Colors.black
                                  : Colors.white,
                              size: 30.0,
                            ),
                          ],
                        ),
                        // vertical text of the planet
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        if (homeScreen.value) ...[
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
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            // black background for the planet
            Positioned(
              top: size.height * 0.4 +
                  size.width * 0.05 -
                  sceneTransitionAnimation * size.width * 0.8,
              child: GestureDetector(
                onTap: () async {
                  await sceneTransitionAnimationController.forward();
                },
                child: Container(
                  width: size.width * 0.4 +
                      sceneTransitionAnimation * size.width * 1.6,
                  height: size.width * 0.4 +
                      sceneTransitionAnimation * size.width * 1.6,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            if (planets.isNotEmpty) ...[
              for (var i = planets.length - 1; i >= 0; i--) ...[
                Positioned(
                  top: getPositionOfPlanet(
                    index: i,
                    currentPlanet: currentPlanet.value,
                    totalPlanets: planets.length,
                    size: size,
                    sceneTransitionAnimation: sceneTransitionAnimation,
                    planetAppearingAnimation: planetAppearingAnimation,
                    planetSlidingAnimation: slidingAnimation,
                    homescreen: homeScreen.value,
                    movingForward: movingForward.value,
                  ).dy,
                  left: getPositionOfPlanet(
                    index: i,
                    currentPlanet: currentPlanet.value,
                    totalPlanets: planets.length,
                    size: size,
                    sceneTransitionAnimation: sceneTransitionAnimation,
                    planetAppearingAnimation: planetAppearingAnimation,
                    planetSlidingAnimation: slidingAnimation,
                    homescreen: homeScreen.value,
                    movingForward: movingForward.value,
                  ).dx,
                  child: Opacity(
                    opacity: getPlanetOpacity(
                      homeScreen: homeScreen.value,
                      movingForward: movingForward.value,
                      removeFacades: removeFacades.value,
                      currentPlanet: currentPlanet.value,
                      planetIndex: i,
                      sceneTransitionAnimation: sceneTransitionAnimation,
                      planetAppearingAnimation: planetAppearingAnimation,
                      planetSlidingAnimation: slidingAnimation,
                    ),
                    child: SizedBox(
                      width: getPlanetSize(
                        index: i,
                        currentPlanet: currentPlanet.value,
                        totalPlanets: planets.length,
                        size: size,
                        sceneTransitionAnimation: sceneTransitionAnimation,
                        planetAppearingAnimation: planetAppearingAnimation,
                        planetSlidingAnimation: slidingAnimation,
                        homescreen: homeScreen.value,
                        movingForward: movingForward.value,
                      ).dx,
                      height: getPlanetSize(
                        index: i,
                        currentPlanet: currentPlanet.value,
                        totalPlanets: planets.length,
                        size: size,
                        sceneTransitionAnimation: sceneTransitionAnimation,
                        planetAppearingAnimation: planetAppearingAnimation,
                        planetSlidingAnimation: slidingAnimation,
                        homescreen: homeScreen.value,
                        movingForward: movingForward.value,
                      ).dy,
                      child: Planet(
                        controller: planetController.value,
                        planet: planets[i],
                        onSceneLoaded: () {},
                        onPlanetLoaded: () async {
                          planetsLoaded.value++;
                          if (planetsLoaded.value == planets.length * 2 &&
                              loading.value) {
                            debugPrint('All planets loaded');
                            loading.value = false;
                            await startupAnimationController.forward(
                              from: 0.0,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ],
            if (homeScreen.value) ...[
              // make the bottom part of the screen white
              if (!removeFacades.value) ...[
                ColorFiltered(
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcOut),
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.4 + size.width * 0.05,
                        ),
                        child: Container(
                          width: size.width,
                          height: size.height * 0.6,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            backgroundBlendMode: BlendMode.dstOut,
                          ),
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.4 +
                            size.width * 0.05 -
                            sceneTransitionAnimation * size.width * 0.8,
                        child: Container(
                          width: size.width * 0.4 +
                              sceneTransitionAnimation * size.width * 1.6,
                          height: size.width * 0.4 +
                              sceneTransitionAnimation * size.width * 1.6,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // add a ring of shadow around the planet
              // add shadow within the transparent circle
              Positioned(
                top: size.height * 0.4 +
                    size.width * 0.05 -
                    sceneTransitionAnimation * size.width * 0.8,
                child: Container(
                  width: size.width * 0.4 +
                      sceneTransitionAnimation * size.width * 1.6,
                  height: size.width * 0.4 +
                      sceneTransitionAnimation * size.width * 1.6,
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
              // white helmet edge around the planet
              Positioned(
                top: size.height * 0.4 -
                    sceneTransitionAnimation * size.width * 0.8,
                child: GestureDetector(
                  onTap: () async {
                    await sceneTransitionAnimationController.forward();
                  },
                  child: Container(
                    width: size.width * 0.5 +
                        sceneTransitionAnimation * size.width * 1.6,
                    height: size.width * 0.5 +
                        sceneTransitionAnimation * size.width * 1.6,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: Colors.white,
                          width: 10.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (planets.isNotEmpty) ...[
                Column(
                  children: [
                    const Spacer(),
                    PlanetSliderWidget(
                      planetOrbitAnimationController:
                          slidingAnimationController,
                      planets: planets,
                      currentPlanet: currentPlanet.value,
                      targetPlanet: targetPlanet.value,
                      onPlanetChanged: (selectedPlanet) {
                        if (currentPlanet.value == targetPlanet.value) {
                          // check if moving forward or backward
                          if (selectedPlanet == 0 &&
                              currentPlanet.value == planets.length - 1) {
                            movingForward.value = true;
                          } else if (selectedPlanet == planets.length - 1 &&
                              currentPlanet.value == 0) {
                            movingForward.value = false;
                          } else {
                            movingForward.value =
                                selectedPlanet > currentPlanet.value;
                          }
                          targetPlanet.value = selectedPlanet;
                          slidingAnimationController.forward(from: 0.0);
                        }
                      },
                      opacity: planetAppearingAnimation,
                      height: size.height * 0.3,
                      width: size.width,
                    ),
                  ],
                ),
              ],
            ],
            if (loading.value) ...[
              Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
