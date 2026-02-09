import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Demonstrates the utility-first approach with a beautiful profile card.
class UtilityFirstHeroExamplePage extends StatelessWidget {
  const UtilityFirstHeroExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildHeroCard(),
          _buildUtilityBreakdown(),
          _buildComparisonSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-violet-500 to-fuchsia-600 rounded-xl p-6',
      child: WDiv(
        className: 'flex flex-col gap-2',
        children: [
          WText(
            'Utility-First Approach',
            className: 'text-2xl font-bold text-white',
          ),
          WText(
            'Build complex UIs by composing small, single-purpose utility classes.',
            className: 'text-violet-100',
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return _buildSection(
      title: 'Hero Card Example',
      description:
          'A complete profile card built entirely with utility classes',
      child: WDiv(
        className: 'flex justify-center',
        child: WDiv(
          className:
              'w-80 bg-white dark:bg-slate-800 rounded-2xl shadow-xl overflow-hidden',
          children: [
            // Cover image area
            WDiv(
              className: 'h-24 bg-gradient-to-r from-cyan-400 to-blue-500',
              child: const SizedBox.shrink(),
            ),
            // Profile content
            WDiv(
              className: 'px-6 pb-6',
              children: [
                // Avatar (positioned to overlap cover)
                WDiv(
                  className: 'flex justify-center -mt-12',
                  child: WDiv(
                    className:
                        'w-24 h-24 rounded-full bg-gradient-to-br from-pink-400 to-rose-500 border-4 border-white dark:border-slate-800 shadow-lg flex items-center justify-center',
                    child:
                        WText('JD', className: 'text-2xl font-bold text-white'),
                  ),
                ),
                // Name & title
                WDiv(
                  className: 'text-center mt-4',
                  children: [
                    WText('Jane Doe',
                        className:
                            'text-xl font-bold text-slate-900 dark:text-white'),
                    WText('Senior Flutter Developer',
                        className:
                            'text-sm text-slate-500 dark:text-slate-400 mt-1'),
                  ],
                ),
                // Stats row
                WDiv(
                  className: 'flex justify-center gap-8 mt-4',
                  children: [
                    _buildStat('128', 'Projects'),
                    _buildStat('14.2k', 'Followers'),
                    _buildStat('892', 'Following'),
                  ],
                ),
                // Action button
                WDiv(
                  className: 'flex justify-center mt-4',
                  child: WButton(
                    className:
                        'px-8 bg-blue-500 hover:bg-blue-600 text-white py-2.5 rounded-xl font-medium',
                    onTap: () {},
                    child: WText('Follow', className: 'text-white font-medium'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return WDiv(
      className: 'flex flex-col items-center',
      children: [
        WText(value,
            className: 'text-lg font-bold text-slate-900 dark:text-white'),
        WText(label, className: 'text-xs text-slate-500 dark:text-slate-400'),
      ],
    );
  }

  Widget _buildUtilityBreakdown() {
    final utilities = [
      ('Layout', 'flex, justify-center, items-center, gap-8'),
      ('Spacing', 'p-6, px-6, pb-6, mt-4, mt-6, -mt-12'),
      ('Sizing', 'w-80, w-24, h-24, w-full'),
      ('Colors', 'bg-white, bg-blue-500, text-slate-900'),
      ('Borders', 'rounded-2xl, rounded-full, border-4'),
      ('Effects', 'shadow-xl, shadow-lg, overflow-hidden'),
      ('Typography', 'text-xl, font-bold, text-center'),
      ('Gradients', 'bg-gradient-to-r, from-cyan-400, to-blue-500'),
    ];

    return _buildSection(
      title: 'Utilities Used',
      description: 'The card above uses these utility categories:',
      child: WDiv(
        className: 'grid grid-cols-2 md:grid-cols-4 gap-3',
        children: utilities.map((entry) {
          final (category, examples) = entry;
          return WDiv(
            className: 'p-3 bg-slate-50 dark:bg-slate-700/50 rounded-lg',
            children: [
              WText(category,
                  className:
                      'text-sm font-semibold text-slate-900 dark:text-white'),
              WText(examples,
                  className: 'text-xs text-slate-500 dark:text-slate-400 mt-1'),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildComparisonSection() {
    return _buildSection(
      title: 'Why Utility-First?',
      description: 'Compare traditional styling vs utility-first approach',
      child: WDiv(
        className: 'flex flex-col gap-4',
        children: [
          // Traditional approach
          WDiv(
            className:
                'p-4 bg-red-50 dark:bg-red-900/20 rounded-lg border border-red-200 dark:border-red-800',
            children: [
              WText('❌ Traditional Flutter',
                  className:
                      'text-sm font-semibold text-red-700 dark:text-red-400'),
              WDiv(
                className: 'mt-2 p-3 bg-slate-900 rounded font-mono text-xs',
                child: WText(
                  'Container(\n'
                  '  padding: EdgeInsets.all(16),\n'
                  '  decoration: BoxDecoration(\n'
                  '    color: Colors.white,\n'
                  '    borderRadius: BorderRadius.circular(16),\n'
                  '    boxShadow: [...],\n'
                  '  ),\n'
                  '  child: ...\n'
                  ')',
                  className: 'text-green-400',
                ),
              ),
            ],
          ),
          // Utility-first approach
          WDiv(
            className:
                'p-4 bg-green-50 dark:bg-green-900/20 rounded-lg border border-green-200 dark:border-green-800',
            children: [
              WText('✅ Utility-First Wind',
                  className:
                      'text-sm font-semibold text-green-700 dark:text-green-400'),
              WDiv(
                className: 'mt-2 p-3 bg-slate-900 rounded font-mono text-xs',
                child: WText(
                  "WDiv(\n"
                  "  className: 'p-4 bg-white rounded-2xl shadow-xl',\n"
                  "  child: ...\n"
                  ")",
                  className: 'text-green-400',
                ),
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
    required Widget child,
  }) {
    return WDiv(
      className:
          'flex flex-col gap-4 p-5 bg-white dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700',
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
        child,
      ],
    );
  }
}
