import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class StateManagementOverviewExamplePage extends StatelessWidget {
  const StateManagementOverviewExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-gray-50 dark:bg-gray-900',
      scrollPrimary: true,
      children: [
        WDiv(
          className: 'flex flex-col gap-8 max-w-4xl mx-auto',
          children: [
            _buildHeader(),

            // Hover State
            _buildSection(
              title: 'Hover State',
              description:
                  'Styles applied when the mouse hovers over the element. Use the "hover:" prefix.',
              child: WDiv(
                className: 'grid grid-cols-1 md:grid-cols-2 gap-4',
                children: [
                  WButton(
                    onTap: () {},
                    className:
                        'bg-blue-500 hover:bg-blue-600 text-white px-6 py-4 rounded-lg transition-colors duration-200',
                    child: const WText('Hover Me (Background)'),
                  ),
                  WAnchor(
                    child: WDiv(
                      className:
                          'px-6 py-4 border border-gray-300 dark:border-gray-700 rounded-lg hover:shadow-lg hover:border-blue-500 transition-all duration-300 bg-white dark:bg-gray-800',
                      children: const [
                        WText('Hover Me (Shadow & Border)',
                            className:
                                'text-gray-700 dark:text-gray-300 font-medium'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Focus State
            _buildSection(
              title: 'Focus State',
              description:
                  'Styles applied when the element has keyboard focus. Use the "focus:" prefix.',
              child: WDiv(
                className: 'flex flex-col gap-4',
                children: [
                  WInput(
                    className:
                        'w-full p-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition-all',
                    placeholder: 'Click to focus (Ring)',
                  ),
                  WInput(
                    className:
                        'w-full p-3 bg-gray-100 dark:bg-gray-800 border-none rounded-lg focus:bg-white dark:focus:bg-gray-700 focus:shadow-md transition-all',
                    placeholder: 'Click to focus (Background & Shadow)',
                  ),
                ],
              ),
            ),

            // Active State (Custom)
            _buildSection(
              title: 'Active State (Custom)',
              description:
                  'Simulating an "active" (pressed) state using custom state management. Wind allows arbitrary state prefixes like "active:".',
              child: const _ActiveStateDemo(),
            ),

            // Disabled State
            _buildSection(
              title: 'Disabled State',
              description:
                  'Styles applied when the element is disabled. Use the "disabled:" prefix.',
              child: WDiv(
                className: 'flex flex-wrap gap-4',
                children: [
                  WButton(
                    disabled: true,
                    onTap: () {},
                    className:
                        'bg-blue-500 text-white px-6 py-3 rounded-lg disabled:opacity-50 disabled:cursor-not-allowed',
                    child: const WText('Disabled Button'),
                  ),
                  WInput(
                    enabled: false,
                    className:
                        'p-3 border border-gray-300 rounded-lg disabled:bg-gray-100 disabled:text-gray-400',
                    placeholder: 'Disabled Input',
                  ),
                ],
              ),
            ),

            // Group Hover (Parent State)
            _buildSection(
              title: 'Group Hover Pattern',
              description:
                  'Using WAnchor to style children based on parent hover state.',
              child: WAnchor(
                child: WDiv(
                  className:
                      'group p-6 bg-white dark:bg-gray-800 rounded-xl shadow-sm hover:shadow-md border border-gray-200 dark:border-gray-700 transition-all cursor-pointer',
                  children: [
                    WDiv(
                      className: 'flex items-center gap-4',
                      children: [
                        WDiv(
                          className:
                              'w-12 h-12 rounded-full bg-blue-100 dark:bg-blue-900 flex items-center justify-center group-hover:bg-blue-500 transition-colors duration-300',
                          children: const [
                            WIcon(Icons.person,
                                className:
                                    'text-blue-500 group-hover:text-white transition-colors duration-300'),
                          ],
                        ),
                        WDiv(
                          className: 'flex flex-col',
                          children: const [
                            WText('Hover the card',
                                className:
                                    'font-bold text-gray-900 dark:text-white group-hover:text-blue-500 transition-colors'),
                            WText('Child elements react to parent hover',
                                className: 'text-sm text-gray-500'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'w-full p-6 rounded-2xl bg-gradient-to-r from-indigo-500 to-purple-600 shadow-lg text-white',
      children: [
        const WText('State Management', className: 'text-3xl font-bold mb-2'),
        const WText(
          'Wind provides powerful state-based styling using prefixes like hover:, focus:, and disabled:. You can also define custom states for complex interactions.',
          className: 'text-indigo-100 text-lg opacity-90',
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className: 'flex flex-col gap-3',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className: 'text-xl font-bold text-gray-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-gray-500 dark:text-gray-400'),
          ],
        ),
        WDiv(
          className:
              'p-6 bg-white dark:bg-gray-800 rounded-xl border border-gray-200 dark:border-gray-700 shadow-sm',
          child: child,
        ),
      ],
    );
  }
}

class _ActiveStateDemo extends StatefulWidget {
  const _ActiveStateDemo();

  @override
  State<_ActiveStateDemo> createState() => _ActiveStateDemoState();
}

class _ActiveStateDemoState extends State<_ActiveStateDemo> {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isActive = true),
      onTapUp: (_) => setState(() => _isActive = false),
      onTapCancel: () => setState(() => _isActive = false),
      child: WDiv(
        // Pass the custom state 'active' when pressed
        states: _isActive ? {'active'} : null,
        className:
            'w-full md:w-64 h-32 bg-indigo-500 rounded-xl flex items-center justify-center cursor-pointer transition-all duration-100 active:bg-indigo-600 active:scale-95 shadow-md active:shadow-inner',
        children: [
          WText(
            _isActive ? 'Pressed!' : 'Press Me',
            className: 'text-white font-bold text-xl active:text-indigo-100',
          ),
        ],
      ),
    );
  }
}
