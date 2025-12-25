import 'package:flutter/material.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../state/wind_anchor_state_provider.dart';
import 'w_anchor.dart';

/// **The Utility-First Button Component**
///
/// `WButton` is a button widget that combines `WAnchor` state management
/// with Tailwind-like utility class styling and built-in loading states.
///
/// ### Key Features:
/// - **State-Based Styling:** Inherits `hover:`, `focus:`, `disabled:` from `WAnchor`
/// - **Loading State:** Built-in loading spinner with optional text
/// - **Tailwind Styling:** Use `className` for button appearance
/// - **Custom Loading:** Provide your own `loadingWidget`
///
/// ### Example Usage:
///
/// ```dart
/// WButton(
///   onTap: () => print('Clicked!'),
///   className: 'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg',
///   child: Text('Click me'),
/// )
/// ```
///
/// ### Loading State:
///
/// ```dart
/// WButton(
///   onTap: _submit,
///   isLoading: _isSubmitting,
///   loadingText: 'Submitting...',
///   className: 'bg-blue-600 text-white px-4 py-2 rounded-lg loading:opacity-70',
///   child: Text('Submit'),
/// )
/// ```
class WButton extends StatelessWidget {
  /// The button content when not loading.
  final Widget child;

  /// Callback when button is tapped.
  ///
  /// Ignored when `isLoading` or `disabled` is true.
  final VoidCallback? onTap;

  /// Callback when button is long pressed.
  final VoidCallback? onLongPress;

  /// Callback when button is double tapped.
  final VoidCallback? onDoubleTap;

  /// Whether the button is in loading state.
  ///
  /// When true:
  /// - Interactions are disabled
  /// - Shows loading spinner (or custom `loadingWidget`)
  /// - `loading:` prefixed classes are applied
  final bool isLoading;

  /// Whether the button is disabled.
  ///
  /// When true:
  /// - Interactions are disabled
  /// - `disabled:` prefixed classes are applied
  final bool disabled;

  /// Tailwind-like utility classes for styling.
  ///
  /// Supports state prefixes:
  /// - `hover:` - Applied on hover
  /// - `focus:` - Applied on focus
  /// - `disabled:` - Applied when disabled
  /// - `loading:` - Applied when loading
  ///
  /// Example: `'bg-blue-600 hover:bg-blue-700 disabled:bg-gray-400'`
  final String? className;

  /// Optional text to show alongside the loading spinner.
  final String? loadingText;

  /// Custom loading widget to replace the default spinner.
  final Widget? loadingWidget;

  /// Size of the default loading spinner.
  final double loadingSize;

  /// Color of the default loading spinner.
  ///
  /// If null, uses the text color from className or white.
  final Color? loadingColor;

  /// Custom states for dynamic styling (e.g., 'error', 'success').
  ///
  /// These states activate their corresponding prefix classes.
  /// Example: `states: {'error'}` activates `error:border-red-500`.
  final Set<String>? states;

  /// Creates a new [WButton] instance.
  const WButton({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.isLoading = false,
    this.disabled = false,
    this.className,
    this.loadingText,
    this.loadingWidget,
    this.loadingSize = 16,
    this.loadingColor,
    this.states,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if button is interactive
    final bool isInteractive = !isLoading && !disabled;

    // Wrap with WAnchor for state management FIRST
    // Then use Builder to access the state inside WAnchor's subtree
    return WAnchor(
      onTap: isInteractive ? onTap : null,
      onLongPress: isInteractive ? onLongPress : null,
      onDoubleTap: isInteractive ? onDoubleTap : null,
      isDisabled: disabled,
      states: states,
      child: Builder(
        builder: (innerContext) {
          // Now we can access the hover state from WindAnchorStateProvider
          final anchorState = WindAnchorStateProvider.of(innerContext);

          // Build active states set for parsing
          final Set<String> activeStates = {
            ...?anchorState?.customStates,
            if (isLoading) 'loading',
            if (disabled) 'disabled',
            if (anchorState?.isHovering ?? false) 'hover',
            if (anchorState?.isFocused ?? false) 'focus',
          };

          // Parse styles with current states
          final WindStyle styles = className != null
              ? WindParser.parse(className!, innerContext, states: activeStates)
              : const WindStyle();

          // Build content
          Widget content = isLoading ? _buildLoadingContent(styles) : child;

          // Wrap in styled container
          Widget styledButton = Container(
            padding: styles.padding,
            decoration: styles.decoration,
            child: DefaultTextStyle.merge(
              style: styles.toTextStyle(),
              child: content,
            ),
          );

          // Wrap with AbsorbPointer when not interactive
          if (!isInteractive) {
            styledButton = AbsorbPointer(child: styledButton);
          }

          // Add cursor pointer for web/desktop native feel
          styledButton = MouseRegion(
            cursor: isInteractive
                ? SystemMouseCursors.click
                : SystemMouseCursors.forbidden,
            child: styledButton,
          );

          return styledButton;
        },
      ),
    );
  }

  /// Builds the loading content with spinner and optional text.
  Widget _buildLoadingContent(WindStyle styles) {
    if (loadingWidget != null) {
      return loadingWidget!;
    }

    // Determine spinner color
    final Color spinnerColor = loadingColor ?? styles.color ?? Colors.white;

    final Widget spinner = SizedBox(
      width: loadingSize,
      height: loadingSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
      ),
    );

    if (loadingText != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [spinner, const SizedBox(width: 8), Text(loadingText!)],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [spinner],
    );
  }
}
