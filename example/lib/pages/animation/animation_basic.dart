import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Animation example showing animate-spin, animate-pulse, animate-bounce.
class AnimationBasicExamplePage extends StatelessWidget {
  const AnimationBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'p-6 bg-gray-100 h-full w-screen',
      children: [
        // Spin animation
        const WText(
          'animate-spin (Loading Spinner)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex items-center gap-6 mb-8',
          children: [
            // Using built-in spinner with WDiv animation
            WDiv(
              className: 'animate-spin',
              child: WDiv(
                className: 'w-8 h-8 border-4 border-blue-500 rounded-full',
                child: WText('-', className: 'text-2xl text-blue-500'),
              ),
            ),
            // Simple spinning box
            const WDiv(className: 'w-8 h-8 bg-purple-500 rounded animate-spin'),
            // Spinning icon
            const WIcon(
              Icons.refresh,
              className: 'text-green-500 text-3xl animate-spin',
            ),
            // Flutter CircularProgressIndicator spinning
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ],
        ),

        // Pulse animation
        const WText(
          'animate-pulse (Skeleton Loader)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-2 mb-8 items-start',
          children: [
            const WDiv(
              className: 'w-12 h-12 bg-gray-300 rounded-full animate-pulse',
            ),
            WDiv(
              className: 'flex flex-col mt-1 gap-2',
              children: const [
                WDiv(className: 'h-4 bg-gray-300 rounded animate-pulse w-48'),
                WDiv(className: 'h-4 bg-gray-300 rounded animate-pulse w-32'),
              ],
            ),
          ],
        ),

        // Bounce animation
        const WText(
          'animate-bounce (Scroll Indicator)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex items-end gap-6 mb-8 h-12',
          children: const [
            WIcon(
              Icons.arrow_downward,
              className: 'text-blue-500 text-2xl animate-bounce',
            ),
            WIcon(
              Icons.keyboard_arrow_down,
              className: 'text-green-500 text-3xl animate-bounce',
            ),
            WDiv(className: 'w-6 h-6 bg-red-500 rounded animate-bounce'),
            WIcon(
              Icons.south,
              className: 'text-purple-500 text-2xl animate-bounce',
            ),
          ],
        ),

        // Ping animation
        const WText(
          'animate-ping (Notification Badge)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex items-center gap-8',
          children: [
            // Notification with ping badge
            SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: Center(
                      child: Icon(
                        Icons.notifications,
                        size: 32,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 4,
                    top: 4,
                    child: WDiv(
                      className: 'w-3 h-3 bg-red-500 rounded-full animate-ping',
                    ),
                  ),
                ],
              ),
            ),
            // Message with badge
            SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: Center(
                      child: Icon(Icons.mail, size: 32, color: Colors.grey),
                    ),
                  ),
                  const Positioned(
                    right: 4,
                    top: 4,
                    child: WDiv(
                      className:
                          'w-3 h-3 bg-blue-500 rounded-full animate-ping',
                    ),
                  ),
                ],
              ),
            ),
            // Standalone ping
            const WDiv(
              className: 'w-4 h-4 bg-green-500 rounded-full animate-ping',
            ),
          ],
        ),
      ],
    );
  }
}
