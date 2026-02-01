import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Showcase Example - A stunning demo for the installation page
/// Demonstrates Wind's core features: flexbox, colors, gradients, hover states
class ShowcaseExamplePage extends StatelessWidget {
  const ShowcaseExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'flex items-center justify-center w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className:
            'flex-1 w-full max-w-sm mx-auto rounded-2xl shadow-2xl bg-gradient-to-br from-slate-900 to-slate-800',
        children: [
          // Header with gradient accent
          WDiv(
            className:
                'w-full p-6 bg-gradient-to-r from-indigo-600 to-purple-600 rounded-t-2xl',
            child: WDiv(
              className: 'flex items-center gap-4',
              children: [
                WDiv(
                  className:
                      'w-14 h-14 rounded-full bg-white/20 flex items-center justify-center',
                  child: WIcon(
                    Icons.rocket_launch_rounded,
                    className: 'text-white text-2xl',
                  ),
                ),
                WDiv(
                  children: [
                    WText('Wind UI', className: 'text-xl font-bold text-white'),
                    WText(
                      'Tailwind for Flutter',
                      className: 'text-sm text-indigo-200',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          WDiv(
            className: 'flex flex-col gap-4 p-6',
            children: [
              WText(
                'Build beautiful UIs faster',
                className: 'text-lg font-semibold text-white',
              ),
              WText(
                'Use familiar Tailwind utility classes directly in your Flutter widgets.',
                className: 'text-sm text-gray-400',
              ),

              // Feature list
              WDiv(
                className: 'flex flex-col gap-3 mt-2',
                children: [WText('hello World')],
              ),

              // CTA Button
              WButton(
                onTap: () {},
                child: WDiv(
                  className: '''
                    w-full py-3 rounded-xl bg-gradient-to-r from-indigo-500
                    to-purple-500 text-white font-semibold text-center
                    hover:from-indigo-600 hover:to-purple-600 duration-300
                  ''',
                  child: WText('Get Started'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return WDiv(
      className: 'flex items-center gap-2',
      children: [
        WDiv(
          className:
              'w-7 h-7 rounded-lg bg-indigo-500/20 flex items-center justify-center',
          child: WIcon(icon, className: 'text-indigo-400 text-sm'),
        ),
        WText(text, className: 'text-sm text-gray-300'),
      ],
    );
  }
}
