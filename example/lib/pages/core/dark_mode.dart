import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class DarkMode extends StatefulWidget {
  const DarkMode({super.key});

  @override
  State<DarkMode> createState() => _DarkModeState();
}

class _DarkModeState extends State<DarkMode> {
  darkMode() {
    setState(() {
      WindTheme.setType(Brightness.dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className:
          'w-full h-full justify-center flex-col items-center bg-gray-200 gap-4',
      children: [
        WFlex(
          className: 'w-full justify-center items-center gap-4',
          children: [
            WCard(
              className: 'shadow-lg rounded-lg p-4 bg-white',
              child: WFlex(
                className: 'flex-col axis-min gap-2 items-start',
                children: [
                  WText('12',
                      className: 'text-4xl leading-6 font-bold text-black'),
                  WText('Active users on the website',
                      className: 'text-black leading-4'),
                ],
              ),
            ),
            WCard(
              className: 'shadow-lg rounded-lg p-4 bg-green-500',
              child: WFlex(
                className: 'flex-col axis-min gap-2 items-start',
                children: [
                  WText('12',
                      className: 'text-4xl leading-6 font-bold text-white'),
                  WText('Active users on the website',
                      className: 'text-white leading-4'),
                ],
              ),
            ),
          ],
        ),
        WindTheme.getType() == Brightness.dark
            ? WText('You are in dark mode now.', className: 'text-black')
            : MaterialButton(
                onPressed: darkMode, child: Text('Enable Dark Mode')),
      ],
    );
  }
}
