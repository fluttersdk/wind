import 'package:flutter/widgets.dart';
import '../state/wind_anchor_state.dart';
import '../state/wind_anchor_state_provider.dart';

/// **The Foundational State Wrapper**
///
/// `WAnchor` acts as the "Brain" for interaction state management in Wind.
/// It detects user gestures (Hover, Focus, Press) and propagates that state
/// down to all descendant widgets via `WindAnchorStateProvider`.
///
/// Use `WAnchor` when you want to enable `hover:`, `focus:`, or `disabled:`
/// styling on a `WDiv` or any custom widget.
///
/// ### Supported Features:
/// - **Hover Detection:** Activates `hover:` class prefix
/// - **Focus Management:** Activates `focus:` class prefix
/// - **Gestures:** `onTap`, `onLongPress`, `onDoubleTap`
/// - **Disabling:** `isDisabled` prop prevents all interactions
///
/// ### Example Usage:
///
/// ```dart
/// WAnchor(
///   onTap: () => print('Pressed'),
///   child: WDiv(
///     // Reacts to hover state provided by WAnchor
///     className: 'p-4 bg-white hover:bg-gray-100 transition-colors',
///     child: WText('Hover Me'),
///   ),
/// )
/// ```
@immutable
class WAnchor extends StatefulWidget {
  /// The widget that will receive the hover, focus, and gesture states.
  /// This is the interactive area of the `WAnchor`.
  final Widget child;

  /// An optional callback that is triggered when the widget is tapped.
  ///
  /// This callback is ignored if `isDisabled` is `true`.
  final VoidCallback? onTap;

  /// An optional callback that is triggered when the widget is long-pressed.
  ///
  /// This callback is ignored if `isDisabled` is `true`.
  final VoidCallback? onLongPress;

  /// An optional callback that is triggered when the widget is double-tapped.
  ///
  /// This callback is ignored if `isDisabled` is `true`.
  final VoidCallback? onDoubleTap;

  /// Determines whether the widget is interactive.
  ///
  /// When `true`:
  /// - All gestures (`onTap`, etc.) are ignored.
  /// - Hover and focus states are suppressed.
  /// - The `disabled:` prefix becomes active for descendants.
  final bool isDisabled;

  /// Custom states for dynamic styling.
  ///
  /// These states are propagated to descendants and allow for custom class prefixes.
  ///
  /// Example:
  /// - If `states` contains `'error'`, then `error:border-red-500` will activate.
  /// - If `states` contains `'active'`, then `active:bg-blue-600` will activate.
  final Set<String>? states;

  /// The cursor to use when the mouse pointer is over the widget.
  ///
  /// If not provided, it defaults to `SystemMouseCursors.click` if there are gestures
  /// and the widget is not disabled, otherwise `SystemMouseCursors.basic`.
  final MouseCursor? mouseCursor;

  /// An explicit accessible label for the button Semantics node.
  ///
  /// When the child carries no readable `Text` for `MergeSemantics` to absorb
  /// (an icon-only anchor, for example), set this so screen readers and
  /// Playwright `getByRole('button', { name: ... })` can resolve the control.
  /// When null, the label falls back to the merged descendant text.
  ///
  /// Setting this excludes the entire descendant subtree from semantics
  /// (`excludeSemantics: true`), so the label overrides any child text rather
  /// than concatenating with it. Do not set it on an anchor that wraps its own
  /// interactive descendant (a nested field or sub-button): that descendant's
  /// Semantics node would be suppressed.
  final String? semanticLabel;

  /// Creates a `WAnchor` widget.
  ///
  /// The [child] argument is required and represents the interactive area.
  /// By default, the widget is enabled ([isDisabled] is `false`).
  const WAnchor({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.isDisabled = false,
    this.states,
    this.mouseCursor,
    this.semanticLabel,
  });

  @override
  State<WAnchor> createState() => _WAnchorState();
}

