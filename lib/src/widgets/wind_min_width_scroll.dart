import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A mutable carrier for a horizontal scroll viewport's own width, written by
/// [WindViewportWidthProvider] during layout and read by [WindMinWidthBox]. The
/// same instance is shared through [WindMinWidthScrollScope] between the
/// provider (outside the scroll) and a `w-full` child (inside the scroll).
class WindViewportWidthPort {
  /// The most recent viewport width published by the enclosing
  /// [WindViewportWidthProvider]; `null` before the first layout, infinite when
  /// the scroll itself sits in an unbounded-width context.
  double? value;

  final Set<RenderObject> _dependents = <RenderObject>{};

  /// Registers a consumer render object so it is re-laid out when [value]
  /// changes. A `w-full` child inside a horizontal scroll always receives the
  /// same (unbounded-width) constraints, so it would otherwise skip layout and
  /// read a stale viewport width.
  void addDependent(RenderObject dependent) => _dependents.add(dependent);

  /// Unregisters a consumer render object (on detach or a port swap).
  void removeDependent(RenderObject dependent) => _dependents.remove(dependent);

  /// Publishes a new viewport width and marks every registered consumer for
  /// layout when the value actually changed.
  void publish(double newValue) {
    if (newValue == value) return;
    value = newValue;
    for (final dependent in _dependents) {
      dependent.markNeedsLayout();
    }
  }
}

/// Wraps a horizontal `SingleChildScrollView` and publishes the viewport's own
/// (bounded) width through [port] during layout.
///
/// This is the render-side of the "fill on desktop, scroll on narrow" primitive
/// (the shadcn Table pattern): a `w-full` child inside the scroll reads the
/// published width via [WindMinWidthBox] and sizes itself to
/// `max(viewport, min-w-*)`, filling the viewport when it is wide and honoring
/// its min width (so the viewport scrolls) when it is narrow. It is a real
/// [RenderProxyBox], so intrinsic/dry-layout queries delegate to the scroll.
class WindViewportWidthProvider extends SingleChildRenderObjectWidget {
  /// The shared carrier the scroll's `w-full` child reads at layout time.
  final WindViewportWidthPort port;

  const WindViewportWidthProvider({
    super.key,
    required this.port,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderViewportWidthProvider(port);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _RenderViewportWidthProvider).port = port;
  }
}

class _RenderViewportWidthProvider extends RenderProxyBox {
  _RenderViewportWidthProvider(this._port);

  WindViewportWidthPort _port;
  set port(WindViewportWidthPort value) => _port = value;

  @override
  void performLayout() {
    // Publish the viewport's own width BEFORE laying out the scroll (top-down),
    // so a WindMinWidthBox deeper in the scroll content reads a fresh value.
    // `publish` marks the registered box for layout when the width changed (it
    // otherwise skips layout with a stale width, since a horizontal scroll hands
    // its content unchanged unbounded-width constraints). The marking runs
    // inside `invokeLayoutCallback`, the sanctioned hook for dirtying the
    // subtree during layout; intrinsic queries never reach here.
    invokeLayoutCallback<Constraints>((_) {
      _port.publish(constraints.maxWidth);
    });
    super.performLayout();
  }
}

/// Sizes its child to `max(viewportWidth, floorMinWidth)` along the horizontal
/// axis (a tight width, so a flex row with `Expanded` children still lays out).
///
/// This replaces the `SizedBox(width: double.infinity)` a bare `w-full` would
/// otherwise produce, which asserts inside a horizontal scroll's unbounded
/// width. On a wide viewport the child fills the viewport (no scrolling); on a
/// narrow viewport the child takes [floorMinWidth] (wider than the viewport,
/// so the enclosing scroll scrolls). Intrinsic/dry-layout queries delegate to
/// the child.
class WindMinWidthBox extends SingleChildRenderObjectWidget {
  /// The shared carrier written by the enclosing [WindViewportWidthProvider].
  final WindViewportWidthPort port;

  /// The lower bound on the child's width (from `min-w-[Npx]`); `0` for none.
  final double floorMinWidth;

  const WindMinWidthBox({
    super.key,
    required this.port,
    required this.floorMinWidth,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMinWidthBox(port, floorMinWidth);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _RenderMinWidthBox)
      ..port = port
      ..floorMinWidth = floorMinWidth;
  }
}

class _RenderMinWidthBox extends RenderProxyBox {
  _RenderMinWidthBox(this._port, this._floorMinWidth);

  WindViewportWidthPort _port;
  set port(WindViewportWidthPort value) {
    if (identical(value, _port)) return;
    if (attached) _port.removeDependent(this);
    _port = value;
    if (attached) _port.addDependent(this);
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _port.addDependent(this);
  }

  @override
  void detach() {
    _port.removeDependent(this);
    super.detach();
  }

  double _floorMinWidth;
  set floorMinWidth(double value) {
    if (value == _floorMinWidth) return;
    _floorMinWidth = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    final double? viewport = _port.value;
    if (viewport == null || !viewport.isFinite) {
      // No finite viewport width to fill against (the scroll sits in an
      // unbounded-width context, or the width has not been published yet).
      // Degrade to the child's content width honoring the min-w-* floor,
      // instead of forcing a tight (possibly 0) width that would collapse it.
      // This mirrors how WindCrossStretch / WindFractionBasis pass through on
      // an unbounded axis. The floor is clamped into the INCOMING width range
      // (and the size re-constrained) so the box still respects a finite parent
      // constraint if it is ever laid out outside a scroll.
      final double childMin =
          _floorMinWidth.clamp(constraints.minWidth, constraints.maxWidth);
      child.layout(
        BoxConstraints(
          minWidth: childMin,
          maxWidth: constraints.maxWidth,
          minHeight: constraints.minHeight,
          maxHeight: constraints.maxHeight,
        ),
        parentUsesSize: true,
      );
      size = constraints.constrain(child.size);
      return;
    }
    // Fill the viewport, honoring the min-w-* floor. `target` is clamped into
    // the incoming width range so the tight layout can never exceed a finite
    // parent constraint.
    final double target = math
        .max(viewport, _floorMinWidth)
        .clamp(constraints.minWidth, constraints.maxWidth);
    child.layout(
      BoxConstraints(
        minWidth: target,
        maxWidth: target,
        minHeight: constraints.minHeight,
        maxHeight: constraints.maxHeight,
      ),
      parentUsesSize: true,
    );
    size = constraints.constrain(child.size);
  }
}
