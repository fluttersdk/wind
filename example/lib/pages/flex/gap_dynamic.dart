import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class GapDynamic extends StatelessWidget {
  const GapDynamic({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'gap-[8] flex-row bg-gray-200',
      children: [
        WCard(className: 'bg-blue-500 w-16 h-16', child: WText('Card 1')),
        WCard(className: 'bg-green-500 w-16 h-16', child: WText('Card 2')),
        WCard(className: 'bg-red-500 w-16 h-16', child: WText('Card 3')),
      ],
    );
  }
}
