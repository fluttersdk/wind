import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Example page demonstrating transition duration utilities.
class TransitionDurationPage extends StatelessWidget {
  const TransitionDurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'bg-gray-100 p-8',
      children: [
        WText(
          'Transition Duration',
          className: 'text-2xl font-bold text-gray-900',
        ),
        WDiv(className: 'h-2'),
        WText(
          'Hover over each box to see different duration speeds',
          className: 'text-gray-500',
        ),
        WDiv(className: 'h-8'),

        // Duration grid
        WDiv(
          className: 'flex flex-row gap-4',
          children: [
            _durationBox('duration-75', '75ms'),
            _durationBox('duration-150', '150ms'),
            _durationBox('duration-300', '300ms'),
            _durationBox('duration-500', '500ms'),
            _durationBox('duration-700', '700ms'),
            _durationBox('duration-1000', '1s'),
          ],
        ),

        WDiv(className: 'h-12'),
        WText(
          'Arbitrary Duration',
          className: 'text-xl font-bold text-gray-900',
        ),
        WDiv(className: 'h-4'),
        WDiv(
          className: 'flex flex-row gap-4',
          children: [
            _durationBox('duration-[250]', '250ms'),
            _durationBox('duration-[400ms]', '400ms'),
            _durationBox('duration-[800]', '800ms'),
          ],
        ),
      ],
    );
  }

  Widget _durationBox(String durationClass, String label) {
    return WAnchor(
      onTap: () {},
      child: WDiv(
        className:
            'bg-blue-500 hover:bg-indigo-600 $durationClass px-6 py-4 rounded-xl shadow-md hover:shadow-xl',
        child: WText(label, className: 'text-white font-bold text-lg'),
      ),
    );
  }
}
