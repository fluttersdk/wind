import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WImageRatioExamplePage extends StatelessWidget {
  const WImageRatioExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-gray-50 dark:bg-gray-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Aspect Video (16:9)',
            description: 'Standard video ratio, commonly used for media cards.',
            child: const WImage(
              src: 'https://picsum.photos/800/450',
              className:
                  'w-full aspect-video object-cover rounded-lg shadow-md',
            ),
          ),
          _buildSection(
            title: 'Aspect Square (1:1)',
            description:
                'Perfect square, commonly used for avatars and product grids.',
            child: WDiv(
              className: 'grid grid-cols-2 md:grid-cols-4 gap-4',
              children: List.generate(
                  4,
                  (i) => WImage(
                        src: 'https://picsum.photos/300/300?random=$i',
                        className:
                            'w-full aspect-square object-cover rounded-lg shadow-sm hover:opacity-90 transition-opacity',
                      )),
            ),
          ),
          _buildSection(
            title: 'Custom Ratios (with Tailwind arbitrary values)',
            description:
                'Using w-full with object-cover on different containers.',
            child: WDiv(
              className: 'flex flex-col md:flex-row gap-4',
              children: [
                // 4:3 Container
                WDiv(
                  className: 'w-full md:w-1/2 aspect-[4/3] relative',
                  child: const WImage(
                    src: 'https://picsum.photos/400/300',
                    className: 'w-full h-full object-cover rounded-lg',
                  ),
                ),
                // 3:4 Container
                WDiv(
                  className: 'w-full md:w-1/2 aspect-[3/4] relative',
                  child: const WImage(
                    src: 'https://picsum.photos/300/400',
                    className: 'w-full h-full object-cover rounded-lg',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-orange-500 to-red-600 rounded-xl p-6 shadow-lg',
      child: WText(
        'Image Aspect Ratios',
        className: 'text-2xl font-bold text-white',
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
          'flex flex-col gap-4 p-6 bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700',
      children: [
        WText(title,
            className: 'text-lg font-bold text-gray-900 dark:text-white'),
        WText(description,
            className: 'text-sm text-gray-500 dark:text-gray-400'),
        child,
      ],
    );
  }
}
