double getPlanetOpacity({
  required bool homeScreen,
  required bool removeFacades,
  required bool movingForward,
  required int currentPlanet,
  required int planetIndex,
  required double planetAppearingAnimation,
  required double sceneTransitionAnimation,
  required double planetSlidingAnimation,
}) {
  if (removeFacades) {
    return 1.0;
  }
  if (homeScreen && sceneTransitionAnimation == 0) {
    return planetAppearingAnimation;
  }
  if (homeScreen && planetIndex == currentPlanet + 1) {
    return sceneTransitionAnimation;
  }
  if (planetIndex == currentPlanet || planetIndex == currentPlanet + 1) {
    return 1.0;
  }
  if (planetIndex == currentPlanet + 2) {
    return planetSlidingAnimation;
  }
  return 0.0;
}
