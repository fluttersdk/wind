import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ShadowWidget extends StatelessWidget {
  const ShadowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max bg-white',
      children: [
        WCard(
          className: 'shadow-lg p-4 bg-white',
          child: WText('Large Shadow', className: 'text-gray-700'),
        ),
      ],
    );
  }
}

class ShadowCustomWidget extends StatelessWidget {
  const ShadowCustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max bg-white',
      children: [
        WCard(
          className: 'shadow-[6] p-4 bg-white',
          child: WText('Custom Shadow', className: 'text-gray-700'),
        ),
      ],
    );
  }
}
