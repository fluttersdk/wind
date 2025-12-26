import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Example showing implicit animations with duration-* classes.
class AnimationImplicitExamplePage extends StatefulWidget {
  const AnimationImplicitExamplePage({super.key});

  @override
  State<AnimationImplicitExamplePage> createState() =>
      _AnimationImplicitExamplePageState();
}

class _AnimationImplicitExamplePageState
    extends State<AnimationImplicitExamplePage> {
  bool _isHovered1 = false;
  bool _isExpanded = false;
  bool _isVisible = true;
  bool _isToggled = false;
  double _size = 64;

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'p-6 bg-gray-100 h-full w-screen',
      children: [
        // Hover color transition
        const WText(
          'Hover with duration-300 (AnimatedContainer)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-8',
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => _isHovered1 = true),
              onExit: (_) => setState(() => _isHovered1 = false),
              child: WDiv(
                className:
                    'w-20 h-20 rounded-lg flex items-center justify-center duration-300 ${_isHovered1 ? 'bg-blue-500' : 'bg-gray-300'}',
                children: [
                  WText(
                    'Hover',
                    className: _isHovered1 ? 'text-white' : 'text-gray-600',
                  ),
                ],
              ),
            ),
            WAnchor(
              child: WDiv(
                className:
                    'w-20 h-20 rounded-lg flex items-center justify-center duration-300 bg-gray-300 hover:bg-green-500',
                children: const [WText('WAnchor', className: 'text-sm')],
              ),
            ),
          ],
        ),

        // Size transition
        const WText(
          'Click to resize (AnimatedContainer)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-8 items-end',
          children: [
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: WDiv(
                states: {if (_isExpanded) 'expanded'},
                className:
                    'rounded-lg flex bg-purple-500 items-center justify-center duration-500 h-16 w-16 expanded:h-32 expanded:w-32',
                children: const [WText('Tap', className: 'text-white text-sm')],
              ),
            ),
            Column(
              children: [
                Slider(
                  value: _size,
                  min: 32,
                  max: 128,
                  onChanged: (val) => setState(() => _size = val),
                ),
                WDiv(
                  className: 'rounded bg-orange-500 duration-300',
                  style: WindStyle(
                    width: _size,
                    height: _size,
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Opacity transition
        const WText(
          'Toggle opacity (AnimatedOpacity)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-8 items-center',
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _isVisible = !_isVisible),
              child: Text(_isVisible ? 'Hide' : 'Show'),
            ),
            WDiv(
              states: {if (_isVisible) 'visible'},
              className:
                  'w-20 h-20 flex rounded-lg bg-red-500 items-center justify-center duration-500 opacity-0 visible:opacity-100',
              children: const [WText('Fade', className: 'text-white')],
            ),
          ],
        ),

        // Animated Alignment (Toggle Switch)
        const WText(
          'Animated Alignment (Toggle Switch)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 items-center mb-8',
          children: [
            GestureDetector(
              onTap: () => setState(() => _isToggled = !_isToggled),
              child: WDiv(
                states: {if (_isToggled) 'toggled'},
                className:
                    'w-12 h-6 rounded-full p-1 duration-200 ease-in-out bg-gray-300 toggled:bg-blue-500',
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    alignment: _isToggled
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: const WDiv(
                      className: 'w-4 h-4 rounded-full bg-white shadow-sm',
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
    );
  }
}
