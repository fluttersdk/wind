import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class HeightWidget extends StatelessWidget {
  const HeightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center flex-row gap-4 justify-center axis-max bg-white',
      children: [
        WContainer(
          className: 'h-12 bg-blue-500',
          child: WText('Height is 48px'), // 12 * 4 (Pixel Factor)
        ),
        WContainer(
          className: 'h-[150] bg-red-500',
          child: WText('Height is 150px'), // Arbitrary value
        ),
        WContainer(
          className: 'h-full bg-green-500',
          child: WText('Full height of parent'),
        ),
      ],
    );
  }
}

class MaxHeightWidget extends StatelessWidget {
  const MaxHeightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
        className:
            'items-center flex-row gap-4 justify-center axis-max bg-white',
        children: [
          WContainer(
            className: 'max-h-16 bg-blue-500',
            child: WText('Max height: 64px'), // 16 * 4 (Pixel Factor)
          ),
          WContainer(
            className: 'max-h-[8] bg-gray-500',
            child: WText('Max height: 8px'), // Arbitrary value
          ),
          WContainer(
            className: 'max-h-screen bg-teal-500',
            child: WText('Max height: Full screen height'),
          )
        ]);
  }
}

class MinHeightWidget extends StatelessWidget {
  const MinHeightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
        className:
            'items-center flex-row gap-4 justify-center axis-max bg-white',
        children: [
          WContainer(
            className: 'min-h-10 bg-yellow-500',
            child: WText('Min height: 40px'), // 10 * 4 (Pixel Factor)
          ),
          WContainer(
            className: 'min-h-[100] bg-orange-500',
            child: WText('Min height: 100px'), // Arbitrary value
          ),
          WContainer(
            className: 'min-h-screen bg-pink-500',
            child: WText('Min height: Full screen height'),
          )
        ]);
  }
}
