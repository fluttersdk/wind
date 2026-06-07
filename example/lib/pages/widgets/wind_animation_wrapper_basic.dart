import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Demo page for [WindAnimationWrapper]: all four animation types, custom
/// duration, and programmatic animationType switching.
class WindAnimationWrapperBasicExamplePage extends StatefulWidget {
  const WindAnimationWrapperBasicExamplePage({super.key});

  @override
  State<WindAnimationWrapperBasicExamplePage> createState() =>
      _WindAnimationWrapperBasicExamplePageState();
}

class _WindAnimationWrapperBasicExamplePageState
    extends State<WindAnimationWrapperBasicExamplePage> {
  WindAnimationType _selectedType = WindAnimationType.spin;

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
            title: 'spin',
            description: 'Continuous rotation for loading indicators.',
            children: [_buildSpinSection()],
          ),
          _buildSection(
            title: 'ping',
            description: 'Scale and fade out for notification badges.',
            children: [_buildPingSection()],
          ),
          _buildSection(
            title: 'pulse',
            description: 'Opacity pulse for skeleton placeholders.',
            children: [_buildPulseSection()],
          ),
          _buildSection(
            title: 'bounce',
            description: 'Vertical jump for scroll and attention cues.',
            children: [_buildBounceSection()],
          ),
          _buildSection(
            title: 'Programmatic switching',
            description:
                'Change animationType at runtime without restarting the widget.',
            children: [_buildSwitcher()],
          ),
          _buildSection(
            title: 'Custom duration',
            description: 'Slow a pulse to 2 s for a calmer skeleton loader.',
            children: [_buildSlowPulse()],
          ),
          _buildQuickReference(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: '''
        p-6 rounded-xl
        bg-gradient-to-r from-violet-500 to-fuchsia-500
      ''',
      children: const [
        WText(
          'WindAnimationWrapper',
          className: 'text-2xl font-bold text-white',
        ),
        WText(
          'Looping animations: spin, ping, pulse, bounce',
          className: 'text-sm text-white/80',
        ),
      ],
    );
  }

  Widget _buildSpinSection() {
    return WDiv(
      className: 'flex gap-6 items-center',
      children: [
        WindAnimationWrapper(
          animationType: WindAnimationType.spin,
          child: const WIcon(
            Icons.refresh_outlined,
            className: 'text-blue-500 dark:text-blue-400 text-3xl',
          ),
        ),
        WindAnimationWrapper(
          animationType: WindAnimationType.spin,
          child: const WDiv(
            className: 'w-8 h-8 bg-violet-500 dark:bg-violet-400 rounded',
          ),
        ),
        WindAnimationWrapper(
          animationType: WindAnimationType.spin,
          child: const WIcon(
            Icons.settings_outlined,
            className: 'text-gray-600 dark:text-gray-400 text-3xl',
          ),
        ),
      ],
    );
  }

  Widget _buildPingSection() {
    return WDiv(
      className: 'flex gap-8 items-center',
      children: [
        _buildNotificationBadge(
          icon: Icons.notifications_outlined,
          badgeClassName: 'bg-red-500 dark:bg-red-400',
        ),
        _buildNotificationBadge(
          icon: Icons.mail_outlined,
          badgeClassName: 'bg-blue-500 dark:bg-blue-400',
        ),
        WindAnimationWrapper(
          animationType: WindAnimationType.ping,
          child: const WDiv(
            className: 'w-4 h-4 bg-green-500 dark:bg-green-400 rounded-full',
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationBadge({
    required IconData icon,
    required String badgeClassName,
  }) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Icon(icon, size: 28, color: Colors.grey),
            ),
          ),
          Positioned(
            right: 2,
            top: 2,
            child: WindAnimationWrapper(
              animationType: WindAnimationType.ping,
              child: WDiv(
                className: 'w-3 h-3 $badgeClassName rounded-full',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulseSection() {
    return WDiv(
      className: 'flex gap-4 items-start',
      children: [
        WindAnimationWrapper(
          animationType: WindAnimationType.pulse,
          child: const WDiv(
            className: 'w-12 h-12 bg-gray-300 dark:bg-gray-600 rounded-full',
          ),
        ),
        WDiv(
          className: 'flex flex-col gap-2',
          children: [
            WindAnimationWrapper(
              animationType: WindAnimationType.pulse,
              child: const WDiv(
                className: 'h-3 w-36 bg-gray-300 dark:bg-gray-600 rounded',
              ),
            ),
            WindAnimationWrapper(
              animationType: WindAnimationType.pulse,
              child: const WDiv(
                className: 'h-3 w-24 bg-gray-300 dark:bg-gray-600 rounded',
              ),
            ),
            WindAnimationWrapper(
              animationType: WindAnimationType.pulse,
              child: const WDiv(
                className: 'h-3 w-28 bg-gray-300 dark:bg-gray-600 rounded',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBounceSection() {
    return WDiv(
      className: 'flex gap-6 items-end h-12',
      children: [
        WindAnimationWrapper(
          animationType: WindAnimationType.bounce,
          child: const WIcon(
            Icons.arrow_downward_outlined,
            className: 'text-blue-500 dark:text-blue-400 text-2xl',
          ),
        ),
        WindAnimationWrapper(
          animationType: WindAnimationType.bounce,
          child: const WIcon(
            Icons.keyboard_arrow_down_outlined,
            className: 'text-green-500 dark:text-green-400 text-3xl',
          ),
        ),
        WindAnimationWrapper(
          animationType: WindAnimationType.bounce,
          child: const WDiv(
            className: 'w-5 h-5 bg-red-500 dark:bg-red-400 rounded',
          ),
        ),
      ],
    );
  }

  Widget _buildSwitcher() {
    const types = [
      WindAnimationType.spin,
      WindAnimationType.ping,
      WindAnimationType.pulse,
      WindAnimationType.bounce,
      WindAnimationType.none,
    ];

    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WDiv(
          className: 'flex gap-2 flex-wrap',
          children: types.map((type) {
            final isActive = type == _selectedType;
            return WButton(
              onTap: () => setState(() => _selectedType = type),
              className: isActive
                  ? 'px-3 py-1 rounded bg-violet-500 dark:bg-violet-600 text-white text-sm font-medium'
                  : 'px-3 py-1 rounded bg-gray-200 dark:bg-gray-700 text-gray-700 dark:text-gray-300 text-sm',
              child: WText(type.name),
            );
          }).toList(),
        ),
        WDiv(
          className:
              'flex items-center justify-center h-20 rounded-lg bg-gray-50 dark:bg-gray-800',
          child: WindAnimationWrapper(
            animationType: _selectedType,
            child: const WIcon(
              Icons.star_outlined,
              className: 'text-yellow-500 dark:text-yellow-400 text-4xl',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlowPulse() {
    return WDiv(
      className:
          'flex flex-col gap-3 p-4 rounded-lg bg-gray-50 dark:bg-gray-800',
      children: [
        const WText(
          'Order summary (loading...)',
          className: 'text-sm font-medium text-gray-700 dark:text-gray-300',
        ),
        WindAnimationWrapper(
          animationType: WindAnimationType.pulse,
          duration: const Duration(milliseconds: 2000),
          child: const WDiv(
            className: 'h-4 w-full bg-gray-200 dark:bg-gray-700 rounded',
          ),
        ),
        WindAnimationWrapper(
          animationType: WindAnimationType.pulse,
          duration: const Duration(milliseconds: 2000),
          child: const WDiv(
            className: 'h-4 w-3/4 bg-gray-200 dark:bg-gray-700 rounded',
          ),
        ),
        WindAnimationWrapper(
          animationType: WindAnimationType.pulse,
          duration: const Duration(milliseconds: 2000),
          child: const WDiv(
            className: 'h-4 w-1/2 bg-gray-200 dark:bg-gray-700 rounded',
          ),
        ),
      ],
    );
  }

  Widget _buildQuickReference() {
    return WDiv(
      className: 'p-4 rounded-lg bg-gray-100 dark:bg-slate-800',
      children: [
        const WText(
          'Quick Reference',
          className: 'font-semibold text-gray-800 dark:text-white mb-2',
        ),
        WDiv(
          className: 'flex flex-col gap-1',
          children: const [
            WText(
              'animate-spin | animate-ping | animate-pulse | animate-bounce',
              className: 'text-xs font-mono text-gray-600 dark:text-gray-400',
            ),
            WText(
              'WindAnimationWrapper(animationType:, duration:, curve:, child:)',
              className: 'text-xs font-mono text-gray-600 dark:text-gray-400',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return WDiv(
      className: 'flex flex-col gap-4',
      children: [
        WText(
          title,
          className:
              'text-lg font-semibold text-gray-900 dark:text-white font-mono',
        ),
        WText(
          description,
          className: 'text-sm text-gray-500 dark:text-gray-400',
        ),
        ...children,
      ],
    );
  }
}
