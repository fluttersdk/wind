import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Borders Preview Example Page - comprehensive border utilities demo.
class BordersPreviewExamplePage extends StatelessWidget {
  const BordersPreviewExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildWidthSection(),
          _buildColorSection(),
          _buildRadiusSection(),
          _buildStyleSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-indigo-500 to-purple-600 rounded-xl p-6',
      children: const [
        WText('Borders Preview', className: 'text-2xl font-bold text-white'),
        WText(
          'Width, color, radius, and style utilities',
          className: 'text-indigo-100 mt-2',
        ),
      ],
    );
  }

  Widget _buildWidthSection() {
    return _buildSection(
      title: 'Border Width',
      description: 'Control border thickness with border-{width}',
      child: WDiv(
        className: 'flex gap-4 wrap',
        children: [
          _buildBox('border', 'border'),
          _buildBox('border-2', 'border-2'),
          _buildBox('border-4', 'border-4'),
          _buildBox('border-8', 'border-8'),
        ],
      ),
    );
  }

  Widget _buildColorSection() {
    return _buildSection(
      title: 'Border Color',
      description: 'Set border colors with border-{color}-{shade}',
      child: WDiv(
        className: 'flex gap-4 wrap',
        children: [
          _buildBox('border-2 border-red-500', 'red-500'),
          _buildBox('border-2 border-blue-500', 'blue-500'),
          _buildBox('border-2 border-green-500', 'green-500'),
          _buildBox('border-2 border-purple-500', 'purple-500'),
        ],
      ),
    );
  }

  Widget _buildRadiusSection() {
    return _buildSection(
      title: 'Border Radius',
      description: 'Round corners with rounded-{size}',
      child: WDiv(
        className: 'flex gap-4 wrap',
        children: [
          _buildBox('border-2 border-slate-400 rounded-none', 'none'),
          _buildBox('border-2 border-slate-400 rounded', 'rounded'),
          _buildBox('border-2 border-slate-400 rounded-lg', 'lg'),
          _buildBox('border-2 border-slate-400 rounded-xl', 'xl'),
          _buildBox('border-2 border-slate-400 rounded-full', 'full'),
        ],
      ),
    );
  }

  Widget _buildStyleSection() {
    return _buildSection(
      title: 'Border Style',
      description: 'Change border style with border-{style}',
      child: WDiv(
        className: 'flex gap-4 wrap',
        children: [
          _buildBox('border-2 border-slate-400 border-solid', 'solid'),
          _buildBox('border-2 border-slate-400 border-dashed', 'dashed'),
          _buildBox('border-2 border-slate-400 border-dotted', 'dotted'),
        ],
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
          'flex flex-col gap-4 p-4 bg-white dark:bg-slate-800 rounded-lg',
      children: [
        WText(title,
            className: 'text-lg font-semibold text-slate-900 dark:text-white'),
        WText(description,
            className: 'text-sm text-slate-600 dark:text-slate-400'),
        child,
      ],
    );
  }

  Widget _buildBox(String className, String label) {
    return WDiv(
      className: 'flex flex-col items-center gap-2',
      children: [
        WDiv(
          className: 'w-16 h-16 bg-slate-100 dark:bg-slate-700 $className',
        ),
        WText(label,
            className: 'text-xs text-slate-500 dark:text-slate-400 font-mono'),
      ],
    );
  }
}
