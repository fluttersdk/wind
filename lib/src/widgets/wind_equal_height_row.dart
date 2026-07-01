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
/// with a loose height to measure it, then lays it out again tight to the row's
/// max height. Real layout is exactly what `LayoutBuilder` supports, so a
/// `flex flex-col` cell stretches without asserting.
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

    // Pass 2: stretch every cell to at least `target` using a MIN height (never
    // a tight height) and position it. A tight height would squeeze a cell
    // whose content, laid out for real, needs a hair more than the
    // loose-measured max (sub-pixel text/flex rounding) and produce a
    // "RenderFlex overflowed by ~2px" warning (#141). A min constraint instead
    // lets such a cell grow, so the re-laid height is always >= the cell's own
    // content and overflow is impossible. The row takes the tallest resulting
    // height; in the common case every cell settles at `target` (equal), and in
    // the rare sub-pixel case a grown cell simply sets a marginally taller row.
    double rowHeight = target;
    double dx = 0;
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
