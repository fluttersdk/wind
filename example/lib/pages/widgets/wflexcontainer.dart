import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WFlexContainerWidget extends StatelessWidget {
  const WFlexContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'flex-col items-center justify-center gap-4 bg-gray-200',
      children: [
        WContainer(
          className: 'w-16 h-16 bg-blue-500',
          child: WText('Child 1', className: 'text-white'),
        ),
        WContainer(
          className: 'w-16 h-16 bg-green-500',
          child: WText('Child 2', className: 'text-white'),
        ),
      ],
    );
  }
}
