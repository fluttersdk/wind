import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class WTextWidget extends StatelessWidget {
  const WTextWidget({super.key});

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
                WText('Utility Styled Text',
                    className: 'text-red-500 font-bold text-lg'),
              ]),
        )
      ],
    );
  }
}

class WTextParameterWidget extends StatelessWidget {
  const WTextParameterWidget({super.key});

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
                  'Explicit Parameters',
                  className: 'text-red-500 font-bold text-lg',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight
                          .w300), // Overrides `text-red-500` and `font-bold`
                ),
              ]),
        )
      ],
    );
  }
}
