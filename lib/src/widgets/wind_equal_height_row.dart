import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A row that sizes every child to the height of the tallest, measured by a
/// REAL two-pass layout rather than the intrinsic-sizing protocol.
///
/// This is the intrinsic-free replacement for `IntrinsicHeight` + a
/// `Row(crossAxisAlignment: stretch)` in the grid `items-stretch` path. Wind
/// cell content frequently contains a `LayoutBuilder` (flex cross-axis stretch,
/// `h-full`, `basis-*`), and `LayoutBuilder` cannot answer intrinsic or
/// dry-layout queries, so `IntrinsicHeight` asserts `LayoutBuilder does not
/// support returning intrinsic dimensions` the moment it has to stretch an
/// unequal cell (issue #139). This widget instead lays each child out for real
/// with a loose height to measure it, then lays it out again to the row's max
/// height via a MIN constraint (never a tight one). Real layout is exactly what
/// `LayoutBuilder` supports, so a `flex flex-col` cell stretches without
/// asserting; and because a cell is never forced BELOW its own content height, a
/// stretched cell leaves no residual `RenderFlex overflowed` warning the way a
/// tight re-lay could on fractional (sub-pixel) content (issue #141).
///
/// Every child is given an equal share of the incoming width (`(maxWidth -
/// spacing * (n - 1)) / n`), matching the grid's fixed column count, so callers
/// pass one child per column (padding a short final row with blank children
/// keeps the columns aligned). [spacing] is the horizontal gap between columns.
class WindEqualHeightRow extends MultiChildRenderObjectWidget {
  /// Horizontal gap inserted between each column.
  final double spacing;

  const WindEqualHeightRow({
    super.key,
    this.spacing = 0,
    required super.children,
  }) : assert(
          spacing >= 0 && spacing < double.infinity,
          'WindEqualHeightRow.spacing must be finite and non-negative.',
        );

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderEqualHeightRow(spacing: spacing);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _RenderEqualHeightRow).spacing = spacing;
  }
}

class _EqualHeightParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderEqualHeightRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _EqualHeightParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _EqualHeightParentData> {
  _RenderEqualHeightRow({required double spacing}) : _spacing = spacing;

