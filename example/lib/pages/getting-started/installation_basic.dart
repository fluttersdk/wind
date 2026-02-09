import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Installation showcase - demonstrates Wind's core capabilities
class InstallationBasicExamplePage extends StatefulWidget {
  const InstallationBasicExamplePage({super.key});

  @override
  State<InstallationBasicExamplePage> createState() =>
      _InstallationBasicExamplePageState();
}

class _InstallationBasicExamplePageState
    extends State<InstallationBasicExamplePage> {
  bool _isLoading = false;

  void _simulateAction() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-8 p-6 max-w-5xl mx-auto',
        children: [
          _buildHero(),
          _buildFeatureGrid(),
          _buildInteractiveDemo(),
          _buildResponsiveShowcase(),
          _buildCodeComparison(),
        ],
      ),
    );
  }

  /// Hero section with animated gradient
  Widget _buildHero() {
    return WDiv(
      className:
          'bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-500 rounded-2xl p-8 shadow-2xl',
      child: WDiv(
        className: 'flex flex-col md:flex-row items-center gap-6',
        children: [
          // Logo / Icon area
          WDiv(
            className: 'flex-shrink-0',
            child: WDiv(
              className:
                  'w-24 h-24 bg-white/20 rounded-2xl flex items-center justify-center shadow-lg',
              child: WIcon(
                Icons.air,
                className: 'text-5xl text-white',
              ),
            ),
          ),
          // Text content
          WDiv(
            className: 'flex flex-col gap-3 text-center md:text-left',
            children: [
              WText(
                'Welcome to Wind',
                className: 'text-3xl md:text-4xl font-bold text-white',
              ),
              WText(
                'Utility-first styling for Flutter, inspired by TailwindCSS. Write className strings, get beautiful UIs.',
                className: 'text-lg text-white/90',
              ),
              WDiv(
                className: 'overflow-x-auto mt-2',
                scrollPrimary: false,
                child: WDiv(
                  className: 'flex gap-3 justify-center md:justify-start',
                  children: [
                    _buildBadge('Responsive', Icons.devices),
                    _buildBadge('Dark Mode', Icons.dark_mode),
                    _buildBadge('Hover States', Icons.touch_app),
                    _buildBadge('Animations', Icons.animation),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, IconData icon) {
    return WDiv(
      className:
          'flex items-center gap-2 bg-white/20 hover:bg-white/30 px-3 py-1.5 rounded-full transition-colors',
      children: [
        WIcon(icon, className: 'text-sm text-white'),
        WText(label, className: 'text-sm font-medium text-white'),
      ],
    );
  }

  /// Feature grid showing key capabilities
  Widget _buildFeatureGrid() {
    return WDiv(
      className: 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4',
      children: [
        _buildFeatureCard(
          icon: Icons.palette,
          title: 'Tailwind Syntax',
          description:
              'Use familiar utility classes like bg-blue-500, p-4, flex, rounded-lg',
          color: 'blue',
        ),
        _buildFeatureCard(
          icon: Icons.smartphone,
          title: 'Responsive',
          description: 'Built-in breakpoints: sm:, md:, lg:, xl:, 2xl:',
          color: 'emerald',
        ),
        _buildFeatureCard(
          icon: Icons.dark_mode,
          title: 'Dark Mode',
          description:
              'First-class dark: prefix support with automatic detection',
          color: 'purple',
        ),
        _buildFeatureCard(
          icon: Icons.touch_app,
          title: 'Interactive States',
          description:
              'hover:, focus:, active:, disabled: prefixes work seamlessly',
          color: 'pink',
        ),
        _buildFeatureCard(
          icon: Icons.widgets,
          title: 'Rich Widgets',
          description:
              'WDiv, WText, WButton, WInput, WSelect, WPopover and more',
          color: 'amber',
        ),
        _buildFeatureCard(
          icon: Icons.speed,
          title: 'High Performance',
          description:
              'Parsed styles are cached for optimal runtime performance',
          color: 'cyan',
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required String color,
  }) {
    return WDiv(
      className:
          'p-5 bg-white dark:bg-slate-800 rounded-xl border border-slate-200 dark:border-slate-700 hover:shadow-lg hover:border-$color-400 dark:hover:border-$color-500 transition-all',
      children: [
        WDiv(
          className:
              'w-12 h-12 bg-$color-100 dark:bg-$color-900/30 rounded-xl flex items-center justify-center mb-4',
          child: WIcon(icon,
              className: 'text-2xl text-$color-600 dark:text-$color-400'),
        ),
        WText(
          title,
          className:
              'text-lg font-semibold text-slate-900 dark:text-white mb-2',
        ),
        WText(
          description,
          className: 'text-sm text-slate-600 dark:text-slate-400',
        ),
      ],
    );
  }

  /// Interactive demo section
  Widget _buildInteractiveDemo() {
    return WDiv(
      className:
          'p-6 bg-slate-100 dark:bg-slate-800/50 rounded-2xl border border-slate-200 dark:border-slate-700',
      children: [
        WText(
          'Interactive Demo',
          className: 'text-xl font-bold text-slate-900 dark:text-white mb-2',
        ),
        WText(
          'Try these interactive components - all styled with className strings!',
          className: 'text-slate-600 dark:text-slate-400 mb-6',
        ),
        WDiv(
          className: 'grid grid-cols-1 md:grid-cols-3 gap-4',
          children: [
            // Hover card
            WDiv(
              className:
                  'p-4 bg-white dark:bg-slate-800 rounded-xl border-2 border-transparent hover:border-indigo-500 hover:shadow-xl transition-all cursor-pointer',
              children: [
                WDiv(
                  className: 'flex items-center gap-3 mb-3',
                  children: [
                    WDiv(
                      className:
                          'w-10 h-10 bg-indigo-100 dark:bg-indigo-900/30 rounded-lg flex items-center justify-center',
                      child: WIcon(Icons.mouse,
                          className: 'text-indigo-600 dark:text-indigo-400'),
                    ),
                    WText('Hover Me',
                        className:
                            'font-semibold text-slate-900 dark:text-white'),
                  ],
                ),
                WText(
                  'This card reacts to hover with border and shadow changes.',
                  className: 'text-sm text-slate-600 dark:text-slate-400',
                ),
              ],
            ),

            // Button with loading
            WDiv(
              className:
                  'p-4 bg-white dark:bg-slate-800 rounded-xl flex flex-col gap-3',
              children: [
                WDiv(
                  className: 'flex items-center gap-3 mb-1',
                  children: [
                    WDiv(
                      className:
                          'w-10 h-10 bg-emerald-100 dark:bg-emerald-900/30 rounded-lg flex items-center justify-center',
                      child: WIcon(Icons.bolt,
                          className: 'text-emerald-600 dark:text-emerald-400'),
                    ),
                    WText('Click Action',
                        className:
                            'font-semibold text-slate-900 dark:text-white'),
                  ],
                ),
                WButton(
                  onTap: _isLoading ? null : _simulateAction,
                  className:
                      'w-full bg-emerald-500 hover:bg-emerald-600 disabled:bg-emerald-300 dark:disabled:bg-emerald-800 text-white font-medium py-2.5 rounded-lg transition-colors flex items-center justify-center',
                  child: _isLoading
                      ? WDiv(
                          className: 'flex items-center justify-center gap-2',
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            WText('Loading...', className: 'text-white'),
                          ],
                        )
                      : WText('Click Me', className: 'text-white text-center'),
                ),
              ],
            ),

            // Animation showcase
            WDiv(
              className:
                  'p-4 bg-white dark:bg-slate-800 rounded-xl flex flex-col gap-3',
              children: [
                WDiv(
                  className: 'flex items-center gap-3 mb-1',
                  children: [
                    WDiv(
                      className:
                          'w-10 h-10 bg-pink-100 dark:bg-pink-900/30 rounded-lg flex items-center justify-center',
                      child: WIcon(Icons.animation,
                          className: 'text-pink-600 dark:text-pink-400'),
                    ),
                    WText('Animations',
                        className:
                            'font-semibold text-slate-900 dark:text-white'),
                  ],
                ),
                WDiv(
                  className: 'flex items-center justify-around py-2',
                  children: [
                    WDiv(
                      className: 'flex flex-col items-center gap-1',
                      children: [
                        WDiv(
                          className: 'animate-spin',
                          child: WIcon(Icons.settings,
                              className: 'text-2xl text-pink-500'),
                        ),
                        WText('spin',
                            className:
                                'text-xs text-slate-500 dark:text-slate-400'),
                      ],
                    ),
                    WDiv(
                      className: 'flex flex-col items-center gap-1',
                      children: [
                        WDiv(
                          className: 'animate-pulse',
                          child: WDiv(
                            className: 'w-6 h-6 bg-pink-500 rounded-full',
                          ),
                        ),
                        WText('pulse',
                            className:
                                'text-xs text-slate-500 dark:text-slate-400'),
                      ],
                    ),
                    WDiv(
                      className: 'flex flex-col items-center gap-1',
                      children: [
                        WDiv(
                          className: 'animate-bounce',
                          child: WIcon(Icons.arrow_downward,
                              className: 'text-2xl text-pink-500'),
                        ),
                        WText('bounce',
                            className:
                                'text-xs text-slate-500 dark:text-slate-400'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Responsive showcase
  Widget _buildResponsiveShowcase() {
    return WDiv(
      className:
          'p-6 bg-gradient-to-r from-cyan-500 to-blue-500 rounded-2xl text-white',
      children: [
        WText(
          'Responsive by Design',
          className: 'text-xl font-bold mb-2',
        ),
        WText(
          'Resize your browser to see how these boxes adapt using sm:, md:, lg: prefixes.',
          className: 'text-white/90 mb-6',
        ),
        WDiv(
          className: 'grid grid-cols-2 md:grid-cols-4 gap-3',
          children: [
            WDiv(
              className:
                  'bg-white/20 p-4 rounded-lg text-center hidden sm:flex flex-col items-center',
              children: [
                WIcon(Icons.smartphone, className: 'text-2xl mb-1'),
                WText('sm:', className: 'font-mono text-sm'),
                WText('640px+', className: 'text-xs text-white/70'),
              ],
            ),
            WDiv(
              className:
                  'bg-white/20 p-4 rounded-lg text-center hidden md:flex flex-col items-center',
              children: [
                WIcon(Icons.tablet, className: 'text-2xl mb-1'),
                WText('md:', className: 'font-mono text-sm'),
                WText('768px+', className: 'text-xs text-white/70'),
              ],
            ),
            WDiv(
              className:
                  'bg-white/20 p-4 rounded-lg text-center hidden lg:flex flex-col items-center',
              children: [
                WIcon(Icons.laptop, className: 'text-2xl mb-1'),
                WText('lg:', className: 'font-mono text-sm'),
                WText('1024px+', className: 'text-xs text-white/70'),
              ],
            ),
            WDiv(
              className:
                  'bg-white/20 p-4 rounded-lg text-center hidden xl:flex flex-col items-center',
              children: [
                WIcon(Icons.desktop_windows, className: 'text-2xl mb-1'),
                WText('xl:', className: 'font-mono text-sm'),
                WText('1280px+', className: 'text-xs text-white/70'),
              ],
            ),
          ],
        ),
        WDiv(
          className: 'mt-4 bg-white/10 rounded-lg p-3',
          child: WText(
            'Current visible boxes indicate your screen size breakpoints',
            className: 'text-sm text-center text-white/80',
          ),
        ),
      ],
    );
  }

  /// Code comparison section
  Widget _buildCodeComparison() {
    return WDiv(
      className:
          'p-6 bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700',
      children: [
        WText(
          'Traditional Flutter vs Wind',
          className: 'text-xl font-bold text-slate-900 dark:text-white mb-2',
        ),
        WText(
          'See how Wind simplifies your Flutter code',
          className: 'text-slate-600 dark:text-slate-400 mb-6',
        ),
        WDiv(
          className: 'grid grid-cols-1 lg:grid-cols-2 gap-4',
          children: [
            // Traditional Flutter
            WDiv(
              className: 'flex flex-col gap-2',
              children: [
                WDiv(
                  className: 'flex items-center gap-2',
                  children: [
                    WDiv(
                      className: 'w-3 h-3 bg-red-500 rounded-full',
                    ),
                    WText('Traditional Flutter',
                        className:
                            'font-medium text-slate-700 dark:text-slate-300'),
                  ],
                ),
                WDiv(
                  className:
                      'bg-slate-900 rounded-lg p-4 font-mono text-sm text-slate-300 overflow-x-auto',
                  child: WText(
                    '''Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.blue[500],
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
      ),
    ],
  ),
  child: Text(
    'Hello World',
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
)''',
                    className: 'text-xs text-green-400 whitespace-pre',
                  ),
                ),
              ],
            ),
            // Wind
            WDiv(
              className: 'flex flex-col gap-2',
              children: [
                WDiv(
                  className: 'flex items-center gap-2',
                  children: [
                    WDiv(
                      className: 'w-3 h-3 bg-emerald-500 rounded-full',
                    ),
                    WText('With Wind',
                        className:
                            'font-medium text-slate-700 dark:text-slate-300'),
                  ],
                ),
                WDiv(
                  className:
                      'bg-slate-900 rounded-lg p-4 font-mono text-sm text-slate-300 overflow-x-auto',
                  child: WText(
                    '''WDiv(
  className: 'p-4 bg-blue-500 rounded-xl shadow-lg',
  child: WText(
    'Hello World',
    className: 'text-white font-bold',
  ),
)''',
                    className: 'text-xs text-green-400 whitespace-pre',
                  ),
                ),
                WDiv(
                  className:
                      'bg-emerald-100 dark:bg-emerald-900/30 rounded-lg p-3 mt-2',
                  child: WDiv(
                    className: 'flex items-center gap-2',
                    children: [
                      WIcon(Icons.check_circle,
                          className: 'text-emerald-600 dark:text-emerald-400'),
                      WText('70% less code, same result!',
                          className:
                              'text-sm font-medium text-emerald-700 dark:text-emerald-300'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
