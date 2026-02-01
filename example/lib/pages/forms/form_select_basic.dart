import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WFormSelect example with form validation.
class FormSelectBasicExamplePage extends StatefulWidget {
  const FormSelectBasicExamplePage({super.key});

  @override
  State<FormSelectBasicExamplePage> createState() =>
      _FormSelectBasicExamplePageState();
}

class _FormSelectBasicExamplePageState
    extends State<FormSelectBasicExamplePage> {
  final _formKey = GlobalKey<FormState>();

  String? _country;
  List<String> _tags = [];

  final _countryOptions = const [
    SelectOption(value: 'us', label: 'United States'),
    SelectOption(value: 'uk', label: 'United Kingdom'),
    SelectOption(value: 'ca', label: 'Canada'),
    SelectOption(value: 'au', label: 'Australia'),
  ];

  final _tagOptions = const [
    SelectOption(value: 'flutter', label: 'Flutter'),
    SelectOption(value: 'dart', label: 'Dart'),
    SelectOption(value: 'mobile', label: 'Mobile'),
    SelectOption(value: 'web', label: 'Web'),
  ];

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Form is valid!')));
    }
  }

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
              bg-gradient-to-r from-emerald-500 to-teal-500
            ''',
            children: const [
              WText('WFormSelect', className: 'text-lg font-bold text-white'),
              WText(
                'Form-integrated select with validation',
                className: 'text-sm text-emerald-100',
              ),
            ],
          ),

          // Form
          Form(
            key: _formKey,
            child: WDiv(
              className: 'flex flex-col gap-6',
              children: [
                // Single select with validation
                _buildSection(
                  title: 'Single Select',
                  description: 'Required validation with error state',
                  children: [
                    WFormSelect<String>(
                      value: _country,
                      options: _countryOptions,
                      onChange: (v) => setState(() => _country = v),
                      label: 'Country',
                      labelClassName:
                          'text-sm font-medium text-gray-700 dark:text-gray-200 mb-1',
                      hint: 'Select your country',
                      hintClassName:
                          'text-gray-500 dark:text-gray-400 text-xs mt-1',
                      placeholder: 'Choose a country',
                      className: '''
                        w-72 p-3 rounded-lg
                        bg-white dark:bg-slate-800
                        border border-gray-300 dark:border-gray-600
                        error:border-red-500 error:ring-2 error:ring-red-200
                      ''',
                      menuClassName: '''
                        bg-white dark:bg-slate-800
                        border border-gray-200 dark:border-gray-600
                        rounded-lg shadow-lg max-h-48
                      ''',
                      validator: (value) =>
                          value == null ? 'Country is required' : null,
                    ),
                  ],
                ),

                // Multi select with validation
                _buildSection(
                  title: 'Multi Select',
                  description: 'Minimum 1 tag required',
                  children: [
                    WFormMultiSelect<String>(
                      values: _tags,
                      options: _tagOptions,
                      onMultiChange: (v) => setState(() => _tags = v),
                      label: 'Tags',
                      labelClassName:
                          'text-sm font-medium text-gray-700 dark:text-gray-200 mb-1',
                      placeholder: 'Select tags...',
                      searchable: true,
                      className: '''
                        w-80 p-2 min-h-10 rounded-lg
                        bg-white dark:bg-slate-800
                        border border-gray-300 dark:border-gray-600
                        error:border-red-500
                      ''',
                      menuClassName: '''
                        bg-white dark:bg-slate-800
                        border border-gray-200 dark:border-gray-600
                        rounded-lg shadow-lg max-h-48
                      ''',
                      validator: (values) {
                        if (values == null || values.isEmpty) {
                          return 'Select at least one tag';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                // Submit button
                WButton(
                  onTap: _submit,
                  className: '''
                    bg-blue-600 hover:bg-blue-700
                    text-white px-6 py-2 rounded-lg
                    duration-200
                  ''',
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'Form Widgets',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _referenceRow('WFormSelect', 'Single select'),
                  _referenceRow('WFormMultiSelect', 'Multi select'),
                  _referenceRow('error:', 'Validation failed'),
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
