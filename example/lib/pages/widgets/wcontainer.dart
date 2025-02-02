import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/wind.dart';

class WContainerWidget extends StatelessWidget {
  const WContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'flex-col items-center justify-center gap-4 bg-white',
      children: [
        WContainer(
          className: 'bg-gray-200 p-4 rounded-lg',
          child:
              WText('This is a container', className: 'text-lg text-gray-700'),
        )
      ],
    );
  }
}
