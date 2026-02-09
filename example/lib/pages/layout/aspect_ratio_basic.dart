import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class AspectRatioBasicExamplePage extends StatelessWidget {
  const AspectRatioBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-slate-50 dark:bg-slate-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-8 max-w-4xl mx-auto pb-12',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Standard Ratios',
            description: 'Common aspect ratios: square (1:1) and video (16:9).',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNativeRatioBox(
                      'aspect-square', 1.0, Colors.purple, 120),
                  const SizedBox(width: 24),
                  _buildNativeRatioBox(
                      'aspect-video', 16 / 9, Colors.blue, 200),
                ],
              ),
            ),
          ),
          _buildSection(
            title: 'Arbitrary Ratios',
            description: 'Custom aspect ratios using bracket syntax.',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNativeRatioBox(
                      'aspect-[4/3]', 4 / 3, Colors.green, 160),
                  const SizedBox(width: 24),
                  _buildNativeRatioBox(
                      'aspect-[21/9]', 21 / 9, Colors.orange, 200),
                  const SizedBox(width: 24),
                  _buildNativeRatioBox('aspect-[3/4]', 3 / 4, Colors.pink, 100),
                ],
              ),
            ),
          ),
          _buildSection(
            title: 'Same Width Comparison',
            description:
                'All boxes have the same width (120px), showing how aspect ratio affects height.',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNativeRatioBox('1:1', 1.0, Colors.purple, 120),
                  const SizedBox(width: 24),
                  _buildNativeRatioBox('16:9', 16 / 9, Colors.blue, 120),
                  const SizedBox(width: 24),
                  _buildNativeRatioBox('4:3', 4 / 3, Colors.green, 120),
                  const SizedBox(width: 24),
                  _buildNativeRatioBox('3:4', 3 / 4, Colors.pink, 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNativeRatioBox(
      String label, double ratio, Color color, double width) {
    return Column(
      children: [
        SizedBox(
          width: width,
          child: AspectRatio(
            aspectRatio: ratio,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        WText(
          '${ratio.toStringAsFixed(2)}',
          className: 'text-xs font-mono text-slate-500',
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-br from-indigo-500 to-purple-600 rounded-2xl p-8 shadow-xl',
      children: [
        WText(
          'Aspect Ratio',
          className: 'text-3xl font-extrabold text-white tracking-tight',
        ),
        WText(
          'Control the width-to-height ratio of elements.',
          className: 'text-indigo-100 mt-2 text-lg max-w-2xl',
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
      className: 'flex flex-col gap-4',
      children: [
        WDiv(
          className:
              'flex flex-col gap-1 border-b border-slate-200 dark:border-slate-800 pb-2',
          children: [
            WText(title,
                className: 'text-xl font-bold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-500 dark:text-slate-400'),
          ],
        ),
        WDiv(
          className:
              'p-6 bg-white dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700 shadow-sm',
          child: child,
        ),
      ],
    );
  }
}
