import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WFormCheckboxLayoutExamplePage extends StatefulWidget {
  const WFormCheckboxLayoutExamplePage({super.key});

  @override
  State<WFormCheckboxLayoutExamplePage> createState() =>
      _WFormCheckboxLayoutExamplePageState();
}

class _WFormCheckboxLayoutExamplePageState
    extends State<WFormCheckboxLayoutExamplePage> {
  bool _option1 = false;
  bool _option2 = false;
  bool _option3 = false;
  bool _rightSide = false;

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
            title: 'List Layout',
            description:
                'Checkboxes in a vertical list (standard settings UI).',
            child: WDiv(
              className:
                  'flex flex-col divide-y divide-slate-100 dark:divide-slate-700',
              children: [
                _buildListItem(
                  label: 'Notifications',
                  description: 'Enable push notifications',
                  value: _option1,
                  onChange: (v) => setState(() => _option1 = v),
                ),
                _buildListItem(
                  label: 'Dark Mode',
                  description: 'Use system theme preference',
                  value: _option2,
                  onChange: (v) => setState(() => _option2 = v),
                ),
                _buildListItem(
                  label: 'Sound',
                  description: 'Play sounds for interactions',
                  value: _option3,
                  onChange: (v) => setState(() => _option3 = v),
                ),
              ],
            ),
          ),
          _buildSection(
            title: 'Right-Aligned Checkbox',
            description: 'Custom layout with checkbox on the right side.',
            child: WAnchor(
              onTap: () => setState(() => _rightSide = !_rightSide),
              child: WDiv(
                className:
                    'flex items-center justify-between p-4 bg-slate-50 dark:bg-slate-900 rounded-lg border border-slate-200 dark:border-slate-700',
                children: [
                  WDiv(
                    className: 'flex flex-col',
                    children: [
                      WText('Enable Feature',
                          className:
                              'font-medium text-slate-900 dark:text-white'),
                      WText('Tap anywhere on this box to toggle',
                          className:
                              'text-sm text-slate-500 dark:text-slate-400'),
                    ],
                  ),
                  WCheckbox(
                    value: _rightSide,
                    onChanged: (v) => setState(() => _rightSide = v),
                    className:
                        'w-5 h-5 rounded border border-slate-300 checked:bg-blue-600 checked:border-blue-600',
                  ),
                ],
              ),
            ),
          ),
          _buildSection(
            title: 'Grid Layout',
            description: 'Checkboxes in a grid for dense options.',
            child: WDiv(
              className: 'grid grid-cols-2 md:grid-cols-3 gap-4',
              children: List.generate(
                6,
                (index) => WFormCheckbox(
                  value: false,
                  onChanged: (v) {},
                  labelText: 'Option ${index + 1}',
                  labelClassName:
                      'text-sm font-medium text-slate-700 dark:text-white',
                  className:
                      'w-4 h-4 rounded border border-slate-300 checked:bg-indigo-500',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required String label,
    required String description,
    required bool value,
    required ValueChanged<bool> onChange,
  }) {
    return WDiv(
      className: 'py-3',
      child: WFormCheckbox(
        value: value,
        onChanged: onChange,
        label: WDiv(
          className: 'flex flex-col',
          children: [
            WText(label,
                className:
                    'text-sm font-medium text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-xs text-slate-500 dark:text-slate-400'),
          ],
        ),
        className:
            'w-5 h-5 rounded border border-slate-300 dark:border-slate-600 checked:bg-blue-600 checked:border-blue-600',
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-orange-500 to-red-600 rounded-xl p-6 shadow-lg',
      child: WText(
        'Checkbox Layouts',
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
