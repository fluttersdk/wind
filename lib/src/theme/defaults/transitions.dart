import 'package:flutter/widgets.dart';

/// Default transition durations (Tailwind values in milliseconds)
const Map<String, Duration> transitionDurations = {
  '75': Duration(milliseconds: 75),
  '100': Duration(milliseconds: 100),
  '150': Duration(milliseconds: 150),
  '200': Duration(milliseconds: 200),
  '300': Duration(milliseconds: 300),
  '500': Duration(milliseconds: 500),
  '700': Duration(milliseconds: 700),
  '1000': Duration(milliseconds: 1000),
};

/// Default transition curves
const Map<String, Curve> transitionCurves = {
  'linear': Curves.linear,
  'in': Curves.easeIn,
  'out': Curves.easeOut,
  'in-out': Curves.easeInOut,
};
