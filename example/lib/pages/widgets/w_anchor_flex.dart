import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WAnchorFlexExamplePage extends StatelessWidget {
  const WAnchorFlexExamplePage({super.key});

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
            title: 'Flex Row Layout',
            description: 'WAnchor wrapping a WDiv with flex row layout.',
            child: WAnchor(
              onTap: () {},
              child: WDiv(
                className:
                    'flex items-center gap-3 p-4 bg-white dark:bg-slate-700 border border-gray-200 dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-slate-600 transition-colors cursor-pointer',
                children: const [
                  WDiv(
                    className:
                        'w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900/50 flex items-center justify-center',
                    child: WIcon(Icons.person,
                        className: 'text-blue-600 dark:text-blue-400'),
                  ),
                  WDiv(
                    className: 'flex flex-col',
                    children: [
                      WText('User Profile',
                          className:
                              'font-semibold text-slate-900 dark:text-white'),
                      WText('Manage account settings',
                          className:
                              'text-xs text-slate-500 dark:text-slate-400'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildSection(
            title: 'Card Layout (Flex Column)',
            description:
                'WAnchor providing hover states to a complex card layout.',
            child: WAnchor(
              onTap: () {},
              child: WDiv(
                className:
                    'flex flex-col p-0 bg-white dark:bg-slate-700 border border-gray-200 dark:border-gray-600 rounded-xl overflow-hidden shadow-sm hover:shadow-xl hover:border-indigo-400 dark:hover:border-indigo-500 transition-all duration-300 cursor-pointer max-w-sm',
                children: [
                  WDiv(
                    className:
                        'h-32 bg-gradient-to-br from-purple-500 to-indigo-600 w-full',
                  ),
                  WDiv(
                    className: 'p-4 flex flex-col gap-2',
                    children: const [
                      WText('Interactive Card',
                          className:
                              'text-lg font-bold text-slate-900 dark:text-white'),
                      WText(
                        'This entire card is clickable and reacts to hover states thanks to the parent WAnchor wrapper.',
                        className: 'text-sm text-slate-600 dark:text-slate-300',
                      ),
                      WDiv(
                        className: 'mt-2 flex items-center gap-2',
                        children: [
                          WText('Read more',
                              className:
                                  'text-sm font-medium text-indigo-600 dark:text-indigo-400'),
                          WIcon(Icons.arrow_forward,
                              className:
                                  'text-xs text-indigo-600 dark:text-indigo-400'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildSection(
            title: 'List Item with Actions',
            description: 'Space-between layout for list items.',
            child: WDiv(
              className: 'flex flex-col gap-2',
              children: [
                _buildListItem('Notifications', Icons.notifications, true),
                _buildListItem('Security', Icons.security, false),
                _buildListItem('Appearance', Icons.palette, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, IconData icon, bool hasBadge) {
    return WAnchor(
      onTap: () {},
      child: WDiv(
        className:
            'flex items-center justify-between p-3 rounded-lg hover:bg-gray-100 dark:hover:bg-slate-700/50 cursor-pointer',
        children: [
          WDiv(
            className: 'flex items-center gap-3',
            children: [
              WIcon(icon, className: 'text-slate-500 dark:text-slate-400'),
              WText(title, className: 'text-slate-900 dark:text-white'),
            ],
          ),
          WDiv(
            className: 'flex items-center gap-2',
            children: [
              if (hasBadge)
                WDiv(
                  className: 'w-2 h-2 rounded-full bg-red-500',
                ),
              const WIcon(Icons.chevron_right,
                  className: 'text-slate-400 text-lg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-teal-500 to-emerald-600 rounded-xl p-6 shadow-lg',
      child: WDiv(
        className: 'flex flex-col gap-2',
        children: const [
          WText(
            'Anchor Flex Layouts',
            className: 'text-2xl font-bold text-white',
          ),
          WText(
            'Using WAnchor to create interactive flex containers and complex clickable areas.',
            className: 'text-white/80',
          ),
        ],
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
          'flex flex-col gap-4 p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className:
                    'text-lg font-semibold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-500 dark:text-slate-400'),
          ],
        ),
        WDiv(
          className:
              'p-4 bg-gray-50 dark:bg-slate-900/50 rounded-lg border border-gray-100 dark:border-gray-700/50',
          child: child,
        ),
      ],
    );
  }
}
