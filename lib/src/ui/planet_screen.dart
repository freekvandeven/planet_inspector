import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:planet_inspector/src/services/planet.dart';
import 'package:planet_inspector/src/ui/widgets/planet.dart';

class RotatingPlanetScreen extends HookConsumerWidget {
  const RotatingPlanetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    var planetInformation = ref.watch(planetsProvider);
    var planets = ref.watch(planetsProvider).planets;
    var firstPlanet = ref
        .watch(planetsProvider)
        .planets[planetInformation.selectedPlanetIndex ?? 0];
    var secondPlanet = ref.watch(planetsProvider).planets[
        ((planetInformation.selectedPlanetIndex ?? 0) + 1) % planets.length];
    var animationController = useAnimationController(
      duration: const Duration(milliseconds: 1000),
      initialValue: 0.0,
      upperBound: 1.0,
    );
    var forwardAnimation = useAnimation(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );
    // listen to the animation controller
    var listenable = useListenable(animationController);
    useEffect(
      () {
        listenable.addStatusListener(
          (status) {
            if (animationController.isCompleted) {
              ref.read(planetsProvider.notifier).selectNextPlanet();
              animationController.reset();
            }
          },
        );
        return null;
      },
      const [],
    );

    return GestureDetector(
      // on swipe down go back to the home screen
      // on swipe up go to next planet
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < 0) {
          // swipe down
          if (animationController.isAnimating) return;
          debugPrint('swipe down');
          Navigator.of(context).pop();
        } else if (details.delta.dy > 0) {
          // swipe up
          if (animationController.isAnimating) return;
          debugPrint('swipe up');
          animationController.forward(from: 0.0);
        }
      },
      child: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Stack(
          children: [
            // show the next planet in the background
            Positioned(
              top: (size.height / 3) * forwardAnimation,
              child: GestureDetector(
                onTap: () async {
                  // move to the next planet
                  debugPrint('switching to next planet');
                  if (animationController.isAnimating) return;
                  await animationController.forward(from: 0.0);
                },
                child: Planet(
                  key: ValueKey(secondPlanet.name),
                  scale: 4.0 + 5 * forwardAnimation,
                  interative: false,
                  planet: secondPlanet,
                ),
              ),
            ),
            Positioned(
              top: size.height / 3 + forwardAnimation * size.height,
              child: GestureDetector(
                onTap: () {
                  // show information about the planet
                },
                child: Planet(
                  key: ValueKey(firstPlanet.name),
                  interative: false,
                  planet: firstPlanet,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
