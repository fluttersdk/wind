import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class TextDecorationWidget extends StatelessWidget {
  const TextDecorationWidget({super.key});

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
                  'No underline here.',
                  className: 'no-underline',
                ),
                WText(
                  'This text is underlined.',
                  className: 'underline',
                ),
                WText(
                  'This text has an overline.',
                  className: 'overline',
                ),
                WText(
                  'This text is strikethrough.',
                  className: 'line-through',
                )
              ]),
        )
      ],
    );
  }
}
