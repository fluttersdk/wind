import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class JustifyContent extends StatelessWidget {
  const JustifyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'flex-row justify-between bg-gray-200',
      children: [
        WCard(className: 'bg-blue-500 w-16 h-16', child: WText('Card 1')),
        WCard(className: 'bg-green-500 w-16 h-16', child: WText('Card 2')),
        WCard(className: 'bg-red-500 w-16 h-16', child: WText('Card 3')),
      ],
    );
  }
}
