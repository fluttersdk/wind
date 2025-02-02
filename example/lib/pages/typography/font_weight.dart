import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class FontWeightWidget extends StatelessWidget {
  const FontWeightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max bg-gray-100',
      children: [
        WCard(
          className: 'p-4 w-120 h-60 bg-white rounded-lg shadow-md',
          child: WFlexContainer(
              className: 'flex-col gap-4 items-center justify-center axis-max',
              children: [
                WText('Bold Text', className: 'font-bold'),
                WText('Thin Text', className: 'font-thin'),
                WText('Black Text', className: 'font-black'),
              ]),
        )
      ],
    );
  }
}
