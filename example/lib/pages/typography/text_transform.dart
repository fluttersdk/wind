import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TextTransformWidget extends StatelessWidget {
  const TextTransformWidget({super.key});

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
                  'Upper Case',
                  className: 'uppercase',
                ),
                WText(
                  'Lower Case',
                  className: 'lowercase',
                ),
                WText(
                  'capitalize this text',
                  className: 'capitalize',
                ),
                WText(
                  'No transformation here.',
                  className: 'none',
                )
              ]),
        )
      ],
    );
  }
}
