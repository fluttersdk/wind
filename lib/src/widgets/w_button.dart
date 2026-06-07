import 'package:flutter/material.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../state/wind_anchor_state_provider.dart';
import 'w_anchor.dart';
import 'w_div.dart';
import 'w_text.dart';

/// **The Utility-First Button Component**
///
/// `WButton` is a button widget that combines `WAnchor` state management
/// with Tailwind-like utility class styling and built-in loading states.
///
/// ### Supported Features:
/// - **States:** `hover:bg-blue-700`, `focus:ring-2`, `disabled:opacity-50`
/// - **Loading:** Built-in spinner, `loading:text-transparent`
/// - **Interactvity:** `onTap`, `onDoubleTap`, `onLongPress`
/// - **Styling:** `bg-blue-500`, `text-white`, `rounded`, `shadow`
///
/// ### Example Usage:
///
/// ```dart
/// WButton(
///   onTap: () => print('Clicked!'),
///   className: 'bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition-colors',
///   child: Text('Click me'),
/// )
/// ```
///
/// ### Loading State Example:
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
///
/// See also:
///
///  * [WAnchor], which `WButton` delegates all state management and interaction handling to.
///  * [WInput], which pairs with `WButton` in form submission flows.
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
  /// **Effects:**
  /// - Disables user interaction (`onTap` will not fire).
  /// - Replaces or overlays content with a loading spinner.
  /// - Activates the `loading:` prefix for styling (e.g., `loading:opacity-50`).
  final bool isLoading;

  /// Whether the button is disabled.
  ///
  /// **Effects:**
  /// - Disables user interaction.
  /// - Activates the `disabled:` prefix for styling (e.g., `disabled:bg-gray-300`).
  /// - Changes cursor to `forbidden` (desktop/web).
  final bool disabled;

  /// Tailwind-like utility classes for styling.
  ///
  /// Supports special states:
  /// - **Hover:** `hover:bg-blue-700`
  /// - **Focus:** `focus:ring-2 focus:ring-blue-500`
  /// - **Disabled:** `disabled:bg-gray-300 disabled:cursor-not-allowed`
  /// - **Loading:** `loading:opacity-75`
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

  /// An explicit accessible label for the button.
  ///
  /// Required in practice for icon-only buttons, where there is no text child
  /// for the Semantics tree to absorb. Forwarded to [WAnchor.semanticLabel].
  final String? semanticLabel;

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
    this.semanticLabel,
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
      semanticLabel: semanticLabel,
      mouseCursor: isInteractive
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
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

          // Determine alignment for content
          // justify-center in flex maps to centered content
          Alignment? containerAlignment;
          if (styles.mainAxisAlignment == MainAxisAlignment.center) {
            containerAlignment = Alignment.center;
          } else if (styles.alignment != null) {
            containerAlignment = styles.alignment;
          }

          // Wrap in styled container
          Widget styledButton = Container(
            width: styles.widthFactor != null ? double.infinity : styles.width,
            height:
                styles.heightFactor != null ? double.infinity : styles.height,
            constraints: styles.constraints,
            padding: styles.padding,
            decoration: styles.decoration,
            alignment: containerAlignment,
            child: DefaultTextStyle.merge(
              style: styles.toTextStyle(),
              child: content,
            ),
          );

          // Wrap with AbsorbPointer when not interactive
          if (!isInteractive) {
            styledButton = AbsorbPointer(child: styledButton);
          }

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

    // Determine spinner color:
    // 1. Explicit loadingColor takes priority.
    // 2. Text color from className (styles.color).
    // 3. Contrast color based on background — prevents invisible spinners
    //    (e.g., white spinner on white button).
    // 4. Final fallback: white.
    final Color spinnerColor =
        loadingColor ?? styles.color ?? _contrastColor(styles);

    final Widget spinner = SizedBox(
      width: loadingSize,
      height: loadingSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
      ),
    );

    if (loadingText != null) {
      return WDiv(
        className: 'flex items-center justify-center gap-2',
        children: [spinner, WText(loadingText!)],
      );
    }

    return WDiv(
      className: 'flex items-center justify-center',
      children: [spinner],
    );
  }

  /// Returns a contrasting spinner color based on background luminance.
  ///
  /// If the background is light (luminance > 0.5), returns a dark color.
  /// Otherwise returns white — matching the common pattern of light text
  /// on dark buttons.
  Color _contrastColor(WindStyle styles) {
    final Color? bgColor = styles.decoration?.color;
    if (bgColor == null) return Colors.white;

    // Use W3C relative luminance to determine if background is light.
    return bgColor.computeLuminance() > 0.5
        ? const Color(0xFF1E293B) // slate-800 — readable on light bg
        : Colors.white;
  }
}
