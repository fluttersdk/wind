import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WFormInputExamplePage extends StatefulWidget {
  const WFormInputExamplePage({super.key});

  @override
  State<WFormInputExamplePage> createState() => _WFormInputExamplePageState();
}

class _WFormInputExamplePageState extends State<WFormInputExamplePage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;

  static const _inputCls = '''
    w-full px-3 py-2 rounded-lg
    bg-white dark:bg-slate-800
    border border-slate-300 dark:border-slate-600
    focus:border-blue-500 focus:ring-2 focus:ring-blue-500/30
    error:border-red-500 error:ring-2 error:ring-red-500/30
  ''';

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WFormInput',
      description:
          'FormField-wrapped WInput. Validates via Form key, shows error string below the field, error: prefix activates on failure.',
      gradient: 'from-blue-500 to-cyan-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'Wrap in Form + GlobalKey, define validator, call _formKey.currentState!.validate() on submit.',
          child: Form(
            key: _formKey,
            child: WDiv(
              className: 'flex flex-col gap-4',
              children: [
                WFormInput(
                  label: 'Email Address',
                  placeholder: 'you@example.com',
                  type: InputType.email,
                  className: _inputCls,
                  onSaved: (v) => _email = v,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Invalid email address';
                    return null;
                  },
                ),
                WFormInput(
                  label: 'Password',
                  type: InputType.password,
                  className: _inputCls,
                  onSaved: (v) => _password = v,
                  validator: (v) {
                    if (v == null || v.length < 8) {
                      return 'At least 8 characters';
                    }
                    return null;
                  },
                ),
                WButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Submit: $_email / ${_password ?? ""}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  className: '''
                    bg-blue-600 hover:bg-blue-700
                    text-white px-4 py-2 rounded-lg self-start
                  ''',
                  child: const WText('Submit',
                      className: 'text-white font-medium'),
                ),
              ],
            ),
          ),
        ),
        ExampleSection(
          title: 'Hint vs Error',
          description:
              'hint shows when there is no error. error: triggers automatically when validator returns a string.',
          child: Form(
            child: WFormInput(
              label: 'Username',
              hint: '3-20 characters, letters and digits only.',
              placeholder: 'jane_doe',
              className: _inputCls,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (v) {
                if (v == null || v.length < 3) return 'Too short';
                if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v)) {
                  return 'Only letters, digits, and underscores';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
