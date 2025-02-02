import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TextAlignmentCenter extends StatelessWidget {
  const TextAlignmentCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max bg-gray-100',
      children: [
        WCard(
          className: 'p-4 w-120 h-60 bg-white rounded-lg shadow-md',
          child: WText(
            'Centered Text',
            className: 'text-center',
          ),
        )
      ],
    );
  }
}

class TextAlignmentRight extends StatelessWidget {
  const TextAlignmentRight({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max bg-gray-100',
      children: [
        WCard(
          className: 'p-4 w-120 h-60 bg-white rounded-lg shadow-md',
          child: WText(
            'Right-Aligned Text',
            className: 'text-right',
          ),
        )
      ],
    );
  }
}

class TextAlignmentJustify extends StatelessWidget {
  const TextAlignmentJustify({super.key});

  @override
  Widget build(BuildContext context) {
    return WFlexContainer(
      className: 'items-center justify-center axis-max bg-gray-100',
      children: [
        WCard(
          className: 'p-4 w-120 h-60 bg-white rounded-lg shadow-md',
          child: WText(
            'This text is justified. The edges are evenly aligned, creating a clean and formal look.',
            className: 'text-justify',
          ),
        )
      ],
    );
  }
}


