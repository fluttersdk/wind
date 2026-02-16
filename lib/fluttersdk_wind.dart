/// # Wind - Utility-First Styling for Flutter
///
/// Wind is a utility-first styling framework for Flutter, inspired by TailwindCSS.
/// It translates Tailwind-style utility class strings into Flutter widget trees,
/// allowing you to build UIs using familiar CSS-like syntax directly in your widgets.
///
/// ## Core Concepts
///
/// - **Utility Classes**: Style widgets using `className` strings like `'flex gap-4 p-6 bg-blue-500 rounded-lg'`
/// - **W-Prefixed Widgets**: Use `WDiv`, `WText`, `WButton`, `WInput`, and other W-widgets that accept `className`
/// - **Responsive Design**: Apply breakpoint-specific styles with `sm:`, `md:`, `lg:`, `xl:`, `2xl:` prefixes
/// - **State-Based Styling**: Use `hover:`, `focus:`, `disabled:`, `loading:` prefixes for interactive states
/// - **Dark Mode**: Toggle themes and use `dark:` prefix for dark-mode-specific styles
/// - **Platform-Specific**: Target platforms with `ios:`, `android:`, `web:`, `mobile:` prefixes
///
/// ## Getting Started
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:fluttersdk_wind/fluttersdk_wind.dart';
///
/// void main() => runApp(MyApp());
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return WindTheme(
///       data: WindThemeData(),
///       child: MaterialApp(
///         home: Scaffold(
///           body: WDiv(
///             className: 'flex flex-col gap-4 p-6 bg-gray-100 min-h-screen',
///             children: [
///               WText(
///                 'Hello Wind!',
///                 className: 'text-3xl font-bold text-blue-600',
///               ),
///               WDiv(
///                 className: 'bg-white rounded-xl shadow-lg p-6 hover:shadow-xl',
///                 child: WText(
///                   'Build UIs faster with utility-first styling',
///                   className: 'text-gray-600',
///                 ),
///               ),
///               WButton(
///                 onTap: () => print('Clicked!'),
///                 className: 'bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg',
///                 child: Text('Get Started'),
///               ),
///             ],
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// For complete documentation, visit the [Wind documentation](https://wind.fluttersdk.com).
library;

export 'src/core/platform_service.dart';
export 'src/parser/parsers/background_parser.dart';
export 'src/parser/parsers/border_parser.dart';

export 'src/parser/parsers/flexbox_grid_parser.dart';
export 'src/parser/parsers/margin_parser.dart';
export 'src/parser/parsers/padding_parser.dart';
export 'src/parser/parsers/sizing_parser.dart';
export 'src/parser/parsers/text_parser.dart';
export 'src/parser/parsers/opacity_parser.dart';
export 'src/parser/parsers/zindex_parser.dart';
export 'src/parser/parsers/overflow_parser.dart';
export 'src/parser/parsers/aspectratio_parser.dart';
export 'src/parser/parsers/transition_parser.dart';
export 'src/parser/parsers/ring_parser.dart';
export 'src/parser/parsers/wind_parser_interface.dart';
export 'src/parser/wind_context.dart';
export 'src/parser/wind_parser.dart';
export 'src/parser/wind_style.dart';
export 'src/state/wind_anchor_state.dart';
export 'src/state/wind_anchor_state_provider.dart';
export 'src/theme/defaults/border_radius.dart';
export 'src/theme/defaults/border_widths.dart';
export 'src/theme/defaults/colors.dart';
export 'src/theme/defaults/containers.dart';
export 'src/theme/defaults/font_sizes.dart';
export 'src/theme/defaults/font_weights.dart';
export 'src/theme/defaults/leading.dart';
export 'src/theme/defaults/screens.dart';
export 'src/theme/defaults/tracking.dart';
export 'src/theme/defaults/font_families.dart';
export 'src/theme/wind_theme.dart';
export 'src/theme/wind_theme_data.dart';
export 'src/utils/color_utils.dart';
export 'src/utils/wind_logger.dart';
export 'src/utils/wind_helpers.dart';
export 'src/utils/wind_extensions.dart';
export 'src/widgets/w_anchor.dart';
export 'src/widgets/w_button.dart';
export 'src/widgets/w_div.dart';
export 'src/widgets/w_input.dart';
export 'src/widgets/w_form_input.dart';
export 'src/widgets/w_text.dart';
export 'src/widgets/select_option.dart';
export 'src/widgets/w_select.dart';
export 'src/widgets/w_form_select.dart';
export 'src/widgets/w_icon.dart';
export 'src/widgets/w_image.dart';
export 'src/widgets/w_svg.dart';
export 'src/widgets/w_checkbox.dart';
export 'src/widgets/w_form_checkbox.dart';
export 'src/widgets/w_popover.dart';
export 'src/widgets/wind_animation_wrapper.dart';
export 'src/widgets/w_date_picker.dart';
export 'src/widgets/w_form_date_picker.dart';
export 'src/widgets/w_keyboard_actions.dart';
export 'src/widgets/w_spacer.dart';
export 'src/dynamic/w_dynamic.dart';
export 'src/dynamic/w_dynamic_controller.dart';
export 'src/dynamic/w_dynamic_state.dart';
export 'src/dynamic/w_action_handler.dart';
export 'src/dynamic/w_dynamic_config.dart';
export 'src/dynamic/w_dynamic_renderer.dart';

// Re-export keyboard_actions for convenience
export 'package:keyboard_actions/keyboard_actions.dart';
