import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Positioning Example
/// Demonstrates CSS-inspired positioning utilities: relative, absolute, inset, offsets
class PositioningExamplePage extends StatefulWidget {
  const PositioningExamplePage({super.key});

  @override
  State<PositioningExamplePage> createState() => _PositioningExamplePageState();
}

class _PositioningExamplePageState extends State<PositioningExamplePage> {
  bool _showOverlay = false;

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          _buildHeader(),
          _buildBadgeOverlay(),
          _buildFabPositioning(),
          _buildFullOverlay(),
          _buildCardWithLabel(),
          _buildFlexWithPositioned(),
          _buildInteractiveDemo(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: '''
        w-full p-4 rounded-xl
        bg-gradient-to-r from-violet-600 to-purple-700
      ''',
      children: [
        WText(
          'CSS Positioning',
          className: 'text-lg font-bold text-white',
        ),
        WText(
          'Use relative and absolute to layer and overlap elements',
          className: 'text-sm text-violet-200',
        ),
      ],
    );
  }

  Widget _buildBadgeOverlay() {
    return _buildSection(
      title: 'Badge Overlay',
      description:
          'relative parent + absolute top-0 right-0 child pins a badge to the corner',
      children: [
        WDiv(
          className: 'flex gap-6 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
          children: [
            // Notification bell with badge
            WDiv(
              className: 'relative w-12 h-12',
              children: [
                WDiv(
                  className:
                      'w-12 h-12 bg-blue-500 rounded-xl flex items-center justify-center',
                  child: WIcon(Icons.notifications_outlined),
                ),
                WDiv(
                  className:
                      'absolute top-0 right-0 w-5 h-5 bg-red-500 rounded-full flex items-center justify-center',
                  child: WText('3', className: 'text-white text-xs font-bold'),
                ),
              ],
            ),
            // Shopping cart with badge
            WDiv(
              className: 'relative w-12 h-12',
              children: [
                WDiv(
                  className:
                      'w-12 h-12 bg-green-500 rounded-xl flex items-center justify-center',
                  child: WIcon(Icons.shopping_cart_outlined),
                ),
                WDiv(
                  className:
                      'absolute top-0 right-0 w-5 h-5 bg-orange-500 rounded-full flex items-center justify-center',
                  child: WText('12', className: 'text-white text-xs font-bold'),
                ),
              ],
            ),
            // Message icon with dot
            WDiv(
              className: 'relative w-12 h-12',
              children: [
                WDiv(
                  className:
                      'w-12 h-12 bg-indigo-500 rounded-xl flex items-center justify-center',
                  child: WIcon(Icons.chat_bubble_outlined),
                ),
                WDiv(
                  className:
                      'absolute top-1 right-1 w-3 h-3 bg-green-400 rounded-full',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFabPositioning() {
    return _buildSection(
      title: 'FAB Positioning',
      description:
          'absolute bottom-4 right-4 pins a floating action button to the container corner',
      children: [
        WDiv(
          className:
              'relative h-40 bg-gray-100 dark:bg-slate-800 rounded-lg overflow-hidden',
          children: [
            WDiv(
              className: 'p-4',
              child: WText(
                'Container content — the FAB floats above it',
                className: 'text-sm text-gray-600 dark:text-gray-400',
              ),
            ),
            WDiv(
              className: 'absolute bottom-4 right-4',
              child: WDiv(
                className:
                    'w-12 h-12 bg-violet-600 rounded-full shadow-lg flex items-center justify-center',
                child: WIcon(Icons.add, className: 'text-white'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFullOverlay() {
    return _buildSection(
      title: 'Full Overlay',
      description:
          'absolute inset-0 stretches a child to cover the entire parent',
      children: [
        WDiv(
          className: 'relative h-36 bg-blue-500 rounded-lg overflow-hidden',
          children: [
            WDiv(
              className: 'p-4 flex flex-col gap-1',
              children: [
                WText(
                  'Sarah Johnson',
                  className: 'text-white font-bold text-base',
                ),
                WText(
                  'Senior Product Designer',
                  className: 'text-blue-200 text-sm',
                ),
                WText(
                  'San Francisco, CA',
                  className: 'text-blue-200 text-sm',
                ),
              ],
            ),
            // Semi-transparent overlay
            WDiv(
              className:
                  'absolute inset-0 bg-black opacity-40 flex items-center justify-center',
              child: WText(
                'absolute inset-0',
                className: 'text-white font-mono text-sm font-bold',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardWithLabel() {
    return _buildSection(
      title: 'Card with Positioned Label',
      description:
          'Use negative offsets like -top-3 to overlap an element across a card border',
      children: [
        WDiv(
          className:
              'relative p-4 pt-6 bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl shadow-sm',
          children: [
            WDiv(
              className:
                  'absolute -top-3 left-4 px-3 py-1 bg-violet-600 rounded-full',
              child: WText(
                'Featured',
                className: 'text-white text-xs font-semibold',
              ),
            ),
            WText(
              'Wind UI Framework',
              className:
                  'text-base font-bold text-gray-900 dark:text-white mb-1',
            ),
            WText(
              'Utility-first styling for Flutter. Build fast, expressive UIs with familiar Tailwind syntax.',
              className: 'text-sm text-gray-600 dark:text-gray-400',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFlexWithPositioned() {
    return _buildSection(
      title: 'Flex + Positioning',
      description:
          'relative flex flex-row — normal children participate in flex layout while absolute children float above',
      children: [
        WDiv(
          className:
              'relative flex flex-row gap-3 p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
          children: [
            WDiv(
              className:
                  'flex-1 h-16 bg-blue-400 rounded-lg flex items-center justify-center',
              child: WText('flex item 1', className: 'text-white text-sm'),
            ),
            WDiv(
              className:
                  'flex-1 h-16 bg-blue-400 rounded-lg flex items-center justify-center',
              child: WText('flex item 2', className: 'text-white text-sm'),
            ),
            WDiv(
              className:
                  'flex-1 h-16 bg-blue-400 rounded-lg flex items-center justify-center',
              child: WText('flex item 3', className: 'text-white text-sm'),
            ),
            // Floating badge over the flex container
            WDiv(
              className:
                  'absolute top-2 right-2 px-2 py-1 bg-amber-400 rounded-full',
              child: WText(
                'NEW',
                className: 'text-amber-900 text-xs font-bold',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractiveDemo() {
    return _buildSection(
      title: 'Interactive Demo',
      description: 'Toggle an absolute overlay on and off with setState',
      children: [
        WDiv(
          className:
              'relative h-40 bg-gradient-to-br from-slate-700 to-slate-900 rounded-xl overflow-hidden',
          children: [
            WDiv(
              className: 'p-4 flex flex-col gap-2',
              children: [
                WText(
                  'Dashboard Overview',
                  className: 'text-white font-bold',
                ),
                WText(
                  'Monthly revenue: \$48,320',
                  className: 'text-slate-400 text-sm',
                ),
                WText(
                  'Active users: 1,284',
                  className: 'text-slate-400 text-sm',
                ),
              ],
            ),
            if (_showOverlay)
              WDiv(
                className:
                    'absolute inset-0 bg-black opacity-70 flex items-center justify-center',
                child: WText(
                  'Overlay active — absolute inset-0',
                  className: 'text-white font-semibold text-sm',
                ),
              ),
          ],
        ),
        WDiv(
          className: 'flex gap-3 mt-2',
          children: [
            WButton(
              onTap: () => setState(() => _showOverlay = !_showOverlay),
              className:
                  'px-4 py-2 bg-violet-600 rounded-lg flex items-center gap-2',
              child: WText(
                _showOverlay ? 'Hide Overlay' : 'Show Overlay',
                className: 'text-white text-sm font-medium',
              ),
            ),
            WDiv(
              className:
                  'px-3 py-2 bg-gray-100 dark:bg-slate-700 rounded-lg flex items-center',
              child: WText(
                _showOverlay ? 'overlay: visible' : 'overlay: hidden',
                className: 'text-xs font-mono text-gray-600 dark:text-gray-300',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required List<Widget> children,
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
          className: 'text-sm text-gray-600 dark:text-gray-400 mb-4',
        ),
        ...children,
      ],
    );
  }
}
