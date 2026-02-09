import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TextAlignResponsiveExamplePage extends StatelessWidget {
  const TextAlignResponsiveExamplePage({super.key});

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
            title: 'Center on Mobile, Left on Desktop',
            description: 'text-center md:text-left',
            child: WDiv(
              className:
                  'w-full p-4 bg-slate-100 dark:bg-slate-800 rounded border border-slate-200 dark:border-slate-700',
              child: WText(
                'This text is centered on mobile screens and aligned to the left on larger screens (md and up). Resize the window to see the change.',
                className:
                    'text-center md:text-left text-slate-900 dark:text-white',
              ),
            ),
          ),
          _buildSection(
            title: 'Left on Mobile, Right on Desktop',
            description: 'text-left md:text-right',
            child: WDiv(
              className:
                  'w-full p-4 bg-slate-100 dark:bg-slate-800 rounded border border-slate-200 dark:border-slate-700',
              child: WText(
                'This text starts left-aligned but jumps to the right side on desktop screens.',
                className:
                    'text-left md:text-right text-slate-900 dark:text-white',
              ),
            ),
          ),
          _buildSection(
            title: 'Multi-breakpoint Alignment',
            description: 'text-center md:text-left lg:text-right',
            child: WDiv(
              className:
                  'w-full p-4 bg-slate-100 dark:bg-slate-800 rounded border border-slate-200 dark:border-slate-700',
              child: WText(
                'This text changes alignment three times: Center (mobile), Left (tablet), and Right (desktop).',
                className:
                    'text-center md:text-left lg:text-right text-slate-900 dark:text-white',
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
        'Responsive Text Alignment',
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
