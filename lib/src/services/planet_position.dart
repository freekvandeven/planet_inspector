import 'dart:math';

import 'package:flutter/material.dart';

Offset getPositionOfPlanet({
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
  var order = index - currentPlanet.toDouble();
  // add the planet sliding animation
  if (movingForward) {
    order -= planetSlidingAnimation;
  } else {
    order += planetSlidingAnimation;
  }

  var topPoint = size.height * 0.4 + size.width * 0.23;
  var height = size.height * 0.4;
  // find a point on the circle based on the order
  var angle = order * 2 * pi / totalPlanets - pi / 2;
  var leftOffset = size.width * 0.35 + height * 0.5 * cos(angle);
  var topOffset = topPoint + height * 0.5 + height * 0.5 * sin(angle);
  if (homescreen && sceneTransitionAnimation == 0) {
    return Offset(leftOffset, topOffset);
  }
  if (homescreen) {
    if (index == currentPlanet) {
      return Offset(
        leftOffset - sceneTransitionAnimation * size.width * 0.45,
        topOffset + sceneTransitionAnimation * size.width * 0.15,
      );
    }
    if (index == currentPlanet + 1) {
      return Offset(
        size.width * 0.35 - sceneTransitionAnimation * size.width * 0.3,
        size.height * 0.2 + sceneTransitionAnimation * size.width * 0.05,
      );
    }
  }
  if (planetSlidingAnimation == 0) {
    if (index == currentPlanet) {
      return Offset(
        leftOffset - size.width * 0.45,
        topOffset + size.width * 0.15,
      );
    }
    if (index == currentPlanet + 1) {
      return Offset(
        size.width * 0.35 - size.width * 0.3,
        size.height * 0.2 + size.width * 0.05,
      );
    }
  }
  if (index == currentPlanet) {
    return Offset(
      size.width * 0.35 -
          size.width * 0.45 -
          planetSlidingAnimation * size.width * 0.15,
      topOffset + size.width * 0.15 + planetSlidingAnimation * size.width,
    );
  }
  if (index == currentPlanet + 1) {
    // move from the startPosition to the position of the currentplanet
    return Offset(
      size.width * 0.35 -
          size.width * 0.3 -
          planetSlidingAnimation * size.width * 0.15,
      size.height * 0.2 +
          size.width * 0.05 +
          planetSlidingAnimation *
              (((size.height * 0.2 + size.width * 0.05) -
                      (topOffset + size.width * 0.15))
                  .abs()),
    );
  }
  if (index == currentPlanet + 2) {
    return Offset(
      size.width * 0.35 - size.width * 0.3,
      size.height * 0.2 +
          size.width * 0.05 +
          planetSlidingAnimation * size.width * 0.1 -
          size.width * 0.1,
    );
  }

  return Offset(leftOffset, topOffset);
}
