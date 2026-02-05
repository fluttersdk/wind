import 'package:flutter/material.dart';

import '../parser/wind_parser.dart';
import '../utils/wind_logger.dart';
import 'w_div.dart';

/// Popover alignment options.
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
typedef PopoverTriggerBuilder =
    Widget Function(BuildContext context, bool isOpen, bool isHovering);

/// Builder for the popover content.
///
/// - [close]: Callback to programmatically close the popover
typedef PopoverContentBuilder =
    Widget Function(BuildContext context, VoidCallback close);

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
/// ### Basic Usage:
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
    this.disabled = false,
    this.closeOnContentTap = false,
    this.onOpen,
    this.onClose,
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

  /// Close the popover.
  void close() {
    if (!_isOpen) return;
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

  Alignment get _targetAnchor {
    return switch (widget.alignment) {
      PopoverAlignment.bottomLeft => Alignment.bottomLeft,
      PopoverAlignment.bottomRight => Alignment.bottomRight,
      PopoverAlignment.bottomCenter => Alignment.bottomCenter,
      PopoverAlignment.topLeft => Alignment.topLeft,
      PopoverAlignment.topRight => Alignment.topRight,
      PopoverAlignment.topCenter => Alignment.topCenter,
    };
  }

  Alignment get _followerAnchor {
    return switch (widget.alignment) {
      PopoverAlignment.bottomLeft => Alignment.topLeft,
      PopoverAlignment.bottomRight => Alignment.topRight,
      PopoverAlignment.bottomCenter => Alignment.topCenter,
      PopoverAlignment.topLeft => Alignment.bottomLeft,
      PopoverAlignment.topRight => Alignment.bottomRight,
      PopoverAlignment.topCenter => Alignment.bottomCenter,
    };
  }

  Alignment get _overlayAlignment {
    return switch (widget.alignment) {
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
      return GestureDetector(onTap: toggle, child: trigger);
    }

    return trigger;
  }

  Widget _buildOverlay(BuildContext context) {
    // Get trigger width for fallback - safely check if hasSize
    final RenderBox? triggerBox =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final double triggerWidth =
        (triggerBox != null && triggerBox.hasSize) ? triggerBox.size.width : 200;

    // Default className if none provided
    final String effectiveClassName =
        widget.className ??
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

    // Use parsed width or fallback to trigger width
    final double? parsedWidth = styles.width;

    // For top alignments, invert the Y offset
    final bool isTopAlignment =
        widget.alignment == PopoverAlignment.topLeft ||
        widget.alignment == PopoverAlignment.topCenter ||
        widget.alignment == PopoverAlignment.topRight;
    final effectiveOffset = isTopAlignment
        ? Offset(widget.offset.dx, -widget.offset.dy)
        : widget.offset;

    return CompositedTransformFollower(
      link: _layerLink,
      targetAnchor: _targetAnchor,
      followerAnchor: _followerAnchor,
      offset: effectiveOffset,
      child: Align(
        alignment: _overlayAlignment,
        child: TapRegion(
          groupId: _tapRegionGroupId,
          onTapOutside: (_) => close(),
          child: GestureDetector(
            onTap: widget.closeOnContentTap ? close : null,
            behavior: HitTestBehavior.translucent,
            child: Material(
              elevation: 0,
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: widget.maxHeight,
                  // Use trigger width as minimum if no width in className
                  minWidth: parsedWidth ?? triggerWidth,
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
