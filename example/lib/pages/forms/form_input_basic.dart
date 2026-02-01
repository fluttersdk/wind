import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WFormInput example with form validation.
class FormInputBasicExamplePage extends StatefulWidget {
  const FormInputBasicExamplePage({super.key});

  @override
  State<FormInputBasicExamplePage> createState() =>
      _FormInputBasicExamplePageState();
}

class _FormInputBasicExamplePageState extends State<FormInputBasicExamplePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Form is valid!')));
    }
  }

  void _reset() {
    _formKey.currentState!.reset();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              bg-gradient-to-r from-rose-500 to-pink-500
            ''',
            children: const [
              WText('WFormInput', className: 'text-lg font-bold text-white'),
              WText(
                'Form-integrated input with validation',
                className: 'text-sm text-rose-100',
              ),
            ],
          ),

          // Form
          Form(
            key: _formKey,
            child: WDiv(
              className: 'flex flex-col gap-6',
              children: [
                // Email with validation
                _buildSection(
                  title: 'Validation',
                  description: 'Error state applied when validation fails',
                  children: [
                    WFormInput(
                      controller: _emailController,
                      type: InputType.email,
                      label: 'Email',
                      labelClassName:
                          'text-sm font-medium text-gray-700 dark:text-gray-200 mb-1',
                      placeholder: 'name@example.com',
                      className: '''
                        w-full p-3 border border-gray-300 dark:border-gray-600
                        rounded-lg text-gray-900 dark:text-white
                        bg-white dark:bg-slate-800
                        error:border-red-500 error:ring-2 error:ring-red-200
                      ''',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                // With hint
                _buildSection(
                  title: 'With Hint',
                  description: 'Hint text hidden when error shows',
                  children: [
                    WFormInput(
                      controller: _passwordController,
                      type: InputType.password,
                      label: 'Password',
                      labelClassName:
                          'text-sm font-medium text-gray-700 dark:text-gray-200 mb-1',
                      placeholder: 'Enter password',
                      hint: 'Must be at least 6 characters',
                      hintClassName:
                          'text-gray-500 dark:text-gray-400 text-xs mt-1',
                      className: '''
                        w-full p-3 border border-gray-300 dark:border-gray-600
                        rounded-lg text-gray-900 dark:text-white
                        bg-white dark:bg-slate-800
                        error:border-red-500
                      ''',
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                // Submit and Reset buttons
                WDiv(
                  className: 'flex gap-3',
                  children: [
                    WButton(
                      onTap: _submit,
                      className: '''
                        bg-blue-600 hover:bg-blue-700
                        text-white px-6 py-2 rounded-lg
                        duration-200
                      ''',
                      child: const Text('Submit'),
                    ),
                    WButton(
                      onTap: _reset,
                      className: '''
                        bg-gray-200 hover:bg-gray-300
                        text-gray-800 px-6 py-2 rounded-lg
                        duration-200
                      ''',
                      child: const Text('Reset'),
                    ),
                  ],
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
                  _referenceRow('focus:', 'Input focused'),
                  _referenceRow('error:', 'Validation failed'),
                  _referenceRow('disabled:', 'enabled = false'),
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
