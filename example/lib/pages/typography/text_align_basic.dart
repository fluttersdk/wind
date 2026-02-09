import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TextAlignBasicExamplePage extends StatelessWidget {
  const TextAlignBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Left Alignment',
            description: 'Default text alignment (text-left)',
            child: WDiv(
              className:
                  'w-full p-4 bg-slate-100 dark:bg-slate-800 rounded border border-slate-200 dark:border-slate-700',
              child: WText(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                className: 'text-left text-slate-900 dark:text-white',
              ),
            ),
          ),
          _buildSection(
            title: 'Center Alignment',
            description: 'Centered text (text-center)',
            child: WDiv(
              className:
                  'w-full p-4 bg-slate-100 dark:bg-slate-800 rounded border border-slate-200 dark:border-slate-700',
              child: WText(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                className: 'text-center text-slate-900 dark:text-white',
              ),
            ),
          ),
          _buildSection(
            title: 'Right Alignment',
            description: 'Right-aligned text (text-right)',
            child: WDiv(
              className:
                  'w-full p-4 bg-slate-100 dark:bg-slate-800 rounded border border-slate-200 dark:border-slate-700',
              child: WText(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                className: 'text-right text-slate-900 dark:text-white',
              ),
            ),
          ),
          _buildSection(
            title: 'Justified Alignment',
            description: 'Justified text (text-justify)',
            child: WDiv(
              className:
                  'w-full p-4 bg-slate-100 dark:bg-slate-800 rounded border border-slate-200 dark:border-slate-700',
              child: WText(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                className: 'text-justify text-slate-900 dark:text-white',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl p-6',
      child: WText(
        'Text Alignment Basic',
        className: 'text-2xl font-bold text-white',
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className:
          'flex flex-col gap-4 p-4 bg-white dark:bg-slate-800 rounded-lg shadow-sm',
      children: [
        WText(title,
            className: 'text-lg font-semibold text-slate-900 dark:text-white'),
        WText(description,
            className: 'text-sm text-slate-600 dark:text-slate-400'),
        child,
      ],
    );
  }
}
