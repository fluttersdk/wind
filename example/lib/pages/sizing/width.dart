import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class WidthWidget extends StatelessWidget {
  const WidthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center flex-col gap-4 justify-center axis-max bg-white',
      children: [
        WContainer(
          className: 'w-12 bg-blue-500',
          child: WText('Width is 48px'), // 12 * 4 (Pixel Factor)
        ),
        WContainer(
          className: 'w-[150] bg-red-500',
          child: WText('Width is 150px'), // Arbitrary value
        ),
        WContainer(
          className: 'w-full bg-green-500',
          child: WText('Full width of parent'),
        ),
      ],
    );
  }
}

class MaxWidthWidget extends StatelessWidget {
  const MaxWidthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
        className:
            'items-center flex-col gap-4 justify-center axis-max bg-white',
        children: [
          WContainer(
            className: 'max-w-10 bg-purple-500',
            child: WText('Max width: 40px'), // 10 * 4 (Pixel Factor)
          ),
          WContainer(
            className: 'max-w-[300] bg-gray-500',
            child: WText('Max width: 300px'), // Arbitrary value
          ),
          WContainer(
            className: 'max-w-screen bg-teal-500',
            child: WText('Max width: Full screen width'),
          ),
        ]);
  }
}

class MinWidthWidget extends StatelessWidget {
  const MinWidthWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
        className:
            'items-center flex-col gap-4 justify-center axis-max bg-white',
        children: [
          WContainer(
            className: 'min-w-12 bg-yellow-500',
            child: WText('Min width: 48px'), // 12 * 4 (Pixel Factor)
          ),
          WContainer(
            className: 'min-w-[100] bg-orange-500',
            child: WText('Min width: 100px'), // Arbitrary value
          ),
          WContainer(
            className: 'min-w-full bg-pink-500',
            child: WText('Min width: Full parent width'),
          ),
        ]);
  }
}
