import 'package:flutter/material.dart';

/// Default Tailwind CSS box shadows
///
/// Based on Tailwind CSS v3.0 default theme
class WindBoxShadows {
  static const Map<String, List<BoxShadow>> shadows = {
    'sm': [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.05),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
    ],
    'DEFAULT': [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.1),
        blurRadius: 3,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.06),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
    ],
    'md': [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.1),
        blurRadius: 6,
        offset: Offset(0, 4),
        // spreadRadius: -1 in tailwind corresponds to negative spread
        spreadRadius: -1,
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.06),
        blurRadius: 4,
        offset: Offset(0, 2),
        spreadRadius: -1,
      ),
    ],
    'lg': [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.1),
        blurRadius: 15,
        offset: Offset(0, 10),
        spreadRadius: -3,
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.05),
        blurRadius: 6,
        offset: Offset(0, 4),
        spreadRadius: -2,
      ),
    ],
    'xl': [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.1),
        blurRadius: 25,
        offset: Offset(0, 20),
        spreadRadius: -5,
      ),
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.04),
        blurRadius: 10,
        offset: Offset(0, 10),
        spreadRadius: -5,
      ),
    ],
    '2xl': [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        blurRadius: 50,
        offset: Offset(0, 25),
        spreadRadius: -12,
      ),
    ],
    'none': [],
  };
}
