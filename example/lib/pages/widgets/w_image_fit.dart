import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WImageFitExamplePage extends StatelessWidget {
  const WImageFitExamplePage({super.key});

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
            title: 'Object Cover (Default)',
            description:
                'Image covers the container, cropping if necessary. Good for backgrounds and cards.',
            child: const WImage(
              src: 'https://picsum.photos/400/300',
              className:
                  'w-full h-48 object-cover rounded-lg bg-gray-200 dark:bg-gray-700',
            ),
          ),
          _buildSection(
            title: 'Object Contain',
            description:
                'Image scales to fit within the container without cropping. Good for logos and products.',
            child: const WImage(
              src: 'https://picsum.photos/400/300',
              className:
                  'w-full h-48 object-contain bg-gray-900 rounded-lg border border-gray-700',
            ),
          ),
          _buildSection(
            title: 'Object Fill',
            description:
                'Image stretches to fill the container. May distort aspect ratio.',
            child: const WImage(
              src: 'https://picsum.photos/400/300',
              className:
                  'w-full h-48 object-fill rounded-lg bg-gray-200 dark:bg-gray-700',
            ),
          ),
          _buildSection(
            title: 'Object None',
            description: 'Image is not resized, centered in container.',
            child: const WImage(
              src:
                  'https://picsum.photos/100/100', // Small image to show 'none' effect
              className:
                  'w-full h-48 object-none rounded-lg bg-gray-200 dark:bg-gray-700',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-emerald-500 to-teal-600 rounded-xl p-6 shadow-lg',
      child: WText(
        'Image Fit Modes',
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
