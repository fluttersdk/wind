import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ZIndexHoverExamplePage extends StatelessWidget {
  const ZIndexHoverExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          // Header
          WDiv(
            className:
                'bg-gradient-to-r from-pink-500 to-rose-600 rounded-xl p-6 shadow-lg',
            children: [
              WText('Z-Index Hover',
                  className: 'text-2xl font-bold text-white'),
              WText(
                'Interactive stacking with hover states',
                className: 'text-white/80 mt-2',
              ),
            ],
          ),

          // Description
          WDiv(
            className:
                'p-4 bg-gray-50 dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700',
            child: WText(
              'Combine z-index utilities with hover states to create pop-out effects. Hover over the items below to bring them to the front.',
              className: 'text-sm text-gray-600 dark:text-gray-300',
            ),
          ),

          // Demo 1: Avatar Stack
          _buildSection(
            title: 'Pop-out Avatars',
            description: 'Hover to bring avatar to front (z-0 -> hover:z-50)',
            child: WDiv(
              className:
                  'p-12 bg-white dark:bg-slate-900 rounded-xl border border-gray-200 dark:border-slate-800 flex justify-center',
              child: SizedBox(
                width: 300,
                height: 80,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildAvatar(0, 'bg-red-500', 'A'),
                    _buildAvatar(1, 'bg-orange-500', 'B'),
                    _buildAvatar(2, 'bg-amber-500', 'C'),
                    _buildAvatar(3, 'bg-green-500', 'D'),
                    _buildAvatar(4, 'bg-blue-500', 'E'),
                  ],
                ),
              ),
            ),
          ),

          // Demo 2: Card Deck
          _buildSection(
            title: 'Interactive Card Deck',
            description: 'Cards fan out and pop up on hover',
            child: WDiv(
              className:
                  'p-8 bg-gray-100 dark:bg-slate-800 rounded-xl border border-gray-200 dark:border-slate-700',
              child: SizedBox(
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildCard(
                        0, 'bg-slate-50 dark:bg-slate-700', -10, 'Card 1'),
                    _buildCard(
                        1, 'bg-slate-100 dark:bg-slate-600', -5, 'Card 2'),
                    _buildCard(
                        2, 'bg-slate-200 dark:bg-slate-500', 0, 'Card 3'),
                    _buildCard(
                        3, 'bg-slate-300 dark:bg-slate-400', 5, 'Card 4'),
                    _buildCard(
                        4, 'bg-slate-400 dark:bg-slate-300', 10, 'Card 5'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(int index, String colorClass, String label) {
    return Positioned(
      left: index * 40.0,
      child: WDiv(
        className: '''
          $colorClass
          w-16 h-16 rounded-full 
          border-4 border-white dark:border-slate-900 
          flex items-center justify-center shadow-lg
          z-0 hover:z-50 
          hover:scale-125 
          transition-all duration-200 ease-out
          cursor-pointer
        ''',
        children: [
          WText(label, className: 'text-white font-bold text-xl'),
        ],
      ),
    );
  }

  Widget _buildCard(int index, String colorClass, double rotate, String label) {
    // Calculate offset for fan effect
    final double offsetX = (index - 2) * 30.0;

    return Positioned(
      left: 100 + offsetX,
      top: 50,
      child: Transform.rotate(
        angle: rotate * 3.14159 / 180,
        child: WDiv(
          className: '''
            $colorClass
            w-40 h-56 rounded-xl shadow-xl
            border border-white/20
            flex flex-col items-center justify-center
            z-0 hover:z-50 
            hover:scale-110 hover:-translate-y-4 hover:shadow-2xl
            transition-all duration-300
            cursor-pointer
          ''',
          children: [
            WText(label,
                className: 'text-lg font-bold text-slate-800 dark:text-white'),
            WText('Hover me',
                className: 'text-xs text-slate-500 dark:text-slate-200 mt-2'),
          ],
        ),
      ),
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
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className: 'text-lg font-bold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-500 dark:text-slate-400'),
          ],
        ),
        child,
      ],
    );
  }
}
