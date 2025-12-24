import 'package:flutter/material.dart';

import 'pages/borders/radius_basic.dart';
import 'pages/borders/width_basic.dart';
import 'pages/examples/basic.dart';
import 'pages/home.dart';

final Map<String, Widget> appRoutes = {
  '/': HomePage(),
  '/examples/basic': BasicExamplePage(),
  '/borders/radius_basic': RadiusBasicPage(),
  '/borders/width_basic': WidthBasicPage(),
};
