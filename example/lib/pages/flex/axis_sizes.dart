import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class AxisSizes extends StatelessWidget {
  const AxisSizes({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'axis-max flex-row bg-gray-200',
      children: [
        WCard(className: 'bg-blue-500 w-20 h-20', child: WText('Card 1')),
        WCard(className: 'bg-green-500 w-20 h-20', child: WText('Card 2')),
      ],
    );
  }
}
