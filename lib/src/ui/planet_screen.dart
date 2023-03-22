import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:planet_inspector/src/services/planet.dart';
import 'package:planet_inspector/src/ui/widgets/planet.dart';

class RotatingPlanetScreen extends HookConsumerWidget {
  const RotatingPlanetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var planetInformation = ref.watch(planetsProvider);
    var planets = planetInformation.planets;
    var firstPlanet = planets[planetInformation.selectedPlanetIndex ?? 0];
    var isInteracting = useState(false);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              'https://i.pinimg.com/736x/ac/be/49/acbe49c3f106d163937b8c05c4d48b05.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color.fromARGB(255, 49, 88, 116),
                    Color.fromARGB(255, 4, 11, 34),
                  ],
                  radius: 1,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height /
                (!isInteracting.value ? 3 : 5),
            child: GestureDetector(
              onTap: () {
                // isInteracting.value = !isInteracting.value;
              },
              child: Planet(
                interative: false,
                planet: firstPlanet,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