/// The state for the [WAnchor] widget.
///
/// This class manages the internal state for `isHovering` and `isFocused`,
/// and handles the logic for updating these states based on user interaction.
class _WAnchorState extends State<WAnchor> {
  bool _isHovering = false;
  bool _isFocused = false;
  bool _hasPrimaryFocus = false;
  final FocusNode _focusNode = FocusNode();

  /// The keyboard and remote-control half of [WAnchor.onTap].
  ///
  /// `WidgetsApp` binds `enter`, `numpadEnter`, `space`, `gameButtonA` and
  /// `select` to [ActivateIntent], and `select` is the D-pad centre key on
  /// Android TV, so answering the intent answers every one of those keys at
  /// once. Nothing here reads a [LogicalKeyboardKey]: a `WAnchor` that matched
  /// keys itself would have to be taught each new one, and would diverge from
  /// whatever the platform decides activation means.
  ///
  /// Built once and reused, which is what [ButtonStyleButton] does through
  /// `InkWell` (`material/ink_well.dart`). A map rebuilt every frame gives
  /// `Actions` a new [Action] instance each time and defeats its own caching.
  late final Map<Type, Action<Intent>> _actions = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _activate),
    ButtonActivateIntent:
        CallbackAction<ButtonActivateIntent>(onInvoke: _activate),
  };

  /// Runs the primary action, which is [WAnchor.onTap] and only that.
  ///
  /// `onLongPress` and `onDoubleTap` get no binding. [ActivateIntent] means
  /// "the primary action" and there is no second key for a secondary one;
  /// inventing one would diverge from every button Flutter ships.
  ///
  /// No disabled check here, and its absence is deliberate: the map is not
  /// installed at all unless there is an enabled `onTap`. An early return would
  /// have looked equivalent and is not, because the action would still report
  /// itself enabled and the key would stop here instead of travelling on.
  Object? _activate(Intent intent) {
    widget.onTap!.call();

    return null;
  }

  /// Initializes the state and adds a listener to the `FocusNode` to track focus changes.
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant WAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDisabled && !oldWidget.isDisabled) {
      _isHovering = false;
    }
  }

  /// Cleans up the `FocusNode` and its listener to prevent memory leaks.
  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  /// Called when the focus state of the `FocusNode` changes.
  ///
  /// Updates the `_isFocused` state via `setState` if the widget is not disabled,
  /// which triggers a rebuild to propagate the new state.
  void _onFocusChange() {
    if (widget.isDisabled) return;

    // Two signals, not one. `hasFocus` is focus-WITHIN and is what draws a ring
    // around a text field's container; `hasPrimaryFocus` is this node itself
    // and is the only one a styling wrapper may inherit. Conflating them lit
    // the ring on a sibling of the field the user was typing in.
    if (_focusNode.hasFocus != _isFocused ||
        _focusNode.hasPrimaryFocus != _hasPrimaryFocus) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        _hasPrimaryFocus = _focusNode.hasPrimaryFocus;
      });
    }
  }

  /// Called when the mouse pointer enters or exits the `MouseRegion`.
  ///
  /// Updates the `_isHovering` state via `setState` if the widget is not disabled,
  /// which triggers a rebuild to propagate the new state.
  void _onHover(bool isHovering) {
    if (widget.isDisabled) return;
    if (isHovering != _isHovering) {
      if (mounted) {
        setState(() {
          _isHovering = isHovering;
        });
      }
    }
  }

  /// Builds the widget tree for `WAnchor`.
  ///
  /// This method constructs a `WindPressableState` from the current internal
  /// state (`_isHovering`, `_isFocused`, `widget.isDisabled`) and provides it
  /// to the widget's descendants using `WindStateProvider`.
  ///
  /// It wraps the `child` in a `MouseRegion` for hover detection and a
  /// `GestureDetector` for tap events, disabling them if `widget.isDisabled` is true.
  @override
  Widget build(BuildContext context) {
    final hasGestures = widget.onTap != null ||
        widget.onLongPress != null ||
        widget.onDoubleTap != null;

    // A gestureless anchor is a styling wrapper, so it inherits the interaction
    // it cannot originate rather than competing for it.
    //
    // `WDiv` auto-wraps itself in one of these whenever its className carries
    // `hover:`, `focus:` or `active:` (see `w_div.dart`'s `isInteractive`
    // branch), and `WDiv` reads its state from the NEAREST provider. So before
    // this inheritance, the wrapper published `isFocused: false` over a focused
    // ancestor and `isDisabled: false` over a disabled one, and the element
    // carrying `focus:ring-2` was the one element that could not see the focus.
    //
    // Only the ancestor's PRIMARY focus is inherited, never its focus-within.
    // A tappable card containing a text field reports focus-within while the
    // user types, so inheriting that lit the ring on every styling wrapper
    // under the card, including one sitting beside the field. The wrapper's own
    // `_isFocused` already covers the case that matters in the other direction:
    // a ring-styled div CONTAINING the focused input lights through its own
    // node, because `hasFocus` covers descendants.
    //
    // Hover is not inherited at all. It is a pointer position, and two siblings
    // inside one anchor legitimately highlight independently.
    final WindAnchorState? inherited =
        hasGestures ? null : WindAnchorStateProvider.of(context);

    // `hasPrimaryFocus` is republished with the inherited value ORed in, so the
    // signal passes THROUGH a wrapper rather than stopping at it. A wrapper's
    // own node never holds primary focus (it cannot request focus at all), so
    // publishing only `_hasPrimaryFocus` killed the chain after one hop and a
    // ring two wrappers deep stayed dark. Any `hover:` or `active:` class on an
    // intermediate div is enough to create that second wrapper.
    //
    // Chaining does not reopen the sibling leak, because what chains is the
    // ancestor's PRIMARY focus: a wrapper only ever inherits from a wrapper
    // that is itself decoration of the primary-focused node.
    final currentState = WindAnchorState(
      isHovering: _isHovering,
      isFocused: _isFocused || (inherited?.hasPrimaryFocus ?? false),
      hasPrimaryFocus:
          _hasPrimaryFocus || (inherited?.hasPrimaryFocus ?? false),
      isDisabled: widget.isDisabled || (inherited?.isDisabled ?? false),
      customStates: widget.states,
    );

    // Focus is always present, needed for focus: class prefix to work.
    //
    // A gestureless wrapper keeps the node but stops competing for it. It is
    // not a traversal stop, because one control has to cost one press of the
    // remote: before this, `WAnchor(onTap:) > WDiv('focus:ring-2')` cost two,
    // and the ring was on the second one while the gesture was on the first.
    // The node itself stays, because `FocusNode.hasFocus` covers descendants
    // and that is what draws the ring around a `WInput` inside a styled div.
    Widget innerChild = Focus(
      focusNode: _focusNode,
      canRequestFocus: !widget.isDisabled && (hasGestures || inherited == null),
      child: widget.child,
    );

    // The action map goes on only where there is a primary action to run, and
    // that is narrower than `hasGestures` on purpose.
    //
    // A `CallbackAction` is always enabled, and `ShortcutManager` reports a key
    // HANDLED for any enabled action whether or not the callback did anything.
    // So an anchor carrying only `onLongPress`, or one that is disabled, used to
    // swallow the activation key belonging to the tappable row around it. On
    // web it swallowed a scroll too: `Space` maps to
    // `PrioritizedIntents([ActivateIntent, ScrollIntent])`, and an
    // always-enabled action wins that race.
    if (widget.onTap != null && !widget.isDisabled) {
      innerChild = Actions(actions: _actions, child: innerChild);
    }

    // Only wrap with GestureDetector if there are actual gesture callbacks
    if (hasGestures) {
      innerChild = GestureDetector(
        // Translucent so the whole anchor bounds are tappable, not only the
        // opaque descendants. The GestureDetector defaults to
        // `HitTestBehavior.deferToChild`, which only receives a pointer when a
        // painted child sits under it; an anchor wrapping transparent content
        // (a settings row with text on one side, a link, an icon row) then
        // ignored taps that landed on its empty regions. Real users tapping the
        // blank part of a row, and every centre-of-element tap from a driver
        // (dusk / Playwright), silently did nothing. Translucent matches the
        // whole-box tap target WInput and WPopover already use.
        behavior: HitTestBehavior.translucent,
        onTap: widget.isDisabled ? null : widget.onTap,
        onLongPress: widget.isDisabled ? null : widget.onLongPress,
        onDoubleTap: widget.isDisabled ? null : widget.onDoubleTap,
        child: innerChild,
      );
    }

    // Accessibility: surface this anchor as a `button` in the Flutter
    // Semantics tree so Playwright `getByRole('button', { name: ... })`
    // resolves on the Flutter web build. We rely on `MergeSemantics` to
    // collapse descendant Text/WText nodes into this single Semantics node so
    // the merged label exposes the caller-supplied child text. This avoids
    // the structural problem of WAnchor not knowing its eventual textual
    // content when callers (e.g. WButton) interpose a Builder between
    // WAnchor and its leaf widgets.
    Widget result = WindAnchorStateProvider(
      state: currentState,
      child: MouseRegion(
        cursor: widget.mouseCursor ??
            (widget.isDisabled
                ? SystemMouseCursors.basic
                : hasGestures
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic),
        onEnter: widget.isDisabled ? null : (_) => _onHover(true),
        onExit: widget.isDisabled ? null : (_) => _onHover(false),
        child: innerChild,
      ),
    );

    // Accessibility branch selection.
    //
    // 1. Explicit label: emit the label on the Semantics node and exclude the
    //    descendant subtree so the child Text does not merge in and double the
    //    name ("Save\nSave"). Because `excludeSemantics: true` drops the
    //    descendant GestureDetector's tap SemanticsAction, the activation
    //    actions are lifted onto this same node so assistive technology can
    //    still trigger them. `onDoubleTap` has no SemanticsAction equivalent
    //    and is intentionally not exposed here.
    if (widget.semanticLabel != null) {
      return Semantics(
        button: true,
        enabled: !widget.isDisabled,
        label: widget.semanticLabel,
        onTap: widget.isDisabled ? null : widget.onTap,
        onLongPress: widget.isDisabled ? null : widget.onLongPress,
        excludeSemantics: true,
        child: result,
      );
    }

    // 2. No gestures and no explicit label: publish nothing of our own and let
    //    the child's descendants speak for themselves.
    //
    //    `WDiv` auto-wraps itself in a gestureless `WAnchor` whenever its
    //    className carries `hover:`, `focus:` or `active:`, purely to get the
    //    hover and focus state this widget tracks (see `w_div.dart`'s
    //    `isInteractive` branch). Announcing that as a button made a claim the
    //    widget cannot keep: `WDiv(className: 'hover:bg-slate-100', child:
    //    WText('Latency'))` published a button node labelled "Latency" whose
    //    action set was `focus` alone, with no `tap`, so a screen reader offered
    //    a control that does nothing when activated. The real tap surface still
    //    reaches this method with its gestures and keeps its single button node.
    //
    //    Note for anyone re-measuring: the nesting `WAnchor(onTap:) >
    //    WDiv(hover:...)` did NOT announce twice, though it did put two button
    //    nodes in the widget tree. The inner one carried `isMergedIntoParent`,
    //    so it was folded into the real tap surface and never sent to the
    //    platform. Count platform nodes, not tree nodes.
    //
    //    `MergeSemantics` goes with the role, and the measurement is why. Keeping
    //    it made a gestureless wrapper ABSORB a descendant control's role and
    //    actions: a locked region tile in a consumer app, whose own anchor has no
    //    gesture, swallowed the display-only `WCheckbox` inside it and published
    //    itself as "US West, button" with the checkbox's tap. That is the same
    //    bogus claim in a new place. A styling-only wrapper publishes nothing and
    //    lets each descendant speak for itself.
    if (!hasGestures) {
      return result;
    }

    // 3. Gestures, no explicit label: keep the MergeSemantics path so the
    //    descendant Text/WText nodes collapse into this node and supply the
    //    name.
    return MergeSemantics(
      child: Semantics(
        button: true,
        enabled: !widget.isDisabled,
        child: result,
      ),
    );
  }
}
