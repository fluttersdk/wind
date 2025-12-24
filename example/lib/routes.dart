import 'package:flutter/material.dart';

import 'pages/borders/basic.dart';
import 'pages/borders/colors.dart';
import 'pages/borders/width.dart';
import 'pages/examples/basic.dart';
import 'pages/home.dart';

final Map<String, Widget> appRoutes = {
  '/': HomePage(),
  '/examples/basic': BasicExamplePage(),
  '/borders/basic': BorderBasicPage(),
  '/borders/width': BorderWidthPage(),
  '/borders/colors': BorderColorsPage(),
};
