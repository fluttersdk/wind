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
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          // Header with gradient
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-sky-500 to-blue-500
            ''',
            children: const [
              WText('WImage', className: 'text-lg font-bold text-white'),
              WText(
                'Utility-first image component with HTML img semantics',
                className: 'text-sm text-sky-100',
              ),
            ],
          ),

          // Basic sizing
          _buildSection(
            title: 'Basic Sizing',
            description: 'Use w-{n} and h-{n} with rounded corners',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
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
            ],
          ),

          // Object Fit
          _buildSection(
            title: 'Object Fit',
            description: 'Control how the image fills its container',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: [
                  _fitExample('object-cover', 'cover'),
                  _fitExample('object-contain', 'contain'),
                  _fitExample('object-fill', 'fill'),
                ],
              ),
            ],
          ),

          // Aspect Ratio
          _buildSection(
            title: 'Aspect Ratio',
            description: 'Maintain proportions with aspect-* classes',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
                children: [
                  _aspectExample('aspect-square', 'square', 'w-24'),
                  _aspectExample('aspect-video', 'video', 'w-32'),
                  _aspectExample('aspect-[4/3]', '4:3', 'w-28'),
                ],
              ),
            ],
          ),

          // With placeholder
          _buildSection(
            title: 'Loading Placeholder',
            description: 'Show a widget while the image loads',
            children: [
              WDiv(
                className: 'flex gap-4 overflow-x-auto',
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
                children: [
                  _referenceRow('object-cover', 'BoxFit.cover (default)'),
                  _referenceRow('object-contain', 'BoxFit.contain'),
                  _referenceRow('object-fill', 'BoxFit.fill'),
                  _referenceRow('object-none', 'BoxFit.none'),
                  _referenceRow('object-scale-down', 'BoxFit.scaleDown'),
                  _referenceRow('aspect-square', '1:1 ratio'),
                  _referenceRow('aspect-video', '16:9 ratio'),
                  _referenceRow('aspect-[X/Y]', 'Custom ratio'),
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

  Widget _fitExample(String fitClass, String label) {
    return WDiv(
      className: 'flex flex-col items-center gap-1',
      children: [
        WImage(
          src: _sampleImage1,
          className:
              'w-20 h-20 rounded bg-gray-200 dark:bg-slate-700 $fitClass',
        ),
        WText(label, className: 'text-xs text-gray-500 dark:text-gray-400'),
      ],
    );
  }

  Widget _aspectExample(String aspectClass, String label, String width) {
    return WDiv(
      className: 'flex flex-col items-center gap-1',
      children: [
        WImage(
          src: _sampleImage2,
          className: '$width $aspectClass rounded object-cover',
        ),
        WText(label, className: 'text-xs text-gray-500 dark:text-gray-400'),
      ],
    );
  }

  Widget _referenceRow(String className, String value) {
    return WDiv(
      className: 'flex justify-between',
      children: [
        WText(
          className,
          className: 'text-sm font-mono text-gray-600 dark:text-gray-300',
        ),
        WText(value, className: 'text-sm text-gray-500 dark:text-gray-400'),
      ],
    );
  }
}
