import 'package:flutter/material.dart';

class WGap extends StatelessWidget {
  final double gap;
  final Axis axis;

  const WGap({super.key, required this.gap, this.axis = Axis.vertical});

  double get width => axis == Axis.horizontal ? gap : 0.0;
  double get height => axis == Axis.vertical ? gap : 0.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height);
  }
}

