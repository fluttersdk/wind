import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class UtilityFirstWind extends StatelessWidget {
  const UtilityFirstWind({super.key});

  @override
  Widget build(BuildContext context) {
    return WCard(
      className: 'shadow-lg rounded-lg m-4 p-4 bg-black',
      child: WFlex(
        className: 'flex-col axis-min gap-2 items-start',
        children: [
          WText('12', className: 'text-4xl leading-6 font-bold text-white'),
          WText('Active users on the website',
              className: 'text-white leading-4'),
          WText(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            className: 'text-gray-300 text-xs',
          )
        ],
      ),
    );
  }
}
