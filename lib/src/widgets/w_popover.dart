import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../parser/wind_parser.dart';
import '../utils/wind_logger.dart';
import 'w_div.dart';

/// **Popover Alignment Options**
///
/// Determines where the popover content is positioned relative to the trigger.
enum PopoverAlignment {
  /// Below trigger, aligned to left edge
  bottomLeft,

  /// Below trigger, aligned to right edge
  bottomRight,

  /// Below trigger, centered
  bottomCenter,

  /// Above trigger, aligned to left edge
  topLeft,

  /// Above trigger, aligned to right edge
  topRight,

  /// Above trigger, centered
  topCenter,
}

/// Builder for the trigger widget.
///
/// - [isOpen]: Whether the popover is currently open
/// - [isHovering]: Whether the mouse is hovering over the trigger
typedef PopoverTriggerBuilder = Widget Function(
    BuildContext context, bool isOpen, bool isHovering);

/// Builder for the popover content.
///
/// - [close]: Callback to programmatically close the popover
typedef PopoverContentBuilder = Widget Function(
    BuildContext context, VoidCallback close);

/// Computes effective alignment by flipping when overflow would occur.
///
/// Returns [requested] alignment if it fits, or a flipped variant if
/// overflow detected.
PopoverAlignment computeEffectiveAlignment({
  required PopoverAlignment requested,
  required Offset triggerPosition,
  required Size triggerSize,
  required Size popoverSize,
  required Size screenSize,
  required Offset offset,
}) {
  return _WPopoverState.computeEffectiveAlignment(
    requested: requested,
    triggerPosition: triggerPosition,
    triggerSize: triggerSize,
    popoverSize: popoverSize,
    screenSize: screenSize,
    offset: offset,
  );
}

/// Controller for programmatic popover control
class PopoverController extends ChangeNotifier {
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  void show() {
    if (!_isOpen) {
      _isOpen = true;
      notifyListeners();
    }
  }

  void hide() {
    if (_isOpen) {
      _isOpen = false;
      notifyListeners();
    }
  }

  void toggle() {
    _isOpen = !_isOpen;
    notifyListeners();
  }
}

/// **WPopover - Flexible Popover Component**
///
/// A utility-first popover component for creating dropdown menus,
/// notification panels, user menus, tooltips, and similar overlay patterns.
///
/// Uses Wind UI `className` for styling - supports all Wind utility classes.
/// If no width specified in `className`, uses trigger width as minimum.
///
/// ### Example Usage:
///
/// ```dart
/// WPopover(
///   alignment: PopoverAlignment.bottomRight,
///   className: 'w-80 bg-white dark:bg-gray-800 rounded-xl shadow-xl',
///   triggerBuilder: (context, isOpen, isHovering) => WButton(
///     onTap: null, // Popover handles tap
///     child: Text('Open Menu'),
///   ),
///   contentBuilder: (context, close) => Column(
///     children: [
///       ListTile(title: Text('Option 1'), onTap: close),
///       ListTile(title: Text('Option 2'), onTap: close),
///     ],
///   ),
/// )
/// ```
class WPopover extends StatefulWidget {
  /// Builder for the trigger widget that opens/closes the popover.
  ///
  /// Receives:
  /// - [isOpen]: Current open state
  /// - [isHovering]: Mouse hover state (for styling)
  final PopoverTriggerBuilder triggerBuilder;

  /// Builder for the popover content.
  ///
  /// Receives a [close] callback to programmatically close the popover.
  final PopoverContentBuilder contentBuilder;

  /// Optional controller for programmatic control.
  final PopoverController? controller;

  /// Whether tapping the trigger toggles the popover.
  ///
  /// Default: `true`. Set to `false` for manual control (e.g. text inputs).
  ///
  /// When `true` and the trigger is an interactive widget that owns its own
  /// `onTap` (a `WButton` or `WAnchor`), the trigger's callback and the popover
  /// toggle both fire on the same tap. Use a non-interactive trigger (a plain
  /// `WDiv`) or a null/empty `onTap` for a pure popover trigger.
  final bool enableTriggerOnTap;

  /// Where to position the popover relative to the trigger.
  ///
  /// Default: [PopoverAlignment.bottomLeft]
  final PopoverAlignment alignment;

  /// Wind utility classes for popover container styling.
  ///
  /// Supports:
  /// - **Sizing:** `w-80`, `w-64`, `max-w-sm`
  /// - **Background:** `bg-white`, `dark:bg-gray-800`
  /// - **Border:** `border`, `rounded-xl`
  /// - **Shadow:** `shadow-xl`
  /// - **Padding:** `p-2`, `p-4`
  ///
  /// If no width specified, uses trigger width as minimum.
  final String? className;

