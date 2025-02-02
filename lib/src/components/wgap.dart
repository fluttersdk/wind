import 'package:flutter/material.dart';

class WGap extends LeafRenderObjectWidget {
  final double gap;
  final Axis axis;

  const WGap({super.key, required this.gap, this.axis = Axis.vertical});

  double get width => axis == Axis.horizontal ? gap : 0.0;
  double get height => axis == Axis.vertical ? gap : 0.0;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderGap(width: width, height: height);

  @override
  void updateRenderObject(BuildContext context, RenderGap renderObject) =>
      renderObject
        ..height = height
        ..width = width;
}

class RenderGap extends RenderBox {
  double? width;
  double? height;
  RenderGap({this.width = 0.0, this.height = 0.0});

  @override
  void performLayout() => size = Size(width ?? 0.0, height ?? 0.0);

  @override
  void paint(PaintingContext context, Offset offset) {}
}
