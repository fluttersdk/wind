import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class BackgroundGradientBasicExamplePage extends StatelessWidget {
  const BackgroundGradientBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4 bg-white dark:bg-slate-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-8 max-w-5xl mx-auto',
        children: [
          _buildHeader(),
          _buildDirectionSection(),
          _buildColorCombos(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'flex flex-col gap-2 pb-4 border-b border-slate-200 dark:border-slate-800',
      children: [
        WText(
          'Background Image (Gradients)',
          className: 'text-3xl font-bold text-slate-900 dark:text-white',
        ),
        WText(
          'Utilities for controlling the background gradient of an element.',
          className: 'text-lg text-slate-600 dark:text-slate-400',
        ),
      ],
    );
  }

  Widget _buildDirectionSection() {
    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WText(
          'Linear Gradient Directions',
          className: 'text-lg font-semibold text-slate-900 dark:text-white',
        ),
        WDiv(
          className: 'grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4',
          children: [
            _buildGradientBox('bg-gradient-to-t', 'to top'),
            _buildGradientBox('bg-gradient-to-tr', 'to top right'),
            _buildGradientBox('bg-gradient-to-r', 'to right'),
            _buildGradientBox('bg-gradient-to-br', 'to bottom right'),
            _buildGradientBox('bg-gradient-to-b', 'to bottom'),
            _buildGradientBox('bg-gradient-to-bl', 'to bottom left'),
            _buildGradientBox('bg-gradient-to-l', 'to left'),
            _buildGradientBox('bg-gradient-to-tl', 'to top left'),
          ],
        ),
      ],
    );
  }

  Widget _buildGradientBox(String directionClass, String label) {
    return WDiv(
      className:
          '$directionClass from-cyan-500 to-blue-500 h-32 rounded-lg flex items-center justify-center p-4 shadow-sm',
      child: WDiv(
        className: 'bg-black/20 px-3 py-1 rounded backdrop-blur-sm',
        child: WText(
          label,
          className: 'text-white text-sm font-medium',
        ),
      ),
    );
  }

  Widget _buildColorCombos() {
    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WText(
          'Common Gradient Combinations',
          className: 'text-lg font-semibold text-slate-900 dark:text-white',
        ),
        WDiv(
          className: 'grid grid-cols-1 md:grid-cols-2 gap-6',
          children: [
            _buildComboCard(
              'bg-gradient-to-r from-indigo-500 to-purple-500',
              'from-indigo-500 to-purple-500',
            ),
            _buildComboCard(
              'bg-gradient-to-r from-cyan-500 to-blue-500',
              'from-cyan-500 to-blue-500',
            ),
            _buildComboCard(
              'bg-gradient-to-r from-emerald-500 to-lime-600',
              'from-emerald-500 to-lime-600',
            ),
            _buildComboCard(
              'bg-gradient-to-r from-pink-500 to-rose-500',
              'from-pink-500 to-rose-500',
            ),
            _buildComboCard(
              'bg-gradient-to-r from-amber-200 to-yellow-500',
              'from-amber-200 to-yellow-500',
            ),
            _buildComboCard(
              'bg-gradient-to-r from-slate-900 to-slate-700',
              'from-slate-900 to-slate-700',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComboCard(String className, String label) {
    return WDiv(
      className: '$className p-6 rounded-xl shadow-md',
      child: WDiv(
        className: 'flex flex-col gap-1',
        children: [
          WText(
            label,
            className: 'text-white font-mono text-sm font-semibold',
          ),
          WText(
            'bg-gradient-to-r',
            className: 'text-white/80 font-mono text-xs',
          ),
        ],
      ),
    );
  }
}