  /// Gap between trigger and popover.
  ///
  /// Default: `Offset(0, 4)` (4px gap below trigger)
  final Offset offset;

  /// Maximum height for the popover content.
  ///
  /// Content will scroll if it exceeds this height.
  /// Default: `400`
  final double maxHeight;

  /// Fixed width for the popover overlay.
  ///
  /// When set, the overlay is pinned to exactly this width (like [WSelect]'s
  /// `menuWidth`). Takes precedence over a `w-*` token in [className]. When
  /// null, the overlay sizes between the trigger width (its minimum) and
  /// [maxWidth].
  final double? width;

  /// Upper bound for the popover overlay width.
  ///
  /// Without this, the overlay could stretch to the full screen width and
  /// overflow a narrow content column. Falls back to a `max-w-*` token in
  /// [className], then to the screen width so the overlay never overflows the
  /// viewport. Ignored when [width] (or a `w-*` token) pins a fixed width.
  final double? maxWidth;

  /// Whether the popover is disabled.
  ///
  /// When true, the trigger will not respond to taps.
  final bool disabled;

  /// Whether tapping inside the content closes the popover.
  ///
  /// Default: `false`
  /// Set to `true` for simple menus where any tap should close.
  final bool closeOnContentTap;

  /// Callback when popover opens
  final VoidCallback? onOpen;

  /// Callback when popover closes
  final VoidCallback? onClose;

  /// Whether to automatically flip alignment when overflow would occur.
  ///
  /// When true, WPopover calculates optimal direction BEFORE opening the overlay,
  /// preventing the popover from appearing off-screen.
  ///
  /// Default: `true`
  final bool autoFlip;

  /// Creates a new [WPopover] instance.
  const WPopover({
    super.key,
    required this.triggerBuilder,
    required this.contentBuilder,
    this.controller,
    this.enableTriggerOnTap = true,
    this.alignment = PopoverAlignment.bottomLeft,
    this.className,
    this.offset = const Offset(0, 4),
    this.maxHeight = 400,
    this.width,
    this.maxWidth,
    this.disabled = false,
    this.closeOnContentTap = false,
    this.onOpen,
    this.onClose,
    this.autoFlip = true,
  });

  @override
  State<WPopover> createState() => _WPopoverState();
}

class _WPopoverState extends State<WPopover> {
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _overlayController = OverlayPortalController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _triggerKey = GlobalKey();

  /// Unique group ID for TapRegion to link trigger and overlay
  late final Object _tapRegionGroupId = Object();

  bool _isOpen = false;
  bool _isHovering = false;

  /// Suppresses the first outside-tap dismiss after the popover opens.
  ///
  /// The opening tap is a single physical gesture: the pointer-down toggles
  /// the popover open (via [Listener]), the overlay mounts and registers its
  /// [TapRegion] mid-gesture, then the matching pointer-up is reported to that
  /// freshly mounted region as an "outside" tap and would dismiss the popover
  /// on the very frame it opened. This flag swallows exactly that one event.
  /// It is armed on [open] and disarmed one frame later, so a genuine,
  /// separate outside tap on a later frame still closes the popover.
  bool _suppressNextTapOutside = false;

  /// Pre-calculated effective alignment (computed before opening).
  PopoverAlignment? _effectiveAlignment;

