import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class FlexDirection extends StatelessWidget {
  const FlexDirection({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'flex-row w-full h-40 bg-gray-100',
      children: [
        WCard(className: 'bg-blue-500 w-1/3 h-full', child: WText('Card 1')),
        WCard(className: 'bg-green-500 w-1/3 h-full', child: WText('Card 2')),
        WCard(className: 'bg-red-500 w-1/3 h-full', child: WText('Card 3')),
      ],
    );
  }
}
