import 'package:flutter/material.dart';

abstract class PrintableWidget {
  void printWidget(BuildContext context);
  String? toRealStringShallow(BuildContext context);
}
