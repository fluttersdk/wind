import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ExampleScaffold extends StatelessWidget {
  final String title;
  final String description;
  final String gradient;
  final List<Widget> children;

  const ExampleScaffold({
    super.key,
    required this.title,
    required this.description,
    this.gradient = 'from-blue-500 to-indigo-600',
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        w-full h-full overflow-y-auto p-4
        bg-slate-50 dark:bg-slate-900
      ''',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto pb-12',
        children: [
          _ExampleHeader(
            title: title,
            description: description,
            gradient: gradient,
          ),
          ...children,
        ],
      ),
    );
  }
}

class _ExampleHeader extends StatelessWidget {
  final String title;
  final String description;
  final String gradient;

  const _ExampleHeader({
    required this.title,
    required this.description,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WDiv(
      className: 'bg-gradient-to-r $gradient rounded-xl p-6',
      child: WDiv(
        className: 'flex flex-row items-start gap-4',
        children: [
          WDiv(
            className: 'flex-1 flex flex-col gap-2',
            children: [
              WText(
                title,
                className: 'text-2xl font-bold text-white',
              ),
              WText(
                description,
                className: 'text-sm text-white/80',
              ),
            ],
          ),
          WButton(
            onTap: () => WindTheme.of(context).toggleTheme(),
            className: '''
              bg-white/20 hover:bg-white/30
              rounded-full w-10 h-10
              flex items-center justify-center
              shrink-0
            ''',
            child: WIcon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              className: 'text-white w-5 h-5',
            ),
          ),
        ],
      ),
    );
  }
}

class ExampleSection extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const ExampleSection({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-col gap-4 p-5 rounded-xl
        bg-white dark:bg-slate-800
        border border-slate-200 dark:border-slate-700
        overflow-hidden
      ''',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
          children: [
            WText(
              title,
              className: 'text-lg font-semibold text-slate-900 dark:text-white',
            ),
            WText(
              description,
              className: 'text-sm text-slate-600 dark:text-slate-400',
            ),
          ],
        ),
        child,
      ],
    );
  }
}