  double _spacing;
  set spacing(double value) {
    assert(
      value >= 0 && value < double.infinity,
      'WindEqualHeightRow.spacing must be finite and non-negative.',
    );
    if (value == _spacing) return;
    _spacing = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _EqualHeightParentData) {
      child.parentData = _EqualHeightParentData();
    }
  }

  @override
  void performLayout() {
    final int count = childCount;
    if (count == 0) {
      size = constraints.smallest;
      return;
    }

    final double totalSpacing = _spacing * (count - 1);
    // A grid always lives in a bounded-width parent; fall back to 0 (degenerate,
    // never in practice) rather than an infinite width if it does not.
    final double raw =
        (constraints.maxWidth.isFinite ? constraints.maxWidth : 0.0) -
            totalSpacing;
    final double cellWidth = raw > 0 ? raw / count : 0.0;

    // Pass 1: lay each cell out at its natural height (loose height) to find the
    // tallest. This is a real layout, so LayoutBuilder-bearing cells are fine.
    double maxHeight = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      child.layout(
        BoxConstraints(
          minWidth: cellWidth,
          maxWidth: cellWidth,
          maxHeight: constraints.maxHeight,
        ),
        parentUsesSize: true,
      );
      if (child.size.height > maxHeight) maxHeight = child.size.height;
      child = childAfter(child);
    }

    // Honor the incoming height constraint: if the parent forces a taller (or
    // caps at a shorter) row, cells stretch to that height, not just the
    // measured tallest, so the row and its cells stay consistent.
    final double target =
        maxHeight.clamp(constraints.minHeight, constraints.maxHeight);

    // Pass 2: re-lay each cell with a MIN height of `target` (never a tight
    // height) to settle the true row height. A tight height would squeeze a
    // cell whose content, laid out for real, needs a hair more than the
    // loose-measured max (sub-pixel text/flex rounding), producing a
    // "RenderFlex overflowed by ~2px" warning (#141). A min constraint instead
    // lets such a cell keep its own (larger) height, so `rowHeight` ends up >=
    // every cell's content and no cell is ever squeezed.
    double rowHeight = target;
    child = firstChild;
    while (child != null) {
      child.layout(
        BoxConstraints(
          minWidth: cellWidth,
          maxWidth: cellWidth,
          minHeight: target,
          maxHeight: constraints.maxHeight,
        ),
        parentUsesSize: true,
      );
      if (child.size.height > rowHeight) rowHeight = child.size.height;
      child = childAfter(child);
    }
    rowHeight = rowHeight.clamp(constraints.minHeight, constraints.maxHeight);

    // Pass 3: lay every cell to the settled `rowHeight` (still a MIN height, so
    // no squeeze) and position it. This equalizes any cell that measured shorter
    // than a sibling which grew in pass 2, so all cells share the row height.
    double dx = 0;
    child = firstChild;
    while (child != null) {
      child.layout(
        BoxConstraints(
          minWidth: cellWidth,
          maxWidth: cellWidth,
          minHeight: rowHeight,
          maxHeight: constraints.maxHeight,
        ),
        parentUsesSize: true,
      );
      (child.parentData as _EqualHeightParentData).offset = Offset(dx, 0);
      dx += cellWidth + _spacing;
      child = childAfter(child);
    }

    final double width = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : (dx - _spacing).clamp(0.0, double.infinity);
    size = constraints.constrain(Size(width, rowHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}

/// Stretches its child to the enclosing column's cross-axis (width) when that
/// width is bounded, and passes the child through unchanged when it is not.
///
/// This is the intrinsic-safe replacement for the `LayoutBuilder` +
/// `SizedBox(width: double.infinity)` pair that used to gate `flex flex-col`
/// smart cross-axis stretch (and now also drives explicit `items-stretch`
/// columns). Because it is a real [RenderProxyBox] it answers intrinsic and
/// dry-layout queries by delegating to its child, so a stretched column renders
/// under an intrinsic-measuring ancestor (`IntrinsicHeight`, a `Table`, a
/// Flutter grid cell) without the `LayoutBuilder does not support returning
/// intrinsic dimensions` assert. When the incoming width is unbounded (a bare
/// `Row` main-axis slot, `UnconstrainedBox`, a horizontal scroll) it degrades to
/// the child's content width instead of forcing an infinite width.
class WindCrossStretch extends SingleChildRenderObjectWidget {
  const WindCrossStretch({super.key, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderCrossStretch();
}

class _RenderCrossStretch extends RenderProxyBox {
  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    if (constraints.maxWidth.isFinite) {
      child.layout(
        BoxConstraints(
          minWidth: constraints.maxWidth,
          maxWidth: constraints.maxWidth,
          minHeight: constraints.minHeight,
          maxHeight: constraints.maxHeight,
        ),
        parentUsesSize: true,
      );
    } else {
      child.layout(constraints, parentUsesSize: true);
    }
    size = child.size;
  }
}

/// A mutable carrier for a flex's resolved main-axis extent, written by
/// [WindMainExtentProvider] during layout and read by [WindFractionBasis]. The
/// same instance is shared (via the widget tree) between the provider and the
/// fractional-basis children it feeds.
class WindMainExtentPort {
  /// The most recent main-axis extent (row width / column height) published by
  /// the enclosing [WindMainExtentProvider]; `null` before the first layout.
  double? value;

  /// Set by `_applyMainAxisBasis` when a FRACTIONAL basis child was wrapped, so
  /// the caller only pays for a [WindMainExtentProvider] when the extent is
  /// actually read (fixed `basis-[Npx]` resolves to a plain `SizedBox`).
  bool needsProvider = false;

  final Set<RenderObject> _dependents = <RenderObject>{};

  /// Registers a consumer render object so it is re-laid out when [value]
  /// changes. A basis child's OWN constraints do not change when the flex's
  /// extent does (a flex hands non-flex children an unbounded main axis), so it
  /// would otherwise skip layout and read a stale extent.
  void addDependent(RenderObject dependent) => _dependents.add(dependent);

  /// Unregisters a consumer render object (on detach or a port swap).
  void removeDependent(RenderObject dependent) => _dependents.remove(dependent);

  /// Publishes a new extent and marks every registered consumer for layout when
  /// the value actually changed.
  void publish(double newValue) {
    if (newValue == value) return;
    value = newValue;
    for (final dependent in _dependents) {
      dependent.markNeedsLayout();
    }
  }
}

/// Publishes the enclosing flex's own main-axis extent (row width / column
/// height) through [port] during layout, so fractional `basis-*` children can
/// resolve their fraction without a `LayoutBuilder`.
///
/// It is a real [RenderProxyBox], so it answers intrinsic/dry-layout queries by
/// delegating to the flex, keeping the whole `basis-*` path intrinsic-safe.
class WindMainExtentProvider extends SingleChildRenderObjectWidget {
  /// The shared carrier the flex's basis children read at layout time.
  final WindMainExtentPort port;

  /// Whether the enclosing flex is a column (main axis is vertical).
  final bool isColumn;

  const WindMainExtentProvider({
    super.key,
    required this.port,
    required this.isColumn,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMainExtentProvider(port, isColumn);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _RenderMainExtentProvider)
      ..port = port
      ..isColumn = isColumn;
  }
}

class _RenderMainExtentProvider extends RenderProxyBox {
  _RenderMainExtentProvider(this._port, this._isColumn);

  WindMainExtentPort _port;
  set port(WindMainExtentPort value) => _port = value;

  bool _isColumn;
  set isColumn(bool value) {
    if (value == _isColumn) return;
    _isColumn = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    // Publish the flex's own bounded main extent BEFORE laying it out, so the
    // WindFractionBasis children the flex lays out (top-down) resolve against a
    // fresh value. `publish` marks the registered basis children for layout
    // when the extent changed (they otherwise skip layout with a stale value,
    // since a flex hands them unchanged unbounded main-axis constraints). The
    // marking is done inside `invokeLayoutCallback`, the sanctioned hook for
    // dirtying the subtree during layout. Intrinsic queries never call
    // performLayout, so this stays intrinsic-safe.
    invokeLayoutCallback<Constraints>((_) {
      _port.publish(_isColumn ? constraints.maxHeight : constraints.maxWidth);
    });
    super.performLayout();
  }
}

/// Sizes its child along the flex main axis to [factor] of the extent published
/// by [port] (a fraction of the flex container), matching CSS `flex-basis` for
/// `basis-1/2`, `basis-full`, etc.
///
/// When the published extent is `null` or infinite (an unbounded flex) it
/// passes the child through at its natural size, mirroring the documented
/// degradation of fractional basis on an unbounded main axis. Intrinsic and
/// dry-layout queries delegate to the child, so a fractional `basis-*` renders
/// under an intrinsic-measuring ancestor without a `LayoutBuilder`.
class WindFractionBasis extends SingleChildRenderObjectWidget {
  /// The shared carrier written by the enclosing [WindMainExtentProvider].
  final WindMainExtentPort port;

  /// The main-axis fraction of the flex container (e.g. `0.5` for `basis-1/2`).
  final double factor;

  /// Whether the enclosing flex is a column (basis sizes height, not width).
  final bool isColumn;

  const WindFractionBasis({
    super.key,
    required this.port,
    required this.factor,
    required this.isColumn,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderFractionBasis(port, factor, isColumn);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _RenderFractionBasis)
      ..port = port
      ..factor = factor
      ..isColumn = isColumn;
  }
}

class _RenderFractionBasis extends RenderProxyBox {
  _RenderFractionBasis(this._port, this._factor, this._isColumn);

  WindMainExtentPort _port;
  set port(WindMainExtentPort value) {
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

  double _factor;
  set factor(double value) {
    if (value == _factor) return;
    _factor = value;
    markNeedsLayout();
  }

  bool _isColumn;
  set isColumn(bool value) {
    if (value == _isColumn) return;
    _isColumn = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final RenderBox? child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    final double? extent = _port.value;
    if (extent != null && extent.isFinite) {
      final double main = _factor * extent;
      child.layout(
        _isColumn
            ? BoxConstraints(
                minWidth: constraints.minWidth,
                maxWidth: constraints.maxWidth,
                minHeight: main,
                maxHeight: main,
              )
            : BoxConstraints(
                minWidth: main,
                maxWidth: main,
                minHeight: constraints.minHeight,
                maxHeight: constraints.maxHeight,
              ),
        parentUsesSize: true,
      );
    } else {
      child.layout(constraints, parentUsesSize: true);
    }
    size = child.size;
  }
}
