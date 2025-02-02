import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class FontSizeWidget extends StatelessWidget {
  const FontSizeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max bg-gray-100',
      children: [
        WCard(
          className: 'p-4 w-120 h-72 bg-white rounded-lg shadow-md',
          child: WFlexContainer(
              className: 'flex-col gap-4 items-center justify-center axis-max',
              children: [
                WText('Extra Small Text', className: 'text-xs'), // 12px
                WText('Base Text', className: 'text-base'), // 16px
                WText('Large Text', className: 'text-lg'), // 18px
                WText('Gigantic Text', className: 'text-6xl'), // 64px
              ]),
        )
      ],
    );
  }
}

class FontSizeArbitraryWidget extends StatelessWidget {
  const FontSizeArbitraryWidget({super.key});

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
                WText('Custom Size Text', className: 'text-[22]'), // 22px
                WText('Small Custom Size', className: 'text-[8]'), // 8px
              ]),
        )
      ],
    );
  }
}
