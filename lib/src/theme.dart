// SPDX-FileCopyrightText: 2023 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF0fa226),
      onPrimary: Color.fromARGB(255, 13, 103, 27),
      secondary: Color(0xFF3456FF),
      onSecondary: Color(0xFF3456FF),
      error: Colors.red,
      onError: Colors.red,
      background: Color(0xFF0c1117),
      onBackground: Color(0xFF0c1117),
      surface: Colors.white,
      onSurface: Colors.white,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontFamily: 'Apercu',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headline3: TextStyle(
        fontFamily: 'Apercu',
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      headline4: TextStyle(
        fontFamily: 'Apercu',
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color.fromARGB(255, 117, 115, 115),
      ),
      headline5: TextStyle(
        fontFamily: 'Apercu',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontFamily: 'Apercu',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        fontFamily: 'Apercu',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color.fromARGB(255, 127, 129, 137),
      ),
    ),
  );
}
