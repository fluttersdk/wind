import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class LetterSpacingWidget extends StatelessWidget {
  const LetterSpacingWidget({super.key});

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
                WText(
                  'Wide Letter Spacing',
                  className: 'tracking-wide text-lg text-gray-700',
                ),
                WText(
                  'Custom Letter Spacing',
                  className: 'tracking-[0.13] text-base text-blue-500',
                ),
              ]),
        )
      ],
    );
  }
}
