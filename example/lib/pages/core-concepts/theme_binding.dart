import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Demonstrates WindTheme integration with MaterialApp theming.
class ThemeBindingExamplePage extends StatelessWidget {
  const ThemeBindingExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildThemeToggle(context),
          _buildTokenMappingDemo(context),
          _buildSyncExplanation(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-sky-500 to-indigo-600 rounded-xl p-6',
      child: WDiv(
        className: 'flex flex-col gap-2',
        children: [
          WText(
            'Theme Binding',
            className: 'text-2xl font-bold text-white',
          ),
          WText(
            'Sync WindTheme with MaterialApp for consistent theming across all widgets.',
            className: 'text-sky-100',
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    final controller = WindTheme.of(context);
    final isDark = controller.brightness == Brightness.dark;

    return _buildSection(
      title: 'Theme Toggle',
      description:
          'Toggle between light and dark mode using WindTheme controller',
      child: WDiv(
        className: 'flex flex-col gap-4',
        children: [
          WDiv(
            className: 'flex items-center gap-4',
            children: [
              WButton(
                className:
                    'bg-primary hover:bg-primary/90 text-white px-6 py-3 rounded-xl font-medium',
                onTap: () => controller.toggleTheme(),
                child: WDiv(
                  className: 'flex items-center gap-2',
                  children: [
                    WIcon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      className: 'text-white w-5 h-5',
                    ),
                    WText(
                      isDark ? 'Switch to Light' : 'Switch to Dark',
                      className: 'text-white',
                    ),
                  ],
                ),
              ),
              WDiv(
                className:
                    'px-3 py-1 rounded-full ${isDark ? "bg-slate-700" : "bg-amber-100"}',
                child: WText(
                  isDark ? '🌙 Dark Mode' : '☀️ Light Mode',
                  className:
                      'text-sm font-medium ${isDark ? "text-slate-300" : "text-amber-700"}',
                ),
              ),
            ],
          ),
          WDiv(
            className:
                'p-3 bg-slate-100 dark:bg-slate-700 rounded-lg font-mono text-sm',
            child: WText(
              "WindTheme.of(context).toggleTheme()",
              className: 'text-slate-700 dark:text-slate-300',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenMappingDemo(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final mappings = [
      ('primary', colorScheme.primary, 'colorScheme.primary'),
      ('secondary', colorScheme.secondary, 'colorScheme.secondary'),
      ('surface', colorScheme.surface, 'colorScheme.surface'),
      ('error', colorScheme.error, 'colorScheme.error'),
    ];

    return _buildSection(
      title: 'Token Mapping',
      description: 'Wind tokens automatically map to Flutter ColorScheme',
      child: WDiv(
        className: 'grid grid-cols-2 md:grid-cols-4 gap-4',
        children: mappings.map((entry) {
          final (name, color, mapping) = entry;
          return WDiv(
            className:
                'flex flex-col gap-2 p-3 bg-slate-50 dark:bg-slate-700/50 rounded-lg',
            children: [
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              WText(name,
                  className:
                      'font-semibold text-slate-900 dark:text-white capitalize'),
              WText(mapping,
                  className:
                      'text-xs text-slate-500 dark:text-slate-400 font-mono'),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSyncExplanation() {
    return _buildSection(
      title: 'How It Works',
      description:
          'WindTheme provides a builder pattern for reactive theme binding',
      child: WDiv(
        className: 'flex flex-col gap-4',
        children: [
          WDiv(
            className:
                'p-4 bg-slate-900 rounded-lg font-mono text-sm overflow-x-auto',
            child: WText(
              "WindTheme(\n"
              "  initialData: WindThemeData(),\n"
              "  builder: (context, controller) {\n"
              "    return MaterialApp(\n"
              "      // Reactive binding - rebuilds on theme change\n"
              "      theme: controller.toThemeData(),\n"
              "      darkTheme: controller.toThemeData(dark: true),\n"
              "      themeMode: controller.themeMode,\n"
              "      home: MyApp(),\n"
              "    );\n"
              "  },\n"
              ")",
              className: 'text-green-400',
            ),
          ),
          WDiv(
            className: 'flex flex-col gap-3',
            children: [
              _buildFeatureItem(
                icon: '🔄',
                title: 'Reactive Updates',
                description:
                    'Theme changes automatically propagate to MaterialApp',
              ),
              _buildFeatureItem(
                icon: '🎨',
                title: 'Unified Tokens',
                description:
                    'Wind colors (bg-primary) match Material colors (colorScheme.primary)',
              ),
              _buildFeatureItem(
                icon: '🌓',
                title: 'Dark Mode Sync',
                description: 'dark: prefix aligns with MaterialApp darkTheme',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required String icon,
    required String title,
    required String description,
  }) {
    return WDiv(
      className:
          'flex items-start gap-3 p-3 bg-slate-50 dark:bg-slate-700/50 rounded-lg',
      children: [
        WText(icon, className: 'text-xl'),
        WDiv(
          className: 'flex flex-col',
          children: [
            WText(title,
                className: 'font-medium text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-600 dark:text-slate-400'),
          ],
        ),
      ],
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