  /// Computes effective alignment by flipping when overflow would occur.
  ///
  /// Returns [requested] alignment if it fits, or a flipped variant if
  /// overflow detected.
  static PopoverAlignment computeEffectiveAlignment({
    required PopoverAlignment requested,
    required Offset triggerPosition,
    required Size triggerSize,
    required Size popoverSize,
    required Size screenSize,
    required Offset offset,
  }) {
    PopoverAlignment effective = requested;

    final bool isRight = effective == PopoverAlignment.bottomRight ||
        effective == PopoverAlignment.topRight;
    final bool isLeft = effective == PopoverAlignment.bottomLeft ||
        effective == PopoverAlignment.topLeft;

    if (isRight) {
      final double leftEdge = triggerPosition.dx +
          triggerSize.width -
          popoverSize.width +
          offset.dx;
      if (leftEdge < 0) {
        effective = effective == PopoverAlignment.bottomRight
            ? PopoverAlignment.bottomLeft
            : PopoverAlignment.topLeft;
      }
    } else if (isLeft) {
      final double rightEdge =
          triggerPosition.dx + popoverSize.width + offset.dx;
      if (rightEdge > screenSize.width) {
        effective = effective == PopoverAlignment.bottomLeft
            ? PopoverAlignment.bottomRight
            : PopoverAlignment.topRight;
      }
    }

    final bool isBottom = effective == PopoverAlignment.bottomLeft ||
        effective == PopoverAlignment.bottomCenter ||
        effective == PopoverAlignment.bottomRight;
    final bool isTop = effective == PopoverAlignment.topLeft ||
        effective == PopoverAlignment.topCenter ||
        effective == PopoverAlignment.topRight;

    // Calculate available space in both directions
    final double spaceBelow =
        screenSize.height - triggerPosition.dy - triggerSize.height - offset.dy;
    final double spaceAbove = triggerPosition.dy - offset.dy;

    if (isBottom) {
      final double bottomEdge = triggerPosition.dy +
          triggerSize.height +
          offset.dy +
          popoverSize.height;
      // Only flip to top if bottom overflows AND top has more space
      if (bottomEdge > screenSize.height && spaceAbove > spaceBelow) {
        effective = switch (effective) {
          PopoverAlignment.bottomLeft => PopoverAlignment.topLeft,
          PopoverAlignment.bottomCenter => PopoverAlignment.topCenter,
          PopoverAlignment.bottomRight => PopoverAlignment.topRight,
          _ => effective,
        };
      }
    } else if (isTop) {
      final double topEdge =
          triggerPosition.dy - offset.dy - popoverSize.height;
      // Only flip to bottom if top overflows AND bottom has more space
      if (topEdge < 0 && spaceBelow > spaceAbove) {
        effective = switch (effective) {
          PopoverAlignment.topLeft => PopoverAlignment.bottomLeft,
          PopoverAlignment.topCenter => PopoverAlignment.bottomCenter,
          PopoverAlignment.topRight => PopoverAlignment.bottomRight,
          _ => effective,
        };
      }
    }

    return effective;
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller?.addListener(_handleControllerChange);
  }

  @override
  void didUpdateWidget(WPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      widget.controller?.addListener(_handleControllerChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller?.removeListener(_handleControllerChange);
    super.dispose();
  }

  void _handleControllerChange() {
    if (widget.controller == null) return;
    if (widget.controller!.isOpen != _isOpen) {
      if (widget.controller!.isOpen) {
        open();
      } else {
        close();
      }
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isOpen) {
      close();
    }
  }

  /// Toggle the popover open/closed state.
  void toggle() {
    if (widget.disabled) return;
    if (_isOpen) {
      close();
    } else {
      open();
    }
  }

  void open() {
    if (_isOpen || widget.disabled) return;

    // Arm the dismiss guard so the opening gesture's own pointer-up cannot
    // immediately dismiss the popover via the freshly mounted overlay's
    // onTapOutside. Disarm one frame later so a later, separate outside tap
    // still closes the popover.
    _suppressNextTapOutside = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _suppressNextTapOutside = false;
    });

    // Calculate effective alignment BEFORE showing overlay
    if (widget.autoFlip) {
      _calculateEffectiveAlignment();
    } else {
      _effectiveAlignment = widget.alignment;
    }

