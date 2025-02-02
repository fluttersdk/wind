import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class AlignmentWidget extends StatelessWidget {
  const AlignmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WContainer(
      className: 'alignment-center bg-gray-200 w-full h-full',
      child: WText('Centered Text', className: 'text-black'),
    );
  }
}

class AlignmentTopLeftWidget extends StatelessWidget {
  const AlignmentTopLeftWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WContainer(
      className: 'alignment-top-left bg-gray-200 w-full h-64',
      child: WText('Top-Left Text', className: 'text-black'),
    );
  }
}

class AlignmentComplex extends StatelessWidget {
  const AlignmentComplex({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'flex-row justify-evenly items-center w-full h-64 bg-gray-100',
      children: [
        WContainer(
          className: 'alignment-top-left bg-blue-500 w-32 h-32',
          child: WText('Top-Left', className: 'text-white'),
        ),
        WContainer(
          className: 'alignment-center bg-green-500 w-32 h-32',
          child: WText('Center', className: 'text-white'),
        ),
        WContainer(
          className: 'alignment-bottom-right bg-red-500 w-32 h-32',
          child: WText('Bottom-Right', className: 'text-white'),
        ),
      ],
    );
  }
}