import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class ResponsiveDesign extends StatelessWidget {
  const ResponsiveDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'w-full h-full justify-center items-center flex-col bg-gray-200',
      children: [
        WCard(
          className: 'sm:w-full p-4 bg-white rounded-lg items-center justify-center',
          child: WText('Full width at small screens.',
              className: 'text-black'),
        ),
        WCard(
          className: 'md:w-full p-4 bg-white rounded-lg items-center justify-center',
          child: WText('Full width at medium screens.',
              className: 'text-black'),
        ),
        WCard(
          className: 'lg:w-full p-4 bg-white rounded-lg items-center justify-center',
          child: WText('Full width at large screens.',
              className: 'text-black'),
        ),
        WCard(
          className: 'xl:w-full p-4 bg-white rounded-lg items-center justify-center',
          child: WText('Full width at extra large screens.',
              className: 'text-black'),
        ),
      ],
    );
  }
}
