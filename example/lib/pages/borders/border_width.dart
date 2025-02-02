import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class BorderWidth extends StatelessWidget {
  const BorderWidth({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max',
      children: [
        WContainer(
          className: 'border-4 border-blue-500 p-4',
          child: WText('Thick Border', className: 'text-blue-500'),
        )
      ],
    );
  }
}
