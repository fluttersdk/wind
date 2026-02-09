import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WFormInputLayoutExamplePage extends StatelessWidget {
  const WFormInputLayoutExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Vertical Layout (Default)',
            description: 'Standard stack: Label → Input → Error/Hint.',
            child: WFormInput(
              label: 'Full Name',
              labelClassName:
                  'text-sm font-medium text-slate-700 dark:text-white mb-1',
              hint: 'Your legal name as it appears on ID',
              placeholder: 'Jane Doe',
              className:
                  'w-full px-3 py-2 bg-white dark:bg-slate-900 border border-slate-300 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-blue-500',
            ),
          ),
          _buildSection(
            title: 'Horizontal Layout (Custom)',
            description:
                'Using WDiv flex row to place label beside input. WFormInput label is omitted.',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                _buildHorizontalInput('Username', 'jdoe123'),
                _buildHorizontalInput('Website', 'https://'),
              ],
            ),
          ),
          _buildSection(
            title: 'Grid Layout',
            description: 'Multiple inputs in a responsive grid.',
            child: WDiv(
              className: 'grid grid-cols-1 md:grid-cols-2 gap-4',
              children: [
                WFormInput(
                  label: 'First Name',
                  labelClassName:
                      'text-sm font-medium text-slate-700 dark:text-white mb-1',
                  className:
                      'w-full px-3 py-2 bg-white dark:bg-slate-900 border border-slate-300 dark:border-slate-700 rounded-lg',
                ),
                WFormInput(
                  label: 'Last Name',
                  labelClassName:
                      'text-sm font-medium text-slate-700 dark:text-white mb-1',
                  className:
                      'w-full px-3 py-2 bg-white dark:bg-slate-900 border border-slate-300 dark:border-slate-700 rounded-lg',
                ),
                WDiv(
                  className: 'col-span-1 md:col-span-2',
                  child: WFormInput(
                    label: 'Address',
                    labelClassName:
                        'text-sm font-medium text-slate-700 dark:text-white mb-1',
                    className:
                        'w-full px-3 py-2 bg-white dark:bg-slate-900 border border-slate-300 dark:border-slate-700 rounded-lg',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalInput(String label, String placeholder) {
    return WDiv(
      className: 'flex flex-col md:flex-row md:items-center gap-2 md:gap-4',
      children: [
        WDiv(
          className: 'w-full md:w-1/4',
          child: WText(
            label,
            className: 'text-sm font-medium text-slate-700 dark:text-slate-300',
          ),
        ),
        WDiv(
          className: 'w-full md:w-3/4',
          child: WFormInput(
            // No built-in label
            placeholder: placeholder,
            className:
                'w-full px-3 py-2 bg-white dark:bg-slate-900 border border-slate-300 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-blue-500',
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-teal-500 to-emerald-600 rounded-xl p-6 shadow-lg',
      child: WText(
        'Input Layouts',
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
          'flex flex-col gap-4 p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className:
                    'text-lg font-semibold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-600 dark:text-slate-400'),
          ],
        ),
        const WSpacer(className: 'h-4'),
        child,
      ],
    );
  }
}
