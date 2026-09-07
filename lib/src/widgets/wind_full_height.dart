import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Fills the incoming height, falling back to [fallbackHeight] when there is
/// none to fill.
///
/// This is what `h-full` composes to. The class exists because the question it
/// answers, "is the incoming height bounded", is only answerable during layout,
/// and the widget-layer way to ask it is a [LayoutBuilder]. A [LayoutBuilder]
/// defers its whole subtree into a second layout pass, and `h-full` is common
/// enough on a scrolling screen for that to show: a consumer measured 1056 of
/// them in one eight-scroll session against 258 widget builds, one per element
/// carrying the class, re-run on every frame.
///
/// A render object reads `constraints` directly, so it needs no deferral and no
/// second pass. It is the same move [WindFractionBasis] and [WindMinWidthBox]
/// already make for their own sizing questions.
///
/// [fallbackHeight] is passed in rather than read here because a render object
/// has no [BuildContext] and so cannot reach [MediaQuery]. The caller reads it
/// during build, which is where that lookup belongs anyway: it registers the
/// dependency, so a rotation or a window resize rebuilds and updates it.
class WindFullHeightBox extends SingleChildRenderObjectWidget {
  /// The height to take when the incoming constraints do not bound one.
  ///
  /// The screen height, in every current caller. A `Column` child and a sliver
  /// both offer an unbounded height, and "as tall as it wants" is not a size,
  /// so `h-full` has to name a number instead.
  final double fallbackHeight;

  /// `1.0` for `w-full`, null to leave the width to the incoming constraints.
  ///
  /// Any fraction, not just 1.0: `w-1/2 h-full` reaches this class with 0.5.
  /// An earlier version of this doc claimed 1.0 was the only value, which the
  /// suite contradicts.
  final double? widthFactor;

  /// `max-w-*`, or null when the class is absent.
  final double? maxWidth;

  /// `max-h-*`, or null when the class is absent.
  final double? maxHeight;

  /// Creates a [WindFullHeightBox].
  const WindFullHeightBox({
    super.key,
    required this.fallbackHeight,
    this.widthFactor,
    this.maxWidth,
    this.maxHeight,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderFullHeight(
        fallbackHeight,
        widthFactor,
        maxWidth,
        maxHeight,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _RenderFullHeight)
      ..fallbackHeight = fallbackHeight
      ..widthFactor = widthFactor
      ..maxWidth = maxWidth
      ..maxHeight = maxHeight;
  }
}

class _RenderFullHeight extends RenderProxyBox {
  _RenderFullHeight(
    this._fallbackHeight,
    this._widthFactor,
    this._maxWidth,
    this._maxHeight,
  );

  double _fallbackHeight;
  set fallbackHeight(double value) {
    if (value == _fallbackHeight) return;
    _fallbackHeight = value;
    markNeedsLayout();
  }

  double? _widthFactor;
  set widthFactor(double? value) {
    if (value == _widthFactor) return;
    _widthFactor = value;
    markNeedsLayout();
  }

  double? _maxWidth;
  set maxWidth(double? value) {
    if (value == _maxWidth) return;
    _maxWidth = value;
    markNeedsLayout();
  }

  double? _maxHeight;
  set maxHeight(double? value) {
    if (value == _maxHeight) return;
    _maxHeight = value;
    markNeedsLayout();
  }

  /// The height this box resolves to under [constraints].
  ///
  /// The bounded and unbounded cases differ only in where the number comes
  /// from, and `max-h-*` clamps both. That is narrower than it sounds, and the
  /// closing `constrainHeight` is why.
  ///
  /// Under a LOOSE bounded height the cap now applies where it used to be
  /// discarded: the widget-layer version wrapped no `ConstrainedBox` on its
  /// bounded branch at all, so `h-full max-h-[120px]` under a
  /// `ConstrainedBox(maxHeight: 400)` rendered 400 and now renders 120.
  ///
  /// Under a TIGHT one it still yields the parent's height, and that is correct
  /// rather than the same bug: a tight constraint is the parent stating an
  /// exact size, and no className overrides it. `constrainHeight` is what keeps
  /// this box honest about that.
  double _heightFor(BoxConstraints constraints) {
    final double available =
        constraints.hasBoundedHeight ? constraints.maxHeight : _fallbackHeight;
    final double capped =
        _maxHeight == null ? available : math.min(available, _maxHeight!);

    return constraints.constrainHeight(capped);
  }

  /// The width constraints to hand the child.
  ///
  /// Untouched unless a `w-*` fraction asked for a share, which is what the
  /// widget-layer `SizedBox(width: double.infinity)` and
  /// `FractionallySizedBox(widthFactor: ...)` both did in their own branches.
  ///
  /// The cap applies AFTER the fraction, and that is a fix rather than a port.
  /// The widget-layer version put its `ConstrainedBox` outside the
  /// `FractionallySizedBox`, but `BoxConstraints.enforce` clamps an additional
  /// constraint into the incoming range, so against the tight width the
  /// fraction had already produced the cap was discarded: `w-1/2 h-full
  /// max-w-[100px]` in a 300 pixel parent rendered 150 and now renders 100.
  (double, double) _widthRangeFor(BoxConstraints constraints) {
    double minWidth = constraints.minWidth;
    double maxWidth = constraints.maxWidth;

    if (_widthFactor != null && constraints.hasBoundedWidth) {
      final double target = constraints.maxWidth * _widthFactor!;
      minWidth = target;
      maxWidth = target;
    }

    if (_maxWidth != null && maxWidth > _maxWidth!) {
      maxWidth = _maxWidth!;
      if (minWidth > maxWidth) minWidth = maxWidth;
    }

    return (minWidth, maxWidth);
  }

  @override
  void performLayout() {
    final double height = _heightFor(constraints);
    final (double minWidth, double maxWidth) = _widthRangeFor(constraints);

    final RenderBox? target = child;
    // Reachable: a childless `WDiv` (a rule, a divider, a spacer) carrying only
    // `h-full` builds no core structure, so this box gets a null child.
    if (target == null) {
      size = constraints.constrain(Size(minWidth, height));
      return;
    }

    target.layout(
      BoxConstraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: height,
        maxHeight: height,
      ),
      parentUsesSize: true,
    );

    // The width comes from the child so an unconstrained axis still hugs, the
    // height from the resolution above so a bounded parent still gets the full
    // fill it asked for.
    size = constraints.constrain(Size(target.size.width, height));
  }

  // Intrinsics are deliberately left to `RenderProxyBox`, which forwards them
  // to the child.
  //
  // That is the honest answer for a box whose job is to take what it is given:
  // its natural height is its content's, and the fill happens against whatever
  // the parent then offers. The first version overrode both to report
  // [fallbackHeight], reasoning that a fill box "wants" the screen. Under an
  // `IntrinsicHeight` beside a 60 pixel sibling that made the row 600 rather
  // than 60, which is the opposite of what `h-full` means.
  //
  // Answering at all is the change. The old `LayoutBuilder` could not, so an
  // `IntrinsicHeight` anywhere above `h-full` threw, and that limitation was
  // documented rather than fixed.

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final double height = _heightFor(constraints);
    final (double minWidth, double maxWidth) = _widthRangeFor(constraints);

    final RenderBox? target = child;
    if (target == null) {
      return constraints.constrain(Size(minWidth, height));
    }

    final Size childSize = target.getDryLayout(
      BoxConstraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: height,
        maxHeight: height,
      ),
    );

    return constraints.constrain(Size(childSize.width, height));
  }
}
