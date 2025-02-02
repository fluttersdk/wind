import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class FontStyleWidget extends StatelessWidget {
  const FontStyleWidget({super.key});

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
                WText('Italic Text', className: 'italic'),
                // Italicized text
                WText('Normal Text', className: 'not-italic'),
                // Normal text style
              ]),
        )
      ],
    );
  }
}
