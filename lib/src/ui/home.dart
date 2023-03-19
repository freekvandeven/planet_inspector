import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:planet_inspector/src/services/planet.dart';
import 'package:planet_inspector/src/ui/planet_slider.dart';

class PlanetOverviewScreen extends HookConsumerWidget {
  const PlanetOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var planets = ref.watch(planetsProvider);
    var currentPlanet = useState(0);
    useEffect(
      () {
        Future.delayed(Duration.zero, () async {
          await ref.read(planetsProvider.notifier).fetchPlanets();
        });
        return null;
      },
      const [],
    );
    if (planets.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    var size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
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
                style: TextStyle(fontSize: 30.0, color: Colors.black),
              ),

              // icon enlarge
              Icon(Icons.fullscreen_sharp, color: Colors.black, size: 30.0),
            ],
          ),
          // vertical text of the planet
          SizedBox(
            height: size.height * 0.05,
          ),
          RotatedBox(
            quarterTurns: 1,
            child: Text(
              planets[currentPlanet.value].name,
              style: const TextStyle(
                fontSize: 100.0,
                color: Colors.grey,
                letterSpacing: 20,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
          const Spacer(),
          PlanetSliderWidget(
            planets: planets,
            onPlanetChanged: (selectedPlanet) {
              debugPrint('selected planet: $selectedPlanet');
              currentPlanet.value = selectedPlanet;
            },
            height: size.height * 0.2,
          ),
        ],
      ),
    );
  }
}
