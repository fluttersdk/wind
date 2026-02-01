import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Implicit Animation Example Page - demonstrates duration-* and ease-* classes.
class AnimationImplicitExamplePage extends StatefulWidget {
  const AnimationImplicitExamplePage({super.key});

  @override
  State<AnimationImplicitExamplePage> createState() =>
      _AnimationImplicitExamplePageState();
}

class _AnimationImplicitExamplePageState
    extends State<AnimationImplicitExamplePage> {
  bool _isExpanded = false;
  bool _isVisible = true;
  bool _isToggled = false;

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          // Header
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-cyan-500 to-blue-500
            ''',
            children: const [
              WText('Transitions', className: 'text-lg font-bold text-white'),
              WText(
                'Implicit animation utilities',
                className: 'text-sm text-cyan-100',
              ),
            ],
          ),

          // Duration with hover
          _buildSection(
            title: 'duration-{ms} + hover',
            description: 'Smooth color transitions on hover',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: const [
                  _HoverBox(duration: '150'),
                  _HoverBox(duration: '300'),
                  _HoverBox(duration: '500'),
                ],
              ),
            ],
          ),

          // Size transition
          _buildSection(
            title: 'State-based sizing',
            description: 'Tap to animate size changes',
            children: [
              WDiv(
                className: 'flex gap-4 items-center',
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: WDiv(
                      states: {if (_isExpanded) 'expanded'},
                      className: '''
                        rounded-lg bg-purple-500 duration-500 ease-in-out
                        flex items-center justify-center
                        h-16 w-16 expanded:h-24 expanded:w-24
                      ''',
                      children: const [
                        WText('Tap', className: 'text-white text-sm'),
                      ],
                    ),
                  ),
                  WText(
                    _isExpanded ? 'Expanded' : 'Collapsed',
                    className: 'text-sm text-gray-500',
                  ),
                ],
              ),
            ],
          ),

          // Opacity transition
          _buildSection(
            title: 'Opacity transition',
            description: 'Toggle visibility with fade',
            children: [
              WDiv(
                className: 'flex gap-4 items-center',
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => _isVisible = !_isVisible),
                    child: Text(_isVisible ? 'Hide' : 'Show'),
                  ),
                  WDiv(
                    states: {if (_isVisible) 'visible'},
                    className: '''
                      w-16 h-16 rounded-lg bg-red-500 duration-500
                      flex items-center justify-center
                      opacity-0 visible:opacity-100
                    ''',
                    children: const [
                      WText('Fade', className: 'text-white text-sm'),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Toggle switch
          _buildSection(
            title: 'Toggle with ease-in-out',
            description: 'Smooth easing curve',
            children: [
              WDiv(
                className: 'flex gap-4 items-center',
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isToggled = !_isToggled),
                    child: WDiv(
                      states: {if (_isToggled) 'toggled'},
                      className: '''
                        w-12 h-6 rounded-full p-1 duration-200 ease-in-out
                        bg-gray-300 toggled:bg-blue-500
                      ''',
                      children: [
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          alignment: _isToggled
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: const WDiv(
                            className:
                                'w-4 h-4 rounded-full bg-white shadow-sm',
                          ),
                        ),
                      ],
                    ),
                  ),
                  WText(
                    _isToggled ? 'ON' : 'OFF',
                    className: 'text-sm text-gray-600',
                  ),
                ],
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'Quick Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: const [
                  WText(
                    'duration-75 | 100 | 150 | 200 | 300 | 500 | 700 | 1000',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                  WText(
                    'duration-[Xms] (arbitrary)',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                  WText(
                    'ease-linear | ease-in | ease-out | ease-in-out',
                    className:
                        'text-xs font-mono text-gray-600 dark:text-gray-400',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
          className: 'font-semibold text-gray-800 dark:text-white font-mono',
        ),
        WText(
          description,
          className: 'text-sm text-gray-500 dark:text-gray-400',
        ),
        ...children,
      ],
    );
  }
}

class _HoverBox extends StatelessWidget {
  final String duration;

  const _HoverBox({required this.duration});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WAnchor(
          child: WDiv(
            className:
                '''
              w-16 h-16 rounded-lg duration-$duration
              bg-gray-300 hover:bg-blue-500
              flex items-center justify-center
            ''',
            children: [
              WText('${duration}ms', className: 'text-xs text-gray-600'),
            ],
          ),
        ),
        WText(
          'duration-$duration',
          className: 'text-xs text-gray-500 dark:text-gray-400 font-mono',
        ),
      ],
    );
  }
}
