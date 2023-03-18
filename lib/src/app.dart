// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:planet_inspector/src/theme.dart';
import 'package:planet_inspector/src/ui/home.dart';

class PlanetInspectorApp extends StatelessWidget {
  const PlanetInspectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getTheme(),
      title: 'Planet Inspector',
      initialRoute: '',
      home: const Material(child: PlanetOverviewScreen()),
    );
  }
}
