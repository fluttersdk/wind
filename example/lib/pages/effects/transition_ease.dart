import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Example page demonstrating transition ease/timing utilities.
class TransitionEasePage extends StatelessWidget {
  const TransitionEasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      child: Scaffold(
        body: WDiv(
          className: 'bg-gray-100 p-8',
          children: [
            WText(
              'Transition Ease',
              className: 'text-2xl font-bold text-gray-900',
            ),
            WDiv(className: 'h-2'),
            WText(
              'Hover over each box to see different timing curves',
              className: 'text-gray-500',
            ),
            WDiv(className: 'h-8'),

            // Ease examples - all same duration for comparison
            WDiv(
              className: 'flex flex-row gap-6',
              children: [
                _easeBox(
                  'ease-linear',
                  'Linear',
                  'bg-emerald-500 hover:bg-emerald-700',
                ),
                _easeBox('ease-in', 'Ease In', 'bg-sky-500 hover:bg-sky-700'),
                _easeBox(
                  'ease-out',
                  'Ease Out',
                  'bg-violet-500 hover:bg-violet-700',
                ),
                _easeBox(
                  'ease-in-out',
                  'Ease In Out',
                  'bg-rose-500 hover:bg-rose-700',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _easeBox(String easeClass, String label, String colorClasses) {
    return WAnchor(
      onTap: () {},
      child: WDiv(
        className:
            '$colorClasses duration-700 $easeClass w-[140px] py-5 rounded-xl shadow-md hover:shadow-xl',
        child: WText(label, className: 'text-white font-bold text-center'),
      ),
    );
  }
}
