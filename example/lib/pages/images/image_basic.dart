import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Basic WImage example showing image styling with utility classes.
class ImageBasicExamplePage extends StatelessWidget {
  const ImageBasicExamplePage({super.key});

  // Sample image URLs
  static const _sampleImage1 =
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400';
  static const _sampleImage2 =
      'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400';
  static const _sampleImage3 =
      'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=400';

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'p-6 bg-gray-100 h-full w-screen',
      children: [
        // Basic image with sizing
        const WText(
          'Basic Image with Sizing',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-6',
          children: const [
            WImage(
              src: _sampleImage1,
              alt: 'Mountain landscape',
              className: 'w-24 h-24 rounded-lg object-cover',
            ),
            WImage(
              src: _sampleImage2,
              alt: 'Forest',
              className: 'w-24 h-24 rounded-full object-cover',
            ),
            WImage(
              src: _sampleImage3,
              alt: 'Lake',
              className: 'w-24 h-24 rounded object-cover',
            ),
          ],
        ),

        // Object Fit variations
        const WText(
          'Object Fit (object-*)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-6',
          children: [
            WDiv(
              className: 'flex-col items-center',
              children: const [
                WImage(
                  src: _sampleImage1,
                  className: 'w-20 h-20 rounded bg-gray-200 object-cover',
                ),
                WText('cover', className: 'text-xs text-gray-500 mt-1'),
              ],
            ),
            WDiv(
              className: 'flex-col items-center',
              children: const [
                WImage(
                  src: _sampleImage1,
                  className: 'w-20 h-20 rounded bg-gray-200 object-contain',
                ),
                WText('contain', className: 'text-xs text-gray-500 mt-1'),
              ],
            ),
            WDiv(
              className: 'flex-col items-center',
              children: const [
                WImage(
                  src: _sampleImage1,
                  className: 'w-20 h-20 rounded bg-gray-200 object-fill',
                ),
                WText('fill', className: 'text-xs text-gray-500 mt-1'),
              ],
            ),
          ],
        ),

        // Aspect Ratio
        const WText(
          'Aspect Ratio (aspect-*)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4 mb-6',
          children: [
            WDiv(
              className: 'flex-col items-center',
              children: const [
                WImage(
                  src: _sampleImage2,
                  className: 'w-24 aspect-square rounded object-cover',
                ),
                WText('square', className: 'text-xs text-gray-500 mt-1'),
              ],
            ),
            WDiv(
              className: 'flex-col items-center',
              children: const [
                WImage(
                  src: _sampleImage2,
                  className: 'w-32 aspect-video rounded object-cover',
                ),
                WText('video', className: 'text-xs text-gray-500 mt-1'),
              ],
            ),
          ],
        ),

        // With placeholder
        const WText(
          'With Placeholder',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WDiv(
          className: 'flex gap-4',
          children: [
            WImage(
              src: _sampleImage3,
              className: 'w-24 h-24 rounded-lg object-cover',
              placeholder: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
