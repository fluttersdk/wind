import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ScrollableOverflow extends StatelessWidget {
  const ScrollableOverflow({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'overflow-scroll flex-col bg-gray-100 h-64',
      children: List.generate(
        20,
            (index) => WCard(
          className: 'bg-gray-200 w-full h-10',
          child: WText('Item $index', className: 'text-black'),
        ),
      ),
    );
  }
}
