import 'package:flutter/material.dart';

import 'pages/borders/colors_arbitrary.dart';
import 'pages/borders/colors_theme.dart';
import 'pages/borders/radius_basic.dart';
import 'pages/borders/width_basic.dart';
import 'pages/borders/width_sides.dart';
import 'pages/examples/basic.dart';
import 'pages/home.dart';

final Map<String, Widget> appRoutes = {
  '/': HomePage(),
  '/examples/basic': BasicExamplePage(),
  '/borders/radius_basic': RadiusBasicPage(),
  '/borders/width_basic': WidthBasicPage(),
  '/borders/width_sides': WidthSidesPage(),
  '/borders/colors_theme': ColorsThemePage(),
  '/borders/colors_arbitrary': ColorsArbitraryPage(),
};
