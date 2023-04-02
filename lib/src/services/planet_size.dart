import 'package:flutter/material.dart';

Offset getPlanetSize({
  required int index,
  required int currentPlanet,
  required int totalPlanets,
  required Size size,
  required double sceneTransitionAnimation,
  required double planetAppearingAnimation,
  required double planetSlidingAnimation,
  required bool homescreen,
  required bool movingForward,
}) {
  if (homescreen && sceneTransitionAnimation == 0.0) {
    return Offset(size.width * 0.3, size.width * 0.3);
  }
  if (homescreen) {
    // animate the expansion of the planet
    if (index == currentPlanet) {
      // currentPlanet gets bigger from size.width * 0.3 to size.width * 1.2
      return Offset(
        size.width * 0.3 + sceneTransitionAnimation * size.width * 0.9,
        size.width * 0.3 + sceneTransitionAnimation * size.width * 0.9,
      );
    }
    if (index == currentPlanet + 1) {
      // currentPlanet gets bigger from size.width * 0.3 to size.width * 1.2
      return Offset(
        size.width * 0.3 + sceneTransitionAnimation * size.width * 0.6,
        size.width * 0.3 + sceneTransitionAnimation * size.width * 0.6,
      );
    }
  }
  if (planetSlidingAnimation == 0.0) {
    if (index == currentPlanet) {
      return Offset(size.width * 1.2, size.width * 1.2);
    }
    if (index == currentPlanet + 1) {
      return Offset(size.width * 0.9, size.width * 0.9);
    }
  }
  if (index == currentPlanet) {
    return Offset(
      size.width * 1.2 + planetSlidingAnimation * size.width * 0.3,
      size.width * 1.2 + planetSlidingAnimation * size.width * 0.3,
    );
  }
  // animate the planet getting bigger
  if (index == currentPlanet + 1) {
    return Offset(
      size.width * 0.9 + planetSlidingAnimation * size.width * 0.3,
      size.width * 0.9 + planetSlidingAnimation * size.width * 0.3,
    );
  }
  if (index == currentPlanet + 2) {
    return Offset(size.width * 0.9, size.width * 0.9);
  }
  return Offset(size.width * 0.3, size.width * 0.3);
}
