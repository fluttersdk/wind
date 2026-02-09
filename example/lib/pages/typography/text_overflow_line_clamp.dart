import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class TextOverflowLineClampExamplePage extends StatelessWidget {
  const TextOverflowLineClampExamplePage({super.key});

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
            title: 'Line Clamp',
            description:
                'Use line-clamp-{n} to truncate text after a specific number of lines.',
            child: _buildExample(),
          ),
          _buildSection(
            title: 'Interactive Example',
            description: 'Tap to toggle between clamped and full text.',
            child: const _InteractiveLineClamp(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-teal-500 to-emerald-600 rounded-xl p-6',
      child: WText(
        'Text Overflow: Line Clamp',
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
          'flex flex-col gap-4 p-4 bg-white dark:bg-slate-800 rounded-lg shadow-sm border border-slate-200 dark:border-slate-700',
      children: [
        WText(title,
            className: 'text-lg font-semibold text-slate-900 dark:text-white'),
        WText(description,
            className: 'text-sm text-slate-600 dark:text-slate-400'),
        WDiv(
          className:
              'p-6 bg-slate-50 dark:bg-slate-900 rounded-lg border border-slate-200 dark:border-slate-700',
          child: child,
        ),
      ],
    );
  }

  Widget _buildExample() {
    const sampleText =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.';

    return WDiv(
      className: 'grid grid-cols-1 md:grid-cols-3 gap-6',
      children: [
        // Line Clamp 1
        WDiv(
          className:
              'bg-white dark:bg-slate-800 p-4 rounded border border-slate-200 dark:border-slate-700 flex flex-col gap-2',
          children: [
            WText('line-clamp-1',
                className:
                    'text-xs font-bold text-teal-600 uppercase tracking-wider'),
            const WText(
              sampleText,
              className: 'line-clamp-1 text-slate-900 dark:text-white',
            ),
          ],
        ),

        // Line Clamp 2
        WDiv(
          className:
              'bg-white dark:bg-slate-800 p-4 rounded border border-slate-200 dark:border-slate-700 flex flex-col gap-2',
          children: [
            WText('line-clamp-2',
                className:
                    'text-xs font-bold text-teal-600 uppercase tracking-wider'),
            const WText(
              sampleText,
              className: 'line-clamp-2 text-slate-900 dark:text-white',
            ),
          ],
        ),

        // Line Clamp 3
        WDiv(
          className:
              'bg-white dark:bg-slate-800 p-4 rounded border border-slate-200 dark:border-slate-700 flex flex-col gap-2',
          children: [
            WText('line-clamp-3',
                className:
                    'text-xs font-bold text-teal-600 uppercase tracking-wider'),
            const WText(
              sampleText,
              className: 'line-clamp-3 text-slate-900 dark:text-white',
            ),
          ],
        ),
      ],
    );
  }
}

class _InteractiveLineClamp extends StatefulWidget {
  const _InteractiveLineClamp();

  @override
  State<_InteractiveLineClamp> createState() => _InteractiveLineClampState();
}

class _InteractiveLineClampState extends State<_InteractiveLineClamp> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full max-w-md',
      children: [
        WAnchor(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: WDiv(
            className:
                'bg-white dark:bg-slate-800 p-6 rounded-lg border border-slate-200 dark:border-slate-700 hover:shadow-md transition-shadow cursor-pointer',
            children: [
              WText(
                'Tap to expand/collapse',
                className: 'text-xs font-bold text-slate-400 mb-2 uppercase',
              ),
              WText(
                'This is a long paragraph that can be expanded to show more content. It demonstrates how line-clamp can be toggled dynamically based on state. Clicking this card will remove the line-clamp class and allow the full text to be displayed, showing the complete message to the user.',
                className:
                    '${_isExpanded ? "" : "line-clamp-2"} text-slate-900 dark:text-white transition-all',
              ),
              WDiv(
                className: 'mt-2 flex justify-end',
                child: WText(
                  _isExpanded ? 'Show less' : 'Read more',
                  className: 'text-teal-600 text-sm font-medium',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
