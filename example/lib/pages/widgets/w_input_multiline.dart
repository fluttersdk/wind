import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WInputMultilineExamplePage extends StatelessWidget {
  const WInputMultilineExamplePage({super.key});

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
            title: 'Basic Multiline',
            description: 'A simple textarea with minLines=3.',
            child: const WInput(
              type: InputType.multiline,
              minLines: 3,
              placeholder: 'Type your message here...',
              className:
                  'w-full p-3 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500',
              placeholderClassName: 'text-gray-400',
            ),
          ),
          _buildSection(
            title: 'Limited Height',
            description: 'Textarea with minLines=2 and maxLines=4.',
            child: const WInput(
              type: InputType.multiline,
              minLines: 2,
              maxLines: 4,
              placeholder: 'This will grow until 4 lines...',
              className:
                  'w-full p-3 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg text-gray-900 dark:text-white focus:border-purple-500',
              placeholderClassName: 'text-gray-400',
            ),
          ),
          _buildSection(
            title: 'Unbounded Height',
            description: 'Textarea that grows indefinitely (maxLines=null).',
            child: const WInput(
              type: InputType.multiline,
              minLines: 1,
              maxLines: null,
              placeholder: 'Keep typing...',
              className:
                  'w-full p-3 bg-white dark:bg-gray-800 border-b-2 border-gray-300 dark:border-gray-700 focus:border-blue-600 text-gray-900 dark:text-white',
              placeholderClassName: 'text-gray-400 italic',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-blue-500 to-indigo-600 rounded-xl p-6 shadow-lg',
      child: WText(
        'Multiline Inputs',
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
