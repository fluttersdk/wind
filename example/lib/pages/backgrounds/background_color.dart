import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class BackgroundColor extends StatelessWidget {
  const BackgroundColor({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max',
      children: [
        WContainer(
          className: 'bg-blue-500 w-64 h-64 alignment-center',
          child: WText('Blue Background', className: 'text-white'),
        )
      ],
    );
  }
}

class BackgroundColorCustom extends StatelessWidget {
  const BackgroundColorCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max',
      children: [
        WContainer(
          className: 'bg-[#1abc9c] w-64 h-64 alignment-center',
          child: WText('Custom Color Background', className: 'text-white'),
        )
      ],
    );
  }
}