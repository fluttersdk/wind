import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Background Colors Example
/// Demonstrates background color utilities: bg-{color}-{shade}, opacity, arbitrary
class BackgroundColorsPage extends StatelessWidget {
  const BackgroundColorsPage({super.key});

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
              bg-gradient-to-r from-emerald-500 to-teal-500
            ''',
            children: [
              WText(
                'Background Color',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Control background with bg-{color}-{shade}',
                className: 'text-sm text-emerald-100',
              ),
            ],
          ),

          // Basic Colors
          _buildSection(
            title: 'Basic Colors',
            description: 'Common background colors',
            children: [
              WDiv(
                className: 'flex wrap gap-3 overflow-x-auto',
                children: [
                  _buildColorBox('bg-red-500', 'Red'),
                  _buildColorBox('bg-blue-500', 'Blue'),
                  _buildColorBox('bg-green-500', 'Green'),
                  _buildColorBox('bg-yellow-500', 'Yellow', dark: true),
                  _buildColorBox('bg-purple-500', 'Purple'),
                  _buildColorBox('bg-pink-500', 'Pink'),
                ],
              ),
            ],
          ),

          // Color Shades
          _buildSection(
            title: 'Color Shades',
            description: 'From 50 (light) to 900 (dark)',
            children: [
              WDiv(
                className: 'flex wrap gap-2',
                children: [
                  _buildShadeBox('bg-blue-50', '50', dark: true),
                  _buildShadeBox('bg-blue-100', '100', dark: true),
                  _buildShadeBox('bg-blue-200', '200', dark: true),
                  _buildShadeBox('bg-blue-300', '300', dark: true),
                  _buildShadeBox('bg-blue-400', '400'),
                  _buildShadeBox('bg-blue-500', '500'),
                  _buildShadeBox('bg-blue-600', '600'),
                  _buildShadeBox('bg-blue-700', '700'),
                  _buildShadeBox('bg-blue-800', '800'),
                  _buildShadeBox('bg-blue-900', '900'),
                ],
              ),
            ],
          ),

          // Opacity
          _buildSection(
            title: 'Background Opacity',
            description: 'Control transparency with /opacity',
            children: [
              WDiv(
                className: 'p-4 bg-gray-200 dark:bg-slate-700 rounded-lg',
                child: WDiv(
                  className: 'flex wrap gap-3 overflow-x-auto',
                  children: [
                    _buildOpacityBox('bg-red-500', '100%'),
                    _buildOpacityBox('bg-red-500/75', '75%'),
                    _buildOpacityBox('bg-red-500/50', '50%'),
                    _buildOpacityBox('bg-red-500/25', '25%'),
                    _buildOpacityBox('bg-red-500/10', '10%'),
                  ],
                ),
              ),
            ],
          ),

          // Arbitrary Values
          _buildSection(
            title: 'Arbitrary Values',
            description: 'Custom hex colors with bracket notation',
            children: [
              WDiv(
                className: 'flex wrap gap-3 overflow-x-auto',
                children: [
                  _buildColorBox('bg-[#1da1f2]', 'Twitter'),
                  _buildColorBox('bg-[#FF5733]', 'Custom'),
                  _buildColorBox('bg-[#6B5B95]', 'Purple'),
                ],
              ),
            ],
          ),

          // Special Values
          _buildSection(
            title: 'Special Values',
            description: 'Common background values',
            children: [
              WDiv(
                className: 'flex wrap gap-3 overflow-x-auto',
                children: [
                  WDiv(
                    className: 'bg-white p-4 rounded-lg border border-gray-300',
                    child: WText(
                      'bg-white',
                      className: 'text-gray-800 font-mono text-sm',
                    ),
                  ),
                  WDiv(
                    className: 'bg-black p-4 rounded-lg',
                    child: WText(
                      'bg-black',
                      className: 'text-white font-mono text-sm',
                    ),
                  ),
                  WDiv(
                    className:
                        'bg-transparent p-4 rounded-lg border border-dashed border-gray-400',
                    child: WText(
                      'bg-transparent',
                      className: 'text-gray-600 font-mono text-sm',
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              WText(
                'Quick Reference',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _buildRefRow('bg-{color}-{shade}', 'e.g. bg-red-500'),
                  _buildRefRow('bg-{color}/opacity', 'e.g. bg-red-500/50'),
                  _buildRefRow('bg-[#hex]', 'Arbitrary color'),
                  _buildRefRow('bg-transparent', 'Transparent'),
                  _buildRefRow('bg-white', 'White'),
                  _buildRefRow('bg-black', 'Black'),
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

  Widget _buildColorBox(String className, String label, {bool dark = false}) {
    return WDiv(
      className: '$className p-4 rounded-lg',
      child: WText(
        label,
        className: 'font-mono text-sm ${dark ? "text-gray-800" : "text-white"}',
      ),
    );
  }

  Widget _buildShadeBox(String className, String label, {bool dark = false}) {
    return WDiv(
      className: '$className p-3 rounded',
      child: WText(
        label,
        className: 'font-mono text-xs ${dark ? "text-gray-800" : "text-white"}',
      ),
    );
  }

  Widget _buildOpacityBox(String className, String label) {
    return WDiv(
      className: '$className p-4 rounded-lg',
      child: WText(label, className: 'font-mono text-sm text-white'),
    );
  }

  Widget _buildRefRow(String className, String description) {
    return WDiv(
      className: 'flex gap-4',
      children: [
        WText(
          className,
          className:
              'font-mono text-sm text-indigo-600 dark:text-indigo-400 w-40',
        ),
        WText(
          description,
          className: 'text-sm text-gray-600 dark:text-gray-300',
        ),
      ],
    );
  }
}
