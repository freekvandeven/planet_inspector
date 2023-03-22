// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:planet_inspector/src/theme.dart';
import 'package:planet_inspector/src/ui/home.dart';
import 'package:planet_inspector/src/ui/planet_screen.dart';

class PlanetInspectorApp extends StatelessWidget {
  const PlanetInspectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getTheme(),
      title: 'Planet Inspector',
      initialRoute: '/home',
      home: const SafeArea(child: Material(child: PlanetOverviewScreen())),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(
              builder: (context) => const SafeArea(
                child: Material(
                  child: PlanetOverviewScreen(),
                ),
              ),
            );
          case '/planet':
            return MaterialPageRoute(
              builder: (context) => const SafeArea(
                child: Material(
                  child: RotatingPlanetScreen(),
                ),
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const SafeArea(
                child: Material(
                  child: PlanetOverviewScreen(),
                ),
              ),
            );
        }
      },
    );
  }
}
