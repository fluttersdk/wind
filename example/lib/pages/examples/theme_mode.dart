import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ThemeModeExamplePage extends StatelessWidget {
  const ThemeModeExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          "w-full h-full flex items-center justify-center p-4 transition-colors duration-300 overflow-y-auto",
      child: WDiv(
        className:
            "w-full max-w-sm bg-white dark:bg-slate-800 rounded-2xl p-6 shadow-xl transition-all duration-300",
        children: [
          // Header
          WDiv(
            className: "flex items-center justify-between mb-6",
            children: [
              WText(
                "Appearance",
                className: "text-xl font-bold text-gray-900 dark:text-white",
              ),
              WDiv(
                className:
                    "w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center",
                child: WIcon(
                  Icons.brightness_6,
                  className: "text-blue-600 dark:text-blue-400",
                ),
              ),
            ],
          ),

          // Description
          WText(
            "Choose how Wind UI looks on your device.",
            className: "text-gray-500 dark:text-gray-400 mb-8",
          ),

          // Theme Options
          WDiv(
            className: "flex flex-col gap-3",
            children: [
              _buildOption(
                context,
                icon: Icons.light_mode,
                label: "Light Mode",
                isActive: !context.windIsDark,
                onTap: () => context.windTheme
                    .setTheme(WindThemeData(brightness: Brightness.light)),
              ),
              _buildOption(
                context,
                icon: Icons.dark_mode,
                label: "Dark Mode",
                isActive: context.windIsDark,
                onTap: () => context.windTheme
                    .setTheme(WindThemeData(brightness: Brightness.dark)),
              ),
            ],
          ),

          // Info Box
          WDiv(
            className: "mt-8 p-4 rounded-xl bg-slate-50 dark:bg-slate-700/50",
            child: WDiv(
              className: "flex gap-3",
              children: [
                WIcon(
                  Icons.info_outline,
                  className: "text-slate-400 dark:text-slate-300 mt-0.5",
                ),
                WText(
                  "Wind automatically detects your system preference by default.",
                  className: "text-sm text-slate-600 dark:text-slate-300 flex-1",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final activeClass = isActive
        ? "bg-blue-50 border-blue-500 dark:bg-blue-900/20 dark:border-blue-400"
        : "bg-white border-gray-200 hover:border-gray-300 dark:bg-slate-800 dark:border-slate-700 dark:hover:border-slate-600";

    final iconClass = isActive
        ? "text-blue-600 dark:text-blue-400"
        : "text-gray-400 dark:text-slate-500";

    final textClass = isActive
        ? "text-blue-900 dark:text-blue-100 font-semibold"
        : "text-gray-700 dark:text-slate-300 font-medium";

    return WAnchor(
      onTap: onTap,
      child: WDiv(
        className:
            "flex items-center gap-4 p-4 rounded-xl border-2 transition-all duration-200 $activeClass",
        children: [
          WIcon(icon, className: iconClass),
          WText(label, className: textClass),
          if (isActive)
            WDiv(
              className: "ml-auto",
              child: WIcon(
                Icons.check_circle,
                className: "text-blue-500 dark:text-blue-400",
              ),
            ),
        ],
      ),
    );
  }
}
