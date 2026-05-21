import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../parser/wind_parser.dart';
import 'w_keyboard_platform.dart';

/// A Wind-styled wrapper that adds keyboard actions (Done button, navigation)
/// to input fields, especially for iOS numeric keyboards.
///
/// The widget renders an above-keyboard toolbar in the app's `Overlay` while
/// any of its `focusNodes` holds focus, providing:
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
class WKeyboardActions extends StatefulWidget {
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
  State<WKeyboardActions> createState() => _WKeyboardActionsState();
}

class _WKeyboardActionsState extends State<WKeyboardActions> {
  OverlayEntry? _overlayEntry;
  int? _currentIndex;

  /// Parsed platform gate — derived from widget.platform once in initState.
  late WKeyboardPlatform _platform;

  @override
  void initState() {
    super.initState();
    _platform = _parsePlatform(widget.platform);
    _attachListeners(widget.focusNodes);
  }

  @override
  void didUpdateWidget(WKeyboardActions oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-wire listeners only when the focusNodes list identity changed.
    final changed = widget.focusNodes.length != oldWidget.focusNodes.length ||
        widget.focusNodes
            .asMap()
            .entries
            .any((e) => !identical(e.value, oldWidget.focusNodes[e.key]));

    if (changed) {
      _detachListeners(oldWidget.focusNodes);
      _platform = _parsePlatform(widget.platform);
      _attachListeners(widget.focusNodes);
    }
  }

  @override
  void dispose() {
    _detachListeners(widget.focusNodes);
    _removeOverlay();
    super.dispose();
  }

  // ---- Listener lifecycle ----

  void _attachListeners(List<FocusNode> nodes) {
    for (final node in nodes) {
      node.addListener(_onFocusChange);
    }
  }

  void _detachListeners(List<FocusNode> nodes) {
    for (final node in nodes) {
      node.removeListener(_onFocusChange);
    }
  }

  // ---- Focus handler ----

  void _onFocusChange() {
    if (!mounted) return;

    // Walk the list to find which node is focused.
    int? found;
    for (int i = 0; i < widget.focusNodes.length; i++) {
      if (widget.focusNodes[i].hasFocus) {
        found = i;
        break;
      }
    }

    if (found != null && _platformMatches()) {
      _currentIndex = found;
      _insertOrUpdateOverlay();
    } else {
      _currentIndex = null;
      _removeOverlay();
    }
  }

  // ---- Overlay management ----

  void _insertOrUpdateOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: _buildToolbar);
      Overlay.of(context).insert(_overlayEntry!);
      // 1. Start a per-frame platform guard while the toolbar is active.
      //    The guard fires in the transient-callbacks phase (before build), so
      //    `_overlayEntry.remove()` triggers the Overlay's internal rebuild in
      //    the same frame. This handles the case where defaultTargetPlatform
      //    changes between focus events (e.g. debugDefaultTargetPlatformOverride
      //    in widget tests) where the focus-listener path fires zero
      //    notifications because unfocus() + requestFocus() produces no net
      //    hasFocus change.
      _schedulePlatformGuard();
    } else {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _currentIndex = null;
  }

  /// Schedules a single transient-frame callback that removes the toolbar if
  /// [defaultTargetPlatform] no longer matches [_platform], then re-schedules
  /// itself as long as the overlay remains active.
  ///
  /// Transient callbacks fire BEFORE the build phase, so any [setState] from
  /// [_removeOverlay] takes effect within the same rendered frame — no extra
  /// pump needed.
  void _schedulePlatformGuard() {
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      if (!mounted || _overlayEntry == null) return;
      if (!_platformMatches()) {
        // 2. Platform no longer matches — remove the toolbar in this frame.
        _removeOverlay();
      } else {
        // 3. Platform still valid — reschedule for the next frame.
        _schedulePlatformGuard();
      }
    });
  }

  // ---- Toolbar builder ----

  /// Builds the toolbar widget rendered inside the OverlayEntry.
  ///
  /// The parameter shadows the State's `context` getter; use `this.context` to
  /// reach the State's own context when needed (e.g. for `WindParser`, which
  /// must walk up to `WindTheme` — see `_resolveToolbarColor`).
  Widget _buildToolbar(BuildContext context) {
    final index = _currentIndex;
    if (index == null) return const SizedBox.shrink();

    return Positioned(
      left: 0,
      right: 0,
      bottom: MediaQuery.viewInsetsOf(context).bottom,
      child: Material(
        color: _resolveToolbarColor(context),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            children: [
              if (widget.nextFocus) ...[
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_up),
                  tooltip: 'Previous',
                  onPressed: index > 0
                      ? () => widget.focusNodes[index - 1].requestFocus()
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  tooltip: 'Next',
                  onPressed: index < widget.focusNodes.length - 1
                      ? () => widget.focusNodes[index + 1].requestFocus()
                      : null,
                ),
              ],
              const Spacer(),
              widget.closeWidgetBuilder != null
                  ? widget.closeWidgetBuilder!(widget.focusNodes[index])
                  : TextButton(
                      onPressed: () => widget.focusNodes[index].unfocus(),
                      child: Text(
                        MaterialLocalizations.of(context).okButtonLabel,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Color resolution ----

  /// Resolves the toolbar background color.
  ///
  /// The Material 3 fallback (`surfaceContainerHighest`) reads from the
  /// parameter `context` (the OverlayEntry's build context), which sees
  /// `ThemeData` via the `MaterialApp` ancestor chain. The className path
  /// reads from `this.context` (the State's own context) because
  /// `WindParser` must walk up to `WindTheme`, which is provided BELOW
  /// `MaterialApp` and is therefore NOT visible from the Overlay's context.
  Color? _resolveToolbarColor(BuildContext context) {
    if (widget.toolbarClassName == null || widget.toolbarClassName!.isEmpty) {
      return Theme.of(context).colorScheme.surfaceContainerHighest;
    }

    final styles = WindParser.parse(widget.toolbarClassName!, this.context);

    return styles.decoration?.color;
  }

  // ---- Platform check ----

  /// Returns true when the current runtime platform matches the configured gate.
  bool _platformMatches() {
    return switch (_platform) {
      WKeyboardPlatform.all => true,
      WKeyboardPlatform.ios => defaultTargetPlatform == TargetPlatform.iOS,
      WKeyboardPlatform.android =>
        defaultTargetPlatform == TargetPlatform.android,
    };
  }

  static WKeyboardPlatform _parsePlatform(String value) {
    return switch (value.toLowerCase()) {
      'ios' => WKeyboardPlatform.ios,
      'android' => WKeyboardPlatform.android,
      _ => WKeyboardPlatform.all,
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
