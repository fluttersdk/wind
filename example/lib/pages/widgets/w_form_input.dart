import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WFormInputExamplePage extends StatefulWidget {
  const WFormInputExamplePage({super.key});

  @override
  State<WFormInputExamplePage> createState() => _WFormInputExamplePageState();
}

class _WFormInputExamplePageState extends State<WFormInputExamplePage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

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
            title: 'Basic Validation',
            description:
                'Input with required field validation and error styling.',
            child: Form(
              key: _formKey,
              child: WDiv(
                className: 'flex flex-col gap-4',
                children: [
                  WFormInput(
                    label: 'Email Address',
                    labelClassName:
                        'text-sm font-medium text-slate-700 dark:text-white mb-1',
                    placeholder: 'john@example.com',
                    type: InputType.email,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email is required';
                      if (!v.contains('@')) return 'Invalid email address';
                      return null;
                    },
                    className:
                        'w-full px-3 py-2 bg-white dark:bg-slate-900 border border-slate-300 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 error:border-red-500 error:ring-red-200',
                  ),
                  WFormInput(
                    label: 'Password',
                    labelClassName:
                        'text-sm font-medium text-slate-700 dark:text-white mb-1',
                    placeholder: 'Enter your password',
                    type: InputType.text,
                    maxLines: 1,
                    validator: (v) {
                      if (v == null || v.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                    className:
                        'w-full px-3 py-2 bg-white dark:bg-slate-900 border border-slate-300 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 error:border-red-500 error:ring-red-200',
                    suffix: WAnchor(
                      onTap: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      child: WIcon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        className: 'text-slate-400 hover:text-slate-600 mr-2',
                      ),
                    ),
                  ),
                  WButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Form Validated!')),
                        );
                      }
                    },
                    className:
                        'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg mt-2 self-start',
                    child: const WText('Validate Form'),
                  ),
                ],
              ),
            ),
          ),
          _buildSection(
            title: 'Input States',
            description: 'Demonstration of disabled and read-only states.',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                WFormInput(
                  label: 'Disabled Input',
                  labelClassName:
                      'text-sm font-medium text-slate-700 dark:text-slate-200 mb-1',
                  initialValue: 'Cannot edit this',
                  enabled: false,
                  className:
                      'w-full px-3 py-2 bg-slate-100 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg text-slate-500',
                ),
                WFormInput(
                  label: 'Read Only Input',
                  labelClassName:
                      'text-sm font-medium text-slate-700 dark:text-slate-200 mb-1',
                  initialValue: 'Selectable but not editable',
                  readOnly: true,
                  className:
                      'w-full px-3 py-2 bg-white dark:bg-slate-900 border border-slate-300 dark:border-slate-700 rounded-lg',
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
          'bg-gradient-to-r from-blue-500 to-indigo-600 rounded-xl p-6 shadow-lg',
      child: WText(
        'Form Input',
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
