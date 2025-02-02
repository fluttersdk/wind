import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class BorderRadiusWidget extends StatelessWidget {
  const BorderRadiusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'flex-col gap-4 items-center justify-center axis-max',
      children: [
        WContainer(
          className: 'border-2 border-red-500 rounded-lg p-4',
          child: WText('Rounded Border', className: 'text-blue-500'),
        ),
        WContainer(
          className: 'border-2 border-red-500 rounded-full p-4',
          child: WText('Full Rounded Border', className: 'text-blue-500'),
        )
      ],
    );
  }
}

class BorderRadiusCustom extends StatelessWidget {
  const BorderRadiusCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max',
      children: [
        WContainer(
          className: 'border-2 border-red-500 rounded-[6] p-4',
          child: WText('Custom Rounded Border', className: 'text-blue-500'),
        ),
      ],
    );
  }
}
