import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WBreakpoint Example
/// Demonstrates declarative per-breakpoint widget trees.
class WBreakpointExamplePage extends StatelessWidget {
  const WBreakpointExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-3xl',
        children: [
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-indigo-500 to-violet-500
            ''',
            children: [
              WText(
                'WBreakpoint',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Render different widget trees per breakpoint. Resize to see it switch.',
                className: 'text-sm text-indigo-100',
              ),
            ],
          ),
          _buildSection(
            title: 'Different tree per breakpoint',
            description:
                'Stacked column on small screens, horizontal row on md+.',
            child: WBreakpoint(
              base: (_) => WDiv(
                className:
                    'flex flex-col gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
                children: [
                  _tag('A', 'bg-rose-500'),
                  _tag('B', 'bg-rose-500'),
                  _tag('C', 'bg-rose-500'),
                ],
              ),
              md: (_) => WDiv(
                className:
                    'flex gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
                children: [
                  _tag('A', 'bg-emerald-500'),
                  _tag('B', 'bg-emerald-500'),
                  _tag('C', 'bg-emerald-500'),
                ],
              ),
            ),
          ),
          _buildSection(
            title: 'Different child counts',
            description:
                'Mobile shows a compact summary; wider breakpoints add detail columns.',
            child: WBreakpoint(
              base: (_) => WDiv(
                className:
                    'p-4 bg-gray-100 dark:bg-slate-700 rounded-lg flex flex-col gap-1',
                children: [
                  WText('Total revenue',
                      className:
                          'text-xs text-gray-500 dark:text-gray-300 uppercase'),
                  WText('\$12,430',
                      className:
                          'text-2xl font-bold text-gray-900 dark:text-white'),
                ],
              ),
              md: (_) => WDiv(
                className:
                    'grid grid-cols-3 gap-4 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
                children: [
                  _statCard('Revenue', '\$12,430', 'bg-emerald-500'),
                  _statCard('Users', '8,210', 'bg-sky-500'),
                  _statCard('Orders', '1,284', 'bg-violet-500'),
                ],
              ),
            ),
          ),
          _buildSection(
            title: 'Fallback chain (lg width, only md defined)',
            description:
                'Walks from active down to any defined lower builder. Here md wins because lg is not provided.',
            child: WBreakpoint(
              base: (_) => _infoBox('BASE builder', 'bg-gray-500'),
              md: (_) => _infoBox('MD builder', 'bg-indigo-500'),
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
      className: 'flex flex-col gap-2',
      children: [
        WText(
          title,
          className: 'text-lg font-semibold text-gray-900 dark:text-white',
        ),
        WText(
          description,
          className: 'text-sm text-gray-600 dark:text-gray-400 mb-2',
        ),
        child,
      ],
    );
  }

  Widget _tag(String label, String bg) {
    return WDiv(
      className: '$bg px-4 h-10 rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white font-bold'),
    );
  }

  Widget _infoBox(String label, String bg) {
    return WDiv(
      className: '$bg p-4 rounded-lg',
      child: WText(label, className: 'text-white font-semibold'),
    );
  }

  Widget _statCard(String label, String value, String bg) {
    return WDiv(
      className: '$bg p-3 rounded-lg flex flex-col gap-1',
      children: [
        WText(label, className: 'text-xs text-white/80 uppercase'),
        WText(value, className: 'text-xl font-bold text-white'),
      ],
    );
  }
}
