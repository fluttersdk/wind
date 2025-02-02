import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class FlexFitWidget extends StatelessWidget {
  const FlexFitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'flex-row bg-gray-100',
      children: [
        WCard(
          className: 'flex-grow bg-blue-500',
          child: WText('Grow'),
        ),
        WCard(
          className: 'flex-auto bg-green-500',
          child: WText('Auto'),
        ),
      ],
    );
  }
}
