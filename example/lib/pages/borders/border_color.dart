import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class BorderColor extends StatelessWidget {
  const BorderColor({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max',
      children: [
        WContainer(
          className: 'border-2 border-red-500 p-4',
          child: WText('Red Border', className: 'text-blue-500'),
        )
      ],
    );
  }
}

class BorderColorCustom extends StatelessWidget {
  const BorderColorCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max',
      children: [
        WContainer(
          className: 'border-2 border-[#1abc9c] p-4',
          child: WText('Custom Color Border', className: 'text-blue-500'),
        )
      ],
    );
  }
}