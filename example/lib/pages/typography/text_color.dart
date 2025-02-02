import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TextColorPredefined extends StatelessWidget {
  const TextColorPredefined({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max bg-gray-100',
      children: [
        WCard(
          className: 'p-4 w-120 h-60 bg-white rounded-lg shadow-md',
          child: WText(
            'This is a red text.',
            className: 'text-red-500',
          ),
        )
      ],
    );
  }
}

class TextColorArbitrary extends StatelessWidget {
  const TextColorArbitrary({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max bg-gray-100',
      children: [
        WCard(
          className: 'p-4 w-120 h-60 bg-white rounded-lg shadow-md',
          child: WText(
            'This is a custom color text.',
            className: 'text-[#FF00FF]',
          ),
        )
      ],
    );
  }
}

