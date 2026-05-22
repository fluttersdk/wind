import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class ResponsiveBasicExamplePage extends StatelessWidget {
  const ResponsiveBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Responsive Design',
      description:
          'Mobile-first breakpoints. Prefix any utility with sm:, md:, lg:, xl:, or 2xl: and it activates at that width and above.',
      gradient: 'from-rose-500 to-pink-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Stacked on mobile, horizontal on md+. The same className resolves a different layout per breakpoint.',
          child: WDiv(
            className: '''
              flex flex-col md:flex-row gap-4 p-4 rounded-lg
              bg-gray-100 md:bg-blue-50
              dark:bg-slate-700 dark:md:bg-blue-900/30
            ''',
            children: [
              WDiv(className: 'w-full md:w-1/2 h-24 bg-blue-500 rounded'),
              WDiv(className: 'w-full md:w-1/2 h-24 bg-red-500 rounded'),
            ],
          ),
        ),
        const _BreakpointIndicator(),
        ExampleSection(
          title: 'Mobile-First Approach',
          description:
              'Classes without a prefix apply to every screen. Add lg: to override only on large screens and up.',
          child: WDiv(
            className: '''
              p-6 rounded-lg text-white text-center font-medium
              bg-blue-500 lg:bg-green-500
            ''',
            child: WText('bg-blue-500 lg:bg-green-500'),
          ),
        ),
        ExampleSection(
          title: 'Breakpoint Reference',
          description:
              'Five built-in breakpoints. Each value is the MINIMUM width at which the modifier activates.',
          child: WDiv(
            className: '''
              grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-3
            ''',
            children: const [
              _BreakpointTile(prefix: 'sm:', width: '640px', use: 'Phones'),
              _BreakpointTile(prefix: 'md:', width: '768px', use: 'Tablets'),
              _BreakpointTile(prefix: 'lg:', width: '1024px', use: 'Laptops'),
              _BreakpointTile(prefix: 'xl:', width: '1280px', use: 'Desktops'),
              _BreakpointTile(prefix: '2xl:', width: '1536px', use: 'Large'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Platform Prefixes',
          description:
              'Wind also recognizes platform modifiers. Apply styles per operating system or runtime.',
          child: WDiv(
            className: '''
              grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-7 gap-3
            ''',
            children: const [
              _PlatformTile(prefix: 'ios:', icon: Icons.phone_iphone),
              _PlatformTile(prefix: 'android:', icon: Icons.android),
              _PlatformTile(prefix: 'macos:', icon: Icons.laptop_mac),
              _PlatformTile(prefix: 'web:', icon: Icons.web),
              _PlatformTile(prefix: 'mobile:', icon: Icons.smartphone),
              _PlatformTile(prefix: 'windows:', icon: Icons.desktop_windows),
              _PlatformTile(prefix: 'linux:', icon: Icons.computer),
            ],
          ),
        ),
        ExampleSection(
          title: 'Combining Modifiers',
          description:
              'Chain breakpoint, mode, and state prefixes. Order is strict: breakpoint first, then state.',
          child: WDiv(
            className: 'flex flex-col gap-3',
            children: [
              WButton(
                onTap: () {},
                className: '''
                  bg-blue-500 lg:dark:hover:bg-indigo-600
                  text-white px-4 py-3 rounded-lg self-start
                ''',
                child: const WText('lg:dark:hover:bg-indigo-600',
                    className: 'text-white font-mono text-sm'),
              ),
              WDiv(
                className: '''
                  p-3 rounded-lg font-mono text-xs
                  bg-slate-100 dark:bg-slate-700
                  text-slate-700 dark:text-slate-300
                ''',
                child: WText(
                  'breakpoint  :  state  :  utility\nlg          :  hover  :  bg-indigo-600',
                  className: 'whitespace-pre',
                ),
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Customizing Breakpoints',
          description:
              'Override the default scale via WindThemeData.screens. Custom keys become new prefixes.',
          child: WDiv(
            className: '''
              p-4 rounded-lg font-mono text-xs
              bg-slate-900 dark:bg-slate-950
              text-emerald-400
              overflow-x-auto
            ''',
            child: WText(
              'WindTheme(\n'
              '  data: WindThemeData(\n'
              '    screens: {\n'
              '      "tablet": 600,\n'
              '      "laptop": 900,\n'
              '      "desktop": 1200,\n'
              '    },\n'
              '  ),\n'
              '  child: MyApp(),\n'
              ')',
              className: 'whitespace-pre text-emerald-400',
            ),
          ),
        ),
      ],
    );
  }
}

class _BreakpointIndicator extends StatelessWidget {
  const _BreakpointIndicator();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final (label, badgeClass) = _resolveBadge(width);

    return ExampleSection(
      title: 'Current Breakpoint',
      description:
          'Resize the window. The badge updates whenever your width crosses a threshold.',
      child: WDiv(
        className: 'flex items-center gap-3',
        children: [
          WDiv(
            className: '$badgeClass px-4 py-2 rounded-lg',
            child: WText(
              label,
              className: 'text-white font-bold font-mono',
            ),
          ),
          WText(
            'Width: ${width.toInt()}px',
            className: 'font-mono text-slate-600 dark:text-slate-400',
          ),
        ],
      ),
    );
  }

  (String, String) _resolveBadge(double width) {
    if (width >= 1536) return ('2xl (≥1536px)', 'bg-purple-500');
    if (width >= 1280) return ('xl (≥1280px)', 'bg-blue-500');
    if (width >= 1024) return ('lg (≥1024px)', 'bg-green-500');
    if (width >= 768) return ('md (≥768px)', 'bg-yellow-500');
    if (width >= 640) return ('sm (≥640px)', 'bg-orange-500');
    return ('base (<640px)', 'bg-red-500');
  }
}

class _BreakpointTile extends StatelessWidget {
  final String prefix;
  final String width;
  final String use;

  const _BreakpointTile({
    required this.prefix,
    required this.width,
    required this.use,
  });

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-col gap-1 p-3 rounded-lg
        bg-slate-50 dark:bg-slate-700/40
        border border-slate-200 dark:border-slate-700
      ''',
      children: [
        WText(
          prefix,
          className: 'font-mono font-bold text-rose-600 dark:text-rose-400',
        ),
        WText(
          width,
          className: 'text-sm font-mono text-slate-700 dark:text-slate-300',
        ),
        WText(
          use,
          className: 'text-xs text-slate-500 dark:text-slate-400',
        ),
      ],
    );
  }
}

class _PlatformTile extends StatelessWidget {
  final String prefix;
  final IconData icon;

  const _PlatformTile({required this.prefix, required this.icon});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        flex flex-col items-center gap-2 p-3 rounded-lg
        bg-slate-50 dark:bg-slate-700/40
        border border-slate-200 dark:border-slate-700
      ''',
      children: [
        WIcon(
          icon,
          className: 'w-5 h-5 text-slate-600 dark:text-slate-400',
        ),
        WText(
          prefix,
          className:
              'font-mono text-sm font-medium text-slate-900 dark:text-white',
        ),
      ],
    );
  }
}
