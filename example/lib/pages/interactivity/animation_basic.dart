import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class InteractivityAnimationExamplePage extends StatelessWidget {
  const InteractivityAnimationExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      children: [
        // Header
        _buildHeader(
          title: 'Animation',
          description:
              'Utilities for animating elements with CSS-like animation classes.',
        ),

        const WSpacer(className: 'h-6'),

        // Spin Animation
        _buildSection(
          title: 'Spin',
          description:
              'Use animate-spin for loading indicators. It provides a smooth, linear rotation.',
          child: WDiv(
            className: 'flex wrap gap-6 items-center',
            children: [
              // Native Flutter spinner wrapped in WDiv
              WDiv(
                className: 'flex flex-col items-center gap-2',
                children: [
                  WDiv(
                    className: 'w-8 h-8',
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                    ),
                  ),
                  WText('Spinner',
                      className: 'text-xs text-slate-500 dark:text-slate-400'),
                ],
              ),
              _buildAnimationDemo(
                className: 'animate-spin w-6 h-6 bg-purple-500 rounded',
                label: 'Rotating Box',
              ),
              WDiv(
                className: 'flex flex-col items-center gap-2',
                children: [
                  WIcon(
                    Icons.refresh,
                    className: 'animate-spin text-green-500 text-2xl',
                  ),
                  WText('Icon',
                      className: 'text-xs text-slate-500 dark:text-slate-400'),
                ],
              ),
            ],
          ),
        ),

        const WSpacer(className: 'h-6'),

        // Ping Animation
        _buildSection(
          title: 'Ping',
          description:
              'The animate-ping utility makes an element scale and fade out, like a radar ping.',
          child: WDiv(
            className: 'flex wrap gap-8 items-center',
            children: [
              // Simple ping dot
              WDiv(
                className: 'flex flex-col items-center gap-2',
                children: [
                  WDiv(
                    className: 'animate-ping w-4 h-4 rounded-full bg-red-500',
                  ),
                  WText('Ping',
                      className: 'text-xs text-slate-500 dark:text-slate-400'),
                ],
              ),
              // Green ping
              WDiv(
                className: 'flex flex-col items-center gap-2',
                children: [
                  WDiv(
                    className: 'animate-ping w-4 h-4 rounded-full bg-green-500',
                  ),
                  WText('Status',
                      className: 'text-xs text-slate-500 dark:text-slate-400'),
                ],
              ),
              // Blue ping
              WDiv(
                className: 'flex flex-col items-center gap-2',
                children: [
                  WDiv(
                    className: 'animate-ping w-6 h-6 rounded-full bg-blue-500',
                  ),
                  WText('Alert',
                      className: 'text-xs text-slate-500 dark:text-slate-400'),
                ],
              ),
            ],
          ),
        ),

        const WSpacer(className: 'h-6'),

        // Pulse Animation
        _buildSection(
          title: 'Pulse',
          description:
              'Use animate-pulse to create skeleton loading effects. It gently fades the opacity.',
          child: WDiv(
            className: 'flex flex-col gap-4',
            children: [
              // Skeleton card
              WDiv(
                className:
                    'animate-pulse flex gap-4 p-4 bg-white dark:bg-slate-800 rounded-lg',
                children: [
                  WDiv(
                      className:
                          'rounded-full bg-slate-200 dark:bg-slate-700 h-12 w-12'),
                  WDiv(
                    className: 'flex-1 flex flex-col gap-2 py-1',
                    children: [
                      WDiv(
                          className:
                              'h-2 bg-slate-200 dark:bg-slate-700 rounded w-3/4'),
                      WDiv(
                          className:
                              'h-2 bg-slate-200 dark:bg-slate-700 rounded w-1/2'),
                    ],
                  ),
                ],
              ),
              // Skeleton text lines
              WDiv(
                className: 'animate-pulse flex flex-col gap-2',
                children: [
                  WDiv(
                      className:
                          'h-2 bg-slate-200 dark:bg-slate-700 rounded w-full'),
                  WDiv(
                      className:
                          'h-2 bg-slate-200 dark:bg-slate-700 rounded w-5/6'),
                  WDiv(
                      className:
                          'h-2 bg-slate-200 dark:bg-slate-700 rounded w-4/6'),
                ],
              ),
            ],
          ),
        ),

        const WSpacer(className: 'h-6'),

        // Bounce Animation
        _buildSection(
          title: 'Bounce',
          description:
              'The animate-bounce utility is perfect for scroll indicators or attention-grabbing elements.',
          child: WDiv(
            className: 'flex wrap gap-8 items-end',
            children: [
              WDiv(
                className: 'flex flex-col items-center gap-2',
                children: [
                  WText('Scroll down',
                      className: 'text-sm text-slate-500 dark:text-slate-400'),
                  WIcon(
                    Icons.keyboard_arrow_down,
                    className: 'animate-bounce text-blue-500 text-3xl',
                  ),
                ],
              ),
              WDiv(
                className: 'flex flex-col items-center gap-2',
                children: [
                  WText('New!',
                      className: 'text-sm text-slate-500 dark:text-slate-400'),
                  WDiv(
                    className:
                        'animate-bounce bg-orange-500 text-white px-3 py-1 rounded-full text-sm font-bold',
                    child: WText('Click me'),
                  ),
                ],
              ),
            ],
          ),
        ),

        const WSpacer(className: 'h-6'),

        // Animation None - Comparison
        _buildSection(
          title: 'Removing Animation',
          description:
              'Use animate-none to remove animations. Compare: left has animate-spin, right has animate-none.',
          child: WDiv(
            className: 'flex wrap gap-8 items-center',
            children: [
              // With animation
              WDiv(
                className: 'flex flex-col items-center gap-2',
                children: [
                  WIcon(
                    Icons.refresh,
                    className: 'animate-spin text-blue-500 text-3xl',
                  ),
                  WText('animate-spin',
                      className: 'text-xs text-slate-500 font-mono'),
                ],
              ),
              // Arrow
              WIcon(
                Icons.arrow_forward,
                className: 'text-slate-400 text-xl',
              ),
              // Without animation
              WDiv(
                className: 'flex flex-col items-center gap-2',
                children: [
                  WIcon(
                    Icons.refresh,
                    className: 'animate-none text-gray-400 text-3xl',
                  ),
                  WText('animate-none',
                      className: 'text-xs text-slate-500 font-mono'),
                ],
              ),
            ],
          ),
        ),

        const WSpacer(className: 'h-8'),
      ],
    );
  }

  Widget _buildHeader({required String title, required String description}) {
    return WDiv(
      className:
          'bg-gradient-to-r from-indigo-500 to-purple-600 rounded-xl p-6',
      children: [
        WText(title, className: 'text-2xl font-bold text-white'),
        const WSpacer(className: 'h-2'),
        WText(description, className: 'text-white/80'),
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
          'flex flex-col gap-4 p-4 bg-white dark:bg-slate-800 rounded-lg shadow-sm',
      children: [
        WText(title,
            className: 'text-lg font-semibold text-slate-900 dark:text-white'),
        WText(description,
            className: 'text-sm text-slate-600 dark:text-slate-400'),
        const WSpacer(className: 'h-2'),
        child,
      ],
    );
  }

  Widget _buildAnimationDemo({
    required String className,
    required String label,
  }) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(className: className),
        WText(label, className: 'text-xs text-slate-500 dark:text-slate-400'),
      ],
    );
  }
}
