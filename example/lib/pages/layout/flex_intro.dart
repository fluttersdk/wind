import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Flex Intro Example
/// Hero example showing the power of flexbox in Wind
class FlexIntroExamplePage extends StatelessWidget {
  const FlexIntroExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          // Header
          WDiv(
            className:
                'bg-gradient-to-r from-indigo-500 to-purple-600 rounded-xl p-6',
            children: [
              WText(
                'Flexbox & Layout',
                className: 'text-2xl font-bold text-white',
              ),
              WText(
                'Powerful layout utilities for building any design',
                className: 'text-indigo-100 mt-2',
              ),
            ],
          ),

          // Hero Demo: Navigation Bar
          _buildSection(
            title: 'Navigation Bar',
            description: 'flex justify-between items-center',
            child: WDiv(
              className:
                  'flex justify-between items-center p-4 bg-white dark:bg-slate-800 rounded-lg shadow-sm',
              children: [
                WText('Logo',
                    className:
                        'text-lg font-bold text-indigo-600 dark:text-indigo-400'),
                WDiv(
                  className: 'flex gap-4',
                  children: [
                    WText('Home',
                        className: 'text-slate-600 dark:text-slate-300'),
                    WText('About',
                        className: 'text-slate-600 dark:text-slate-300'),
                    WText('Contact',
                        className: 'text-slate-600 dark:text-slate-300'),
                  ],
                ),
              ],
            ),
          ),

          // Hero Demo: Card Layout
          _buildSection(
            title: 'Card with Actions',
            description: 'flex flex-col gap-4',
            child: WDiv(
              className:
                  'flex flex-col gap-4 p-6 bg-white dark:bg-slate-800 rounded-lg shadow-sm',
              children: [
                WText('Card Title',
                    className:
                        'text-xl font-bold text-slate-900 dark:text-white'),
                WText(
                  'This is a simple card built with flexbox. The content flows vertically with consistent spacing.',
                  className: 'text-slate-600 dark:text-slate-400',
                ),
                WDiv(
                  className: 'flex gap-2 justify-end',
                  children: [
                    WDiv(
                      className:
                          'px-4 py-2 bg-slate-100 dark:bg-slate-700 rounded-lg',
                      child: WText('Cancel',
                          className: 'text-slate-700 dark:text-slate-300'),
                    ),
                    WDiv(
                      className: 'px-4 py-2 bg-indigo-500 rounded-lg',
                      child: WText('Save', className: 'text-white'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Hero Demo: Responsive Grid-like Layout
          _buildSection(
            title: 'Responsive Layout',
            description: 'flex flex-col md:flex-row gap-4',
            child: WDiv(
              className: 'flex flex-col md:flex-row gap-4',
              children: [
                _buildFeatureCard(
                  'Row & Column',
                  'Use flex-row and flex-col',
                  'bg-blue-500',
                ),
                _buildFeatureCard(
                  'Alignment',
                  'justify-* and items-*',
                  'bg-green-500',
                ),
                _buildFeatureCard(
                  'Spacing',
                  'gap-* for consistent spacing',
                  'bg-purple-500',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className: 'flex flex-col gap-3',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className:
                    'text-lg font-semibold text-slate-900 dark:text-white'),
            WDiv(
              className:
                  'px-2 py-1 bg-slate-100 dark:bg-slate-700 rounded w-fit',
              child: WText(
                description,
                className:
                    'text-xs font-mono text-slate-600 dark:text-slate-400',
              ),
            ),
          ],
        ),
        child,
      ],
    );
  }

  Widget _buildFeatureCard(String title, String description, String bgColor) {
    return WDiv(
      className: 'flex-1 $bgColor rounded-lg p-4',
      children: [
        WText(title, className: 'text-white font-bold'),
        WText(description, className: 'text-white/80 text-sm mt-1'),
      ],
    );
  }
}
