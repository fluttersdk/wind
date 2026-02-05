import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../parser/wind_parser.dart';

/// A Wind-styled wrapper that adds keyboard actions (Done button, navigation)
/// to input fields, especially for iOS numeric keyboards.
///
/// This widget wraps child content with [KeyboardActions] to provide:
/// - Done button for dismissing numeric keyboards on iOS
/// - Up/Down navigation between multiple input fields
/// - Customizable toolbar styling via Wind className
///
/// ## Basic Usage
///
/// ```dart
/// class MyForm extends StatefulWidget {
///   @override
///   State<MyForm> createState() => _MyFormState();
/// }
///
/// class _MyFormState extends State<MyForm> {
///   final _nameFocus = FocusNode();
///   final _amountFocus = FocusNode();
///
///   @override
///   void dispose() {
///     _nameFocus.dispose();
///     _amountFocus.dispose();
///     super.dispose();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return WKeyboardActions(
///       focusNodes: [_nameFocus, _amountFocus],
///       child: Column(
///         children: [
///           WFormInput(
///             focusNode: _nameFocus,
///             label: 'Name',
///           ),
///           WFormInput(
///             focusNode: _amountFocus,
///             label: 'Amount',
///             type: InputType.number, // Done button appears!
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
///
/// ## Platform Targeting
///
/// Control which platforms show the keyboard actions toolbar:
///
/// ```dart
/// WKeyboardActions(
///   platform: 'ios', // Only on iOS (most common use case)
///   focusNodes: [_focusNode],
///   child: ...,
/// )
/// ```
///
/// ## Toolbar Styling
///
/// Customize toolbar appearance with Wind className:
///
/// ```dart
/// WKeyboardActions(
///   toolbarClassName: 'bg-gray-100 dark:bg-gray-800',
///   focusNodes: [_focusNode],
///   child: ...,
/// )
/// ```
class WKeyboardActions extends StatelessWidget {
  /// Child widget (usually a form or column of inputs).
  final Widget child;

  /// FocusNodes for inputs that need keyboard actions.
  ///
  /// Each FocusNode should be attached to a TextField/WFormInput.
  /// The order determines the navigation order when using nextFocus.
  final List<FocusNode> focusNodes;

  /// Platform targeting: 'ios', 'android', or 'all' (default).
  ///
  /// - `'all'` - Show on both iOS and Android
  /// - `'ios'` - Only show on iOS (recommended for numeric keyboard fix)
  /// - `'android'` - Only show on Android
  final String platform;

  /// Enable up/down navigation between fields.
  ///
  /// When true (default), users can navigate between fields using
  /// arrow buttons in the keyboard toolbar.
  final bool nextFocus;

  /// Toolbar background className (Wind utility classes).
  ///
  /// Use `bg-*` classes to set the toolbar color:
  /// ```dart
  /// toolbarClassName: 'bg-gray-100 dark:bg-gray-800'
  /// ```
  final String? toolbarClassName;

  /// Custom close widget builder.
  ///
  /// If provided, replaces the default "Done" text button.
  final Widget Function(FocusNode)? closeWidgetBuilder;

  /// Creates a Wind keyboard actions wrapper.
  const WKeyboardActions({
    super.key,
    required this.child,
    required this.focusNodes,
    this.platform = 'all',
    this.nextFocus = true,
    this.toolbarClassName,
    this.closeWidgetBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: _buildConfig(context),
      child: child,
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: _getPlatform(),
      keyboardBarColor: _getToolbarColor(context),
      nextFocus: nextFocus,
      actions: focusNodes
          .map(
            (node) => KeyboardActionsItem(
              focusNode: node,
              displayDoneButton: closeWidgetBuilder == null,
              toolbarButtons: closeWidgetBuilder != null
                  ? [(node) => closeWidgetBuilder!(node)]
                  : null,
            ),
          )
          .toList(),
    );
  }

  KeyboardActionsPlatform _getPlatform() {
    return switch (platform.toLowerCase()) {
      'ios' => KeyboardActionsPlatform.IOS,
      'android' => KeyboardActionsPlatform.ANDROID,
      _ => KeyboardActionsPlatform.ALL,
    };
  }

  Color? _getToolbarColor(BuildContext context) {
    if (toolbarClassName == null || toolbarClassName!.isEmpty) {
      return null;
    }

    // Parse Wind className to extract background color from decoration
    final styles = WindParser.parse(toolbarClassName!, context);

    return styles.decoration?.color;
  }
}
