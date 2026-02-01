import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WText Widget Showcase
class WTextExamplePage extends StatelessWidget {
  const WTextExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          // Header
          WDiv(
            className: 'w-full p-4 rounded-xl bg-indigo-500',
            children: const [
              WText('WText', className: 'text-lg font-bold text-white'),
              WText(
                'Utility-first text widget',
                className: 'text-sm text-indigo-100',
              ),
            ],
          ),

          // Font Size
          _section('Font Size', 'Control size with text-{size}', const [
            WText(
              'text-xs',
              className: 'text-xs text-gray-800 dark:text-white',
            ),
            WText(
              'text-sm',
              className: 'text-sm text-gray-800 dark:text-white',
            ),
            WText(
              'text-base',
              className: 'text-base text-gray-800 dark:text-white',
            ),
            WText(
              'text-lg',
              className: 'text-lg text-gray-800 dark:text-white',
            ),
            WText(
              'text-xl',
              className: 'text-xl text-gray-800 dark:text-white',
            ),
            WText(
              'text-2xl',
              className: 'text-2xl text-gray-800 dark:text-white',
            ),
          ]),

          // Font Weight
          _section('Font Weight', 'Control weight with font-{weight}', const [
            WText(
              'font-light',
              className: 'font-light text-lg text-gray-800 dark:text-white',
            ),
            WText(
              'font-normal',
              className: 'font-normal text-lg text-gray-800 dark:text-white',
            ),
            WText(
              'font-medium',
              className: 'font-medium text-lg text-gray-800 dark:text-white',
            ),
            WText(
              'font-semibold',
              className: 'font-semibold text-lg text-gray-800 dark:text-white',
            ),
            WText(
              'font-bold',
              className: 'font-bold text-lg text-gray-800 dark:text-white',
            ),
          ]),

          // Font Style
          _section('Font Style', 'Italic text', const [
            WText(
              'italic',
              className: 'italic text-lg text-gray-800 dark:text-white',
            ),
            WText(
              'not-italic',
              className: 'not-italic text-lg text-gray-800 dark:text-white',
            ),
          ]),

          // Text Transform
          _section('Text Transform', 'Change case', const [
            WText(
              'uppercase',
              className: 'uppercase text-gray-800 dark:text-white',
            ),
            WText(
              'LOWERCASE',
              className: 'lowercase text-gray-800 dark:text-white',
            ),
            WText(
              'capitalize me',
              className: 'capitalize text-gray-800 dark:text-white',
            ),
          ]),

          // Text Decoration
          _section('Text Decoration', 'Underline and strikethrough', const [
            WText(
              'underline',
              className: 'underline text-lg text-gray-800 dark:text-white',
            ),
            WText(
              'line-through',
              className: 'line-through text-lg text-gray-800 dark:text-white',
            ),
            WText(
              'overline',
              className: 'overline text-lg text-gray-800 dark:text-white',
            ),
          ]),

          // Tracking
          _section('Letter Spacing', 'tracking-{value}', const [
            WText(
              'tracking-tight',
              className: 'tracking-tight text-lg text-gray-800 dark:text-white',
            ),
            WText(
              'tracking-normal',
              className:
                  'tracking-normal text-lg text-gray-800 dark:text-white',
            ),
            WText(
              'tracking-wide',
              className: 'tracking-wide text-lg text-gray-800 dark:text-white',
            ),
          ]),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'Quick Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _ref('text-{size}', 'xs, sm, base, lg, xl, 2xl'),
                  _ref('font-{weight}', 'light, normal, bold'),
                  _ref('italic', 'Italic text'),
                  _ref('uppercase', 'Transform case'),
                  _ref('underline', 'Text decoration'),
                  _ref('tracking-*', 'Letter spacing'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section(String title, String desc, List<Widget> items) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(
          title,
          className: 'font-semibold text-gray-800 dark:text-white font-mono',
        ),
        WText(desc, className: 'text-sm text-gray-500 dark:text-gray-400'),
        WDiv(
          className:
              'flex flex-wrap gap-4 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg overflow-x-auto',
          children: items,
        ),
      ],
    );
  }

  Widget _ref(String cls, String desc) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          cls,
          className: 'font-mono text-sm text-indigo-600 dark:text-indigo-400',
        ),
        WText(desc, className: 'text-sm text-gray-600 dark:text-gray-300'),
      ],
    );
  }
}
