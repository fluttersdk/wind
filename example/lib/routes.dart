import 'package:flutter/material.dart';

import 'pages/examples/basic.dart';
import 'pages/home.dart';

final Map<String, Widget> appRoutes = {
  '/': HomePage(),
  '/examples/basic': BasicExamplePage(),
};
