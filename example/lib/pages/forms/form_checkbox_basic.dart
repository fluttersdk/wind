import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WFormCheckbox example with form validation.
class FormCheckboxBasicExamplePage extends StatefulWidget {
  const FormCheckboxBasicExamplePage({super.key});

  @override
  State<FormCheckboxBasicExamplePage> createState() =>
      _FormCheckboxBasicExamplePageState();
}

class _FormCheckboxBasicExamplePageState
    extends State<FormCheckboxBasicExamplePage> {
  final _formKey = GlobalKey<FormState>();
  bool _agreeTerms = false;
  bool _subscribe = false;
  final bool _remember = true;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Form submitted!')));
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
              WText('WFormCheckbox', className: 'text-lg font-bold text-white'),
              WText(
                'Form checkbox with validation support',
                className: 'text-sm text-emerald-100',
              ),
            ],
          ),

          // Form with validation
          Form(
            key: _formKey,
            child: WDiv(
              className: 'flex flex-col gap-6',
              children: [
                // Basic with validation
                _buildSection(
                  title: 'Form Validation',
                  description: 'Shows error state when validation fails',
                  children: [
                    WFormCheckbox(
                      value: _agreeTerms,
                      onChanged: (val) => setState(() => _agreeTerms = val),
                      labelText: 'I agree to Terms of Service',
                      labelClassName:
                          'text-sm text-gray-700 dark:text-gray-200',
                      className: '''
                        w-5 h-5 rounded border border-gray-300
                        items-center justify-center
                        checked:bg-blue-500 checked:border-transparent
                        error:border-red-500
                      ''',
                      validator: (value) =>
                          value != true ? 'You must agree to terms' : null,
                    ),
                  ],
                ),

                // With hint
                _buildSection(
                  title: 'With Hint',
                  description: 'Optional hint text below checkbox',
                  children: [
                    WFormCheckbox(
                      value: _subscribe,
                      onChanged: (val) => setState(() => _subscribe = val),
                      labelText: 'Subscribe to newsletter',
                      labelClassName:
                          'text-sm text-gray-700 dark:text-gray-200',
                      hint: 'We send updates once a week',
                      hintClassName:
                          'text-gray-500 dark:text-gray-400 text-xs mt-1',
                      className: '''
                        w-5 h-5 rounded border border-gray-300
                        items-center justify-center
                        checked:bg-green-500 checked:border-transparent
                      ''',
                    ),
                  ],
                ),

                // Disabled
                _buildSection(
                  title: 'Disabled State',
                  description: 'Use disabled prop to prevent interaction',
                  children: [
                    WFormCheckbox(
                      value: _remember,
                      disabled: true,
                      labelText: 'Remember me (disabled)',
                      labelClassName:
                          'text-sm text-gray-500 dark:text-gray-400',
                      className: '''
                        w-5 h-5 rounded border border-gray-200
                        items-center justify-center
                        checked:bg-blue-300 checked:border-transparent
                        disabled:opacity-50
                      ''',
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
                'State Prefixes',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _referenceRow('checked:', 'value = true'),
                  _referenceRow('error:', 'Validation failed'),
                  _referenceRow('disabled:', 'disabled = true'),
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
