import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class WFlexWidget extends StatelessWidget {
  const WFlexWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlex(
      className: 'flex-col justify-center items-center gap-4',
      children: [
        WContainer(className: 'w-10 h-10 bg-blue-500'),
        WContainer(className: 'w-10 h-10 bg-green-500'),
      ],
    );
  }
}
