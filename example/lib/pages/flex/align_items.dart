import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class AlignItems extends StatelessWidget {
  const AlignItems({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'flex-row items-center bg-gray-100 h-64',
      children: [
        WCard(className: 'bg-blue-500 h-16', child: WText('Card 1')),
        WCard(className: 'bg-green-500 h-16', child: WText('Card 2')),
        WCard(className: 'bg-red-500 h-16', child: WText('Card 3')),
      ],
    );
  }
}
