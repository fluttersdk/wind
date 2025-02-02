import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'w-full h-full justify-center flex-col items-center bg-gray-200',
      children: [
        WText('Welcome to wind.',
            className: 'text-primary-500 text-5xl font-bold'),
        WText('Made with ❤️ by Anılcan Çakır',
            className: 'text-gray-500'),
      ],
    );
  }
}
