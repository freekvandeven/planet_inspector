import 'package:flutter/material.dart';

import 'package:planet_inspector/src/models/planet.dart';

class PlanetSliderWidget extends StatefulWidget {
  const PlanetSliderWidget({
    required this.planets,
    required this.onPlanetChanged,
    required this.height,
    this.initialPlanet = 0,
    super.key,
  });

  // int callback method
  final Function(int) onPlanetChanged;
  final int initialPlanet;
  final List<Planet> planets;

  final double height;

  @override
  State<PlanetSliderWidget> createState() => _PlanetSliderWidgetState();
}

class _PlanetSliderWidgetState extends State<PlanetSliderWidget> {
  late int _currentPlanet;

  @override
  void initState() {
    super.initState();
    _currentPlanet = widget.initialPlanet;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // planet selector

        Row(
          children: [
            // chevron left selector
            IconButton(
              onPressed: () {
                setState(() {
                  _currentPlanet = _currentPlanet - 1;
                  if (_currentPlanet < 0) {
                    _currentPlanet = widget.planets.length - 1;
                  }
                  widget.onPlanetChanged(_currentPlanet);
                });
              },
              icon: const Icon(Icons.chevron_left),
            ),
            // small orb icon with the color
            Container(
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: widget.planets[_currentPlanet].color,
                shape: BoxShape.circle,
              ),
            ),

            // chevron right selector
            IconButton(
              onPressed: () {
                setState(() {
                  _currentPlanet = _currentPlanet + 1;
                  if (_currentPlanet >= widget.planets.length) {
                    _currentPlanet = 0;
                  }
                  widget.onPlanetChanged(_currentPlanet);
                });
              },
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        Row(
          children: [
            // planet orb current - 1
            Container(
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: widget
                    .planets[_currentPlanet == 0
                        ? widget.planets.length - 1
                        : _currentPlanet - 1]
                    .color,
                shape: BoxShape.circle,
              ),
            ),
            // name of the current planet
            Text(widget.planets[_currentPlanet].name),
            // planet orb current + 1
            Container(
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: widget
                    .planets[_currentPlanet == widget.planets.length - 1
                        ? 0
                        : _currentPlanet + 1]
                    .color,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
