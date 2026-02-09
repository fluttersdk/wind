import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Demonstrates responsive design with breakpoint prefixes.
class ResponsiveBasicExamplePage extends StatelessWidget {
  const ResponsiveBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildBreakpointIndicator(context),
          _buildResponsiveLayoutDemo(),
          _buildResponsiveCardDemo(),
          _buildBreakpointReference(),
          _buildPlatformPrefixes(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-rose-500 to-pink-600 rounded-xl p-6',
      child: WDiv(
        className: 'flex flex-col gap-2',
        children: [
          WText(
            'Responsive Design',
            className: 'text-2xl font-bold text-white',
          ),
          WText(
            'Mobile-first breakpoints: utilities apply at specified width and up.',
            className: 'text-rose-100',
          ),
        ],
      ),
    );
  }

  Widget _buildBreakpointIndicator(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    String currentBreakpoint;
    String color;
    if (width >= 1536) {
      currentBreakpoint = '2xl (≥1536px)';
      color = 'bg-purple-500';
    } else if (width >= 1280) {
      currentBreakpoint = 'xl (≥1280px)';
      color = 'bg-blue-500';
    } else if (width >= 1024) {
      currentBreakpoint = 'lg (≥1024px)';
      color = 'bg-green-500';
    } else if (width >= 768) {
      currentBreakpoint = 'md (≥768px)';
      color = 'bg-yellow-500';
    } else if (width >= 640) {
      currentBreakpoint = 'sm (≥640px)';
      color = 'bg-orange-500';
    } else {
      currentBreakpoint = 'base (<640px)';
      color = 'bg-red-500';
    }

    return _buildSection(
      title: 'Current Breakpoint',
      description: 'Resize your window to see the breakpoint change',
      child: WDiv(
        className: 'flex items-center gap-4',
        children: [
          WDiv(
            className: '$color px-4 py-2 rounded-lg',
            child: WText(
              currentBreakpoint,
              className: 'text-white font-bold',
            ),
          ),
          WText(
            'Width: ${width.toInt()}px',
            className: 'text-slate-600 dark:text-slate-400 font-mono',
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveLayoutDemo() {
    return _buildSection(
      title: 'Responsive Layout',
      description: 'Stacks vertically on mobile, horizontal on md+ screens',
      child: WDiv(
        className: 'flex flex-col md:flex-row gap-4',
        children: [
          WDiv(
            className: 'flex-1 p-6 bg-blue-100 dark:bg-blue-900/30 rounded-xl',
            child: WDiv(
              className: 'flex flex-col items-center gap-2',
              children: [
                WDiv(
                  className:
                      'w-12 h-12 bg-blue-500 rounded-lg flex items-center justify-center',
                  child: WIcon(Icons.widgets, className: 'text-white w-6 h-6'),
                ),
                WText('Column 1',
                    className:
                        'font-semibold text-blue-700 dark:text-blue-300'),
                WText('flex-col → md:flex-row',
                    className: 'text-xs text-blue-500 font-mono'),
              ],
            ),
          ),
          WDiv(
            className:
                'flex-1 p-6 bg-green-100 dark:bg-green-900/30 rounded-xl',
            child: WDiv(
              className: 'flex flex-col items-center gap-2',
              children: [
                WDiv(
                  className:
                      'w-12 h-12 bg-green-500 rounded-lg flex items-center justify-center',
                  child:
                      WIcon(Icons.dashboard, className: 'text-white w-6 h-6'),
                ),
                WText('Column 2',
                    className:
                        'font-semibold text-green-700 dark:text-green-300'),
                WText('Adapts to screen',
                    className: 'text-xs text-green-500 font-mono'),
              ],
            ),
          ),
          WDiv(
            className:
                'flex-1 p-6 bg-purple-100 dark:bg-purple-900/30 rounded-xl',
            child: WDiv(
              className: 'flex flex-col items-center gap-2',
              children: [
                WDiv(
                  className:
                      'w-12 h-12 bg-purple-500 rounded-lg flex items-center justify-center',
                  child: WIcon(Icons.auto_awesome,
                      className: 'text-white w-6 h-6'),
                ),
                WText('Column 3',
                    className:
                        'font-semibold text-purple-700 dark:text-purple-300'),
                WText('Mobile-first!',
                    className: 'text-xs text-purple-500 font-mono'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveCardDemo() {
    return _buildSection(
      title: 'Responsive Card',
      description: 'Colors, padding, and borders change at breakpoints',
      child: WDiv(
        // Base (mobile): red, small padding, no border
        // sm: orange, medium padding
        // md: yellow, add border
        // lg: green, larger padding
        // xl: blue, larger rounded
        className: '''
          p-4 sm:p-6 md:p-8 lg:p-10
          bg-red-100 sm:bg-orange-100 md:bg-yellow-100 lg:bg-green-100 xl:bg-blue-100
          dark:bg-red-900/30 dark:sm:bg-orange-900/30 dark:md:bg-yellow-900/30 dark:lg:bg-green-900/30 dark:xl:bg-blue-900/30
          rounded-lg md:rounded-xl xl:rounded-2xl
          md:border md:border-slate-200 dark:md:border-slate-700
        ''',
        child: WDiv(
          className: 'flex flex-col gap-2',
          children: [
            WText(
              'Responsive Card',
              className: '''
                text-base sm:text-lg md:text-xl lg:text-2xl
                font-semibold
                text-red-700 sm:text-orange-700 md:text-yellow-700 lg:text-green-700 xl:text-blue-700
                dark:text-red-300 dark:sm:text-orange-300 dark:md:text-yellow-300 dark:lg:text-green-300 dark:xl:text-blue-300
              ''',
            ),
            WText(
              'Watch the colors, padding, borders, and text size change as you resize!',
              className: 'text-sm text-slate-600 dark:text-slate-400',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakpointReference() {
    final breakpoints = [
      ('sm:', '640px', 'Small devices'),
      ('md:', '768px', 'Tablets'),
      ('lg:', '1024px', 'Laptops'),
      ('xl:', '1280px', 'Desktops'),
      ('2xl:', '1536px', 'Large screens'),
    ];

    return _buildSection(
      title: 'Breakpoint Reference',
      description: 'Mobile-first: styles apply from the breakpoint and up',
      child: WDiv(
        className:
            'grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-3',
        children: breakpoints.map((entry) {
          final (prefix, width, label) = entry;
          return WDiv(
            className:
                'p-3 bg-slate-100 dark:bg-slate-700 rounded-lg text-center',
            children: [
              WText(prefix,
                  className: 'text-lg font-bold text-primary font-mono'),
              WText(width,
                  className: 'text-sm text-slate-600 dark:text-slate-400'),
              WText(label,
                  className: 'text-xs text-slate-500 dark:text-slate-500 mt-1'),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlatformPrefixes() {
    final platforms = [
      ('ios:', Icons.phone_iphone, 'iOS devices'),
      ('android:', Icons.android, 'Android devices'),
      ('web:', Icons.web, 'Web browsers'),
      ('macos:', Icons.laptop_mac, 'macOS'),
      ('windows:', Icons.desktop_windows, 'Windows'),
      ('mobile:', Icons.smartphone, 'iOS + Android'),
    ];

    return _buildSection(
      title: 'Platform Prefixes',
      description: 'Target specific platforms with conditional styling',
      child: WDiv(
        className: 'grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-3',
        children: platforms.map((entry) {
          final (prefix, icon, label) = entry;
          return WDiv(
            className:
                'p-3 bg-slate-50 dark:bg-slate-700/50 rounded-lg flex flex-col items-center gap-2',
            children: [
              WIcon(icon,
                  className: 'text-slate-600 dark:text-slate-400 w-6 h-6'),
              WText(prefix,
                  className:
                      'text-sm font-mono font-medium text-slate-900 dark:text-white'),
              WText(label, className: 'text-xs text-slate-500 text-center'),
            ],
          );
        }).toList(),
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
          'flex flex-col gap-4 p-5 bg-white dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className:
                    'text-lg font-semibold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-600 dark:text-slate-400'),
          ],
        ),
        child,
      ],
    );
  }
}