    setState(() {
      _isOpen = true;
      _overlayController.show();
      widget.onOpen?.call();
      // Sync controller if exists and not already synced
      if (widget.controller != null && !widget.controller!.isOpen) {
        widget.controller!.show();
      }
    });
  }

  /// Calculate effective alignment before opening based on available space.
  void _calculateEffectiveAlignment() {
    final RenderBox? triggerBox =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (triggerBox != null && triggerBox.hasSize) {
      final triggerPosition = triggerBox.localToGlobal(Offset.zero);
      final screenSize = MediaQuery.of(context).size;

      // Parse width from className if available
      double popoverWidth = triggerBox.size.width;
      if (widget.className != null) {
        final styles = WindParser.parse(widget.className!, context);
        if (styles.width != null) {
          popoverWidth = styles.width!;
        }
      }

      final double popoverHeight = widget.maxHeight;

      _effectiveAlignment = computeEffectiveAlignment(
        requested: widget.alignment,
        triggerPosition: triggerPosition,
        triggerSize: triggerBox.size,
        popoverSize: Size(popoverWidth, popoverHeight),
        screenSize: screenSize,
        offset: widget.offset,
      );
    } else {
      _effectiveAlignment = widget.alignment;
    }
  }

  /// Handles an outside tap reported by the overlay's [TapRegion].
  ///
  /// Swallows the first event after opening (the opening gesture's own
  /// pointer-up); any later outside tap dismisses the popover normally.
  void _handleTapOutside() {
    if (_suppressNextTapOutside) {
      // Fires only in the live engine, where the opening pointer reaches the
      // freshly mounted overlay within the same frame. flutter_test mounts the
      // overlay and runs the post-frame disarm in one pump, leaving no window
      // where the overlay is mounted and this flag is still armed, so this
      // branch is unreachable from the test binding (the disarm and close
      // paths are covered).
      _suppressNextTapOutside = false; // coverage:ignore-line
      return;
    }
    close();
  }

  /// Close the popover.
  void close() {
    if (!_isOpen) return;
    _suppressNextTapOutside = false;
    setState(() {
      _isOpen = false;
      _overlayController.hide();
      widget.onClose?.call();
      // Sync controller if exists and not already synced
      if (widget.controller != null && widget.controller!.isOpen) {
        widget.controller!.hide();
      }
    });
  }

  Alignment _targetAnchorFor(PopoverAlignment alignment) {
    return switch (alignment) {
      PopoverAlignment.bottomLeft => Alignment.bottomLeft,
      PopoverAlignment.bottomRight => Alignment.bottomRight,
      PopoverAlignment.bottomCenter => Alignment.bottomCenter,
      PopoverAlignment.topLeft => Alignment.topLeft,
      PopoverAlignment.topRight => Alignment.topRight,
      PopoverAlignment.topCenter => Alignment.topCenter,
    };
  }

  Alignment _followerAnchorFor(PopoverAlignment alignment) {
    return switch (alignment) {
      PopoverAlignment.bottomLeft => Alignment.topLeft,
      PopoverAlignment.bottomRight => Alignment.topRight,
      PopoverAlignment.bottomCenter => Alignment.topCenter,
      PopoverAlignment.topLeft => Alignment.bottomLeft,
      PopoverAlignment.topRight => Alignment.bottomRight,
      PopoverAlignment.topCenter => Alignment.bottomCenter,
    };
  }

  Alignment _overlayAlignmentFor(PopoverAlignment alignment) {
    return switch (alignment) {
      PopoverAlignment.bottomLeft => Alignment.topLeft,
      PopoverAlignment.bottomRight => Alignment.topRight,
      PopoverAlignment.bottomCenter => Alignment.topCenter,
      PopoverAlignment.topLeft => Alignment.bottomLeft,
      PopoverAlignment.topRight => Alignment.bottomRight,
      PopoverAlignment.topCenter => Alignment.bottomCenter,
    };
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: _buildOverlay,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Focus(
          focusNode: _focusNode,
          child: TapRegion(
            groupId: _tapRegionGroupId,
            child: KeyedSubtree(
              key: _triggerKey,
              child: _buildTrigger(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrigger(BuildContext context) {
    final trigger = MouseRegion(
      onEnter: (_) {
        // Defer setState to avoid conflicts with mouse tracker updates
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_isHovering) {
            setState(() => _isHovering = true);
          }
        });
      },
      onExit: (_) {
        // Defer setState to avoid conflicts with mouse tracker updates
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isHovering) {
            setState(() => _isHovering = false);
          }
        });
      },
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: widget.triggerBuilder(context, _isOpen, _isHovering),
    );

    if (widget.enableTriggerOnTap) {
      // Toggle through a Listener (pointer events) rather than a
      // GestureDetector (tap arena). An interactive trigger such as
      // WButton/WAnchor owns its own GestureDetector and wins the tap arena,
      // so an outer onTap would never fire and the popover would never open.
      // Pointer events bypass the arena entirely, so opening works regardless
      // of the trigger's interactivity. Filter to the primary button so a
      // secondary (right) click does not toggle. `toggle` already guards
      // `disabled`.
      //
      // A Listener is pointer-only and invisible to assistive technologies, so
      // wrap it in Semantics with a tap action: screen readers and keyboard
      // activation reach `toggle` through the semantic action while pointer
      // input reaches it through the Listener.
      return Semantics(
        button: true,
        enabled: !widget.disabled,
        onTap: widget.disabled ? null : toggle,
        child: Listener(
          onPointerDown: (event) {
            if (event.buttons == kPrimaryButton) toggle();
          },
          child: trigger,
        ),
      );
    }

    return trigger;
  }

  Widget _buildOverlay(BuildContext context) {
    // Get trigger width for fallback - safely check if hasSize
    final RenderBox? triggerBox =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final double triggerWidth = (triggerBox != null && triggerBox.hasSize)
        ? triggerBox.size.width
        : 200;

    // Default className if none provided
    final String effectiveClassName = widget.className ??
        '''
        bg-white dark:bg-gray-800
        border border-gray-200 dark:border-gray-700
        rounded-xl shadow-xl
      ''';

    // Parse styles for width detection
    final styles = WindParser.parse(effectiveClassName, context);

    // Logger integration
    final logger = WindLogger(
      debug: styles.debug,
      widgetName: "WPopover (Overlay)",
    );

    if (styles.debug) {
      logger.logStep("ClassName", "'$effectiveClassName'");
      logger.setCoreWidget("OverlayPortal -> WDiv -> Content");
      logger.printFinalCode();
    }

    // Width resolution (parity with WSelect, which always pins a width):
    // an explicit `width` prop or a `w-*` token fixes the overlay width;
    // otherwise the overlay sizes between the trigger width and an upper bound
    // (`maxWidth` prop, a `max-w-*` token, or the screen width) so a menu can
    // never stretch off-screen the way an unbounded overlay does.
    final double? fixedWidth = widget.width ?? styles.width;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    // A `max-w-*` token surfaces as a finite constraints.maxWidth; an absent one
    // is either null or infinity, both of which fall back to the screen width.
    final double? classMaxWidth =
        (styles.constraints?.maxWidth.isFinite ?? false)
            ? styles.constraints!.maxWidth
            : null;
    final double effectiveMaxWidth =
        widget.maxWidth ?? classMaxWidth ?? screenWidth;

    // Use pre-calculated alignment if available, otherwise calculate now
    PopoverAlignment effectiveAlignment =
        _effectiveAlignment ?? widget.alignment;

    // If autoFlip is enabled and we don't have a pre-calculated alignment,
    // calculate it now (fallback for edge cases)
    if (widget.autoFlip && _effectiveAlignment == null) {
      if (triggerBox != null && triggerBox.hasSize) {
        final Offset triggerPosition = triggerBox.localToGlobal(Offset.zero);
        final Size screenSize = MediaQuery.sizeOf(context);
        // Match the actual overlay constraint: a flexible-width overlay is
        // clamped to effectiveMaxWidth, so feed the clamped width to auto-flip
        // rather than a raw triggerWidth that may exceed the bound (which would
        // overestimate the popover and flip unnecessarily).
        final double popoverWidth = fixedWidth ??
            (triggerWidth > effectiveMaxWidth
                ? effectiveMaxWidth
                : triggerWidth);
        final double popoverHeight = widget.maxHeight;
        effectiveAlignment = computeEffectiveAlignment(
          requested: widget.alignment,
          triggerPosition: triggerPosition,
          triggerSize: triggerBox.size,
          popoverSize: Size(popoverWidth, popoverHeight),
          screenSize: screenSize,
          offset: widget.offset,
        );
      }
    }

    // For top alignments, invert the Y offset
    final bool isTopAlignment =
        effectiveAlignment == PopoverAlignment.topLeft ||
            effectiveAlignment == PopoverAlignment.topCenter ||
            effectiveAlignment == PopoverAlignment.topRight;
    final effectiveOffset = isTopAlignment
        ? Offset(widget.offset.dx, -widget.offset.dy)
        : widget.offset;

    return CompositedTransformFollower(
      link: _layerLink,
      targetAnchor: _targetAnchorFor(effectiveAlignment),
      followerAnchor: _followerAnchorFor(effectiveAlignment),
      offset: effectiveOffset,
      child: Align(
        alignment: _overlayAlignmentFor(effectiveAlignment),
        widthFactor: 1,
        heightFactor: 1,
        child: TapRegion(
          groupId: _tapRegionGroupId,
          onTapOutside: (_) => _handleTapOutside(),
          child: GestureDetector(
            onTap: widget.closeOnContentTap ? close : null,
            behavior: HitTestBehavior.translucent,
            child: Material(
              elevation: 0,
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: fixedWidth != null
                    // Fixed width: pin the overlay exactly (WSelect parity).
                    ? BoxConstraints(
                        maxHeight: widget.maxHeight,
                        minWidth: fixedWidth,
                        maxWidth: fixedWidth,
                      )
                    // Flexible width: at least the trigger width (clamped so it
                    // never exceeds the bound), at most effectiveMaxWidth.
                    : BoxConstraints(
                        maxHeight: widget.maxHeight,
                        minWidth: triggerWidth > effectiveMaxWidth
                            ? effectiveMaxWidth
                            : triggerWidth,
                        maxWidth: effectiveMaxWidth,
                      ),
                child: WDiv(
                  className: effectiveClassName,
                  child: widget.contentBuilder(context, close),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
