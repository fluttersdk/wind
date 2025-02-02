import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class FlexX extends StatelessWidget {
  const FlexX({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'flex-row bg-gray-200',
      children: [
        WCard(
          className: 'flex-2 bg-blue-500',
          child: WText('Flex 2'),
        ),
        WCard(
          className: 'flex-1 bg-green-500',
          child: WText('Flex 1'),
        ),
      ],
    );
  }
}
