import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WFlexibleWidget extends StatelessWidget {
  const WFlexibleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max bg-gray-100',
      children: [
        WCard(
          className: 'w-120 h-60 bg-white rounded-lg shadow-md',
          child: WFlexContainer(
              className: 'flex-row gap-4 items-center justify-center axis-max',
              children: [
                WFlexible(
                  child: WText('Auto', className: 'text-gray-500 text-center'),
                ),
                WFlexible(
                  className: 'flex-1 flex-grow',
                  child: WText('Flex-1 Grow',
                      className: 'text-blue-500 text-center'),
                ),
                WFlexible(
                  child: WText('Auto', className: 'text-gray-500 text-center'),
                ),
              ]),
        )
      ],
    );
  }
}
