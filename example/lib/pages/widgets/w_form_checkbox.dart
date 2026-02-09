import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WFormCheckboxExamplePage extends StatefulWidget {
  const WFormCheckboxExamplePage({super.key});

  @override
  State<WFormCheckboxExamplePage> createState() =>
      _WFormCheckboxExamplePageState();
}

class _WFormCheckboxExamplePageState extends State<WFormCheckboxExamplePage> {
  final _formKey = GlobalKey<FormState>();
  bool _termsAccepted = false;
  bool _newsletter = true;
  bool _marketing = false;

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
            title: 'Checkbox Validation',
            description: 'Required checkbox for terms and conditions.',
            child: Form(
              key: _formKey,
              child: WDiv(
                className: 'flex flex-col gap-4',
                children: [
                  WFormCheckbox(
                    value: _termsAccepted,
                    onChanged: (v) => setState(() => _termsAccepted = v),
                    labelText:
                        'I agree to the Terms of Service and Privacy Policy',
                    validator: (v) {
                      if (v != true) return 'You must accept the terms';
                      return null;
                    },
                    className:
                        'w-5 h-5 rounded border border-slate-300 dark:border-slate-600 checked:bg-blue-600 checked:border-blue-600 error:border-red-500',
                    labelClassName: 'text-sm text-slate-700 dark:text-white',
                  ),
                  WButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Accepted!')),
                        );
                      }
                    },
                    className:
                        'bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg self-start ml-8',
                    child: const WText('Submit'),
                  ),
                ],
              ),
            ),
          ),
          _buildSection(
            title: 'Custom Styling',
            description: 'Checkboxes with custom sizes, colors, and icons.',
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                WFormCheckbox(
                  value: _newsletter,
                  onChanged: (v) => setState(() => _newsletter = v),
                  labelText: 'Subscribe to newsletter',
                  hint: 'We send weekly updates',
                  checkIcon: Icons.star,
                  className:
                      'w-6 h-6 rounded-full border-2 border-purple-500 checked:bg-purple-500 checked:border-purple-500',
                  iconClassName: 'text-white w-4 h-4',
                ),
                WFormCheckbox(
                  value: _marketing,
                  onChanged: (v) => setState(() => _marketing = v),
                  label: WDiv(
                    className: 'flex flex-col',
                    children: [
                      WText('Marketing Emails', className: 'font-medium'),
                      WText('Receive offers and promotions',
                          className: 'text-xs text-gray-500'),
                    ],
                  ),
                  className:
                      'w-5 h-5 rounded border border-gray-400 checked:bg-orange-500 checked:border-orange-500',
                ),
                WFormCheckbox(
                  value: true,
                  onChanged: (v) {},
                  labelText: 'Disabled Checked',
                  disabled: true,
                  className:
                      'w-5 h-5 rounded border border-gray-300 bg-gray-100 dark:bg-gray-800 checked:bg-gray-400',
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
          'bg-gradient-to-r from-green-500 to-emerald-600 rounded-xl p-6 shadow-lg',
      child: WText(
        'Form Checkbox',
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
