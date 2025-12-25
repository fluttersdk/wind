import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ButtonStatesExamplePage extends StatefulWidget {
  const ButtonStatesExamplePage({super.key});

  @override
  State<ButtonStatesExamplePage> createState() =>
      _ButtonStatesExamplePageState();
}

class _ButtonStatesExamplePageState extends State<ButtonStatesExamplePage> {
  bool _isLoading = false;

  void _simulateLoading() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: WDiv(
            className: 'flex flex-col gap-8 w-full items-center',
            children: [
              const WText(
                'Button States',
                className: 'text-2xl font-bold text-gray-900',
              ),
              const WText(
                'Hover, focus, disabled, and loading states',
                className: 'text-gray-500',
              ),

              // Hover State Demo
              WDiv(
                className: 'flex flex-col gap-2 items-center',
                children: [
                  const WText(
                    'Hover State',
                    className: 'text-sm text-gray-600',
                  ),
                  WButton(
                    onTap: () {},
                    className:
                        'bg-blue-600 hover:bg-blue-800 hover:scale-105 text-white px-6 py-3 rounded-lg font-medium duration-200',
                    child: const Text('Hover Me'),
                  ),
                ],
              ),

              // Disabled State Demo
              WDiv(
                className: 'flex flex-col gap-2 items-center',
                children: [
                  const WText(
                    'Disabled State',
                    className: 'text-sm text-gray-600',
                  ),
                  WButton(
                    onTap: () {},
                    disabled: true,
                    className:
                        'bg-blue-600 disabled:bg-gray-400 disabled:opacity-50 text-white px-6 py-3 rounded-lg font-medium',
                    child: const Text('Disabled Button'),
                  ),
                ],
              ),

              // Loading State Demo
              WDiv(
                className: 'flex flex-col gap-2 items-center',
                children: [
                  const WText(
                    'Loading State',
                    className: 'text-sm text-gray-600',
                  ),
                  WButton(
                    onTap: _simulateLoading,
                    isLoading: _isLoading,
                    loadingText: 'Processing...',
                    className:
                        'bg-green-600 hover:bg-green-700 loading:opacity-70 text-white px-6 py-3 rounded-lg font-medium',
                    child: const Text('Click to Load'),
                  ),
                ],
              ),

              // Custom Loading Widget
              WDiv(
                className: 'flex flex-col gap-2 items-center',
                children: [
                  const WText(
                    'Custom Loading Widget',
                    className: 'text-sm text-gray-600',
                  ),
                  WButton(
                    onTap: () {},
                    isLoading: true,
                    loadingWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.hourglass_empty,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        const Text('Please wait...'),
                      ],
                    ),
                    className:
                        'bg-purple-600 text-white px-6 py-3 rounded-lg font-medium',
                    child: const Text('Submit'),
                  ),
                ],
              ),

              // Code Example
              WDiv(
                className: 'w-full p-4 bg-gray-800 rounded-lg',
                children: const [
                  WText('''// Loading state
WButton(
  onTap: _submit,
  isLoading: _isSubmitting,
  loadingText: 'Submitting...',
  className: 'bg-blue-600 loading:opacity-70 text-white rounded-lg',
  child: Text('Submit'),
)

// Disabled state
WButton(
  onTap: () {},
  disabled: true,
  className: 'bg-blue-600 disabled:bg-gray-400 text-white rounded-lg',
  child: Text('Disabled'),
)''', className: 'text-xs text-white font-mono'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
