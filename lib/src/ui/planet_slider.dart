import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:planet_inspector/src/models/planet.dart';

class PlanetSliderWidget extends HookWidget {
  const PlanetSliderWidget({
    required this.planets,
    required this.onPlanetChanged,
    required this.height,
    required this.width,
    required this.opacity,
    required this.planetOrbitAnimationController,
    this.currentPlanet = 0,
    this.targetPlanet = 0,
    super.key,
  });

  // int callback method
  final Function(int) onPlanetChanged;
  final int currentPlanet;
  final int targetPlanet;
  final List<Planet> planets;
  final double opacity;
  // animation for the planets orbiting
  final AnimationController planetOrbitAnimationController;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    var planetSliderAnimation = useAnimation(
      CurvedAnimation(
        parent: planetOrbitAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    var planetTextFadeAnimation = useAnimation(
      CurvedAnimation(
        parent: planetOrbitAnimationController,
        curve: Curves.easeInExpo,
      ),
    );
    return Opacity(
      opacity: opacity,
      child: Stack(
        children: [
          // draw a grey outlined circle below the screen
          Positioned(
            bottom: -width / 1.75,
            left: width / 4 - width / 8,
            child: Container(
              width: width / 4 * 3,
              height: width / 4 * 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
          ),
          // the current planet is in the middle
          // use an animated builder to animate the planets orbiting
          for (var i = -1; i < 2; i++) ...[
            AnimatedBuilder(
              animation: planetOrbitAnimationController,
              builder: (context, child) {
                return Positioned(
                  top: height * 0.1 - 10,
                  left: width / 2 - 10,
                  child: Transform.rotate(
                    angle: 3.14 *
                        2 /
                        planets.length *
                        (i +
                            planetSliderAnimation *
                                (planetsMovingFoward() ? -1 : 1)),
                    child: SizedBox(
                      width: 20,
                      height: width / 4 * 3,
                      child: Column(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              color:
                                  planets[(currentPlanet + i) % planets.length]
                                      .color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      color: Colors.grey,
                      onPressed: () {
                        onPlanetChanged((currentPlanet - 1) % planets.length);
                      },
                      icon: const Icon(Icons.chevron_left),
                    ),
                    // small orb icon with the color
                    const Spacer(),
                    IconButton(
                      iconSize: 30,
                      color: Colors.grey,
                      onPressed: () {
                        onPlanetChanged((currentPlanet + 1) % planets.length);
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                Opacity(
                  opacity: (currentPlanet != targetPlanet)
                      ? planetTextFadeAnimation
                      : 1.0,
                  child: Text(
                    planets[targetPlanet].name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18.0,
                      decoration: TextDecoration.underline,
                      letterSpacing: 5,
                      color: Colors.transparent,
                      decorationColor: Colors.grey,
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(0, -8))
                      ],
                      decorationThickness: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool planetsMovingFoward() {
    return (!(targetPlanet == planets.length - 1 && currentPlanet == 0) &&
            currentPlanet < targetPlanet) ||
        (targetPlanet == 0 && currentPlanet == planets.length - 1);
  }
}
