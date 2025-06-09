import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class DisplayLayout extends StatelessWidget {
  const DisplayLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'flex-col bg-gray-100 h-64 justify-center items-center gap-4',
      children: [
        WFlexible(
          className: 'hide lg:show',
          child: WText('Visible on large and larger screens'),
        ),
        WFlexible(
          className: 'hide md:show',
          child: WText('Visible on medium and larger screens'),
        ),
        WFlexible(
          className: 'show md:hide',
          child: WText('Visible on only small screens'),
        ),
      ],
    );
  }
}
