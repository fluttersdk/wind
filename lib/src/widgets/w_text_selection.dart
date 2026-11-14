import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Radius of the knob at the end of a selection handle's stem.
const double _kHandleRadius = 6;

/// How far the stem reaches into the knob, so the two read as one shape.
const double _kHandleOverlap = 1.5;

/// Handle colour when no [DefaultSelectionStyle] supplies a cursor colour:
/// blue-500, the same hue `WInput` tints its selection with by default.
const Color _kHandleFallbackColor = Color(0xFF3B82F6);

/// Gap between the screen edge (after the safe-area padding) and the toolbar.
const double _kToolbarScreenPadding = 8;

/// Gap between the selected text and the toolbar above or below it.
const double _kToolbarContentDistance = 8;

/// Selection handle controls built only on the widgets layer, so `WInput`
/// draws handles under any root (a bare `WidgetsApp`, Material, Cupertino).
///
/// The handle is a lollipop: a round knob on a thin stem, the left one knob
/// up, the right one flipped knob down. A collapsed selection (a caret) gets
/// an invisible box of the same size, so it still receives drag gestures
/// without painting anything.
///
/// Mixes in [TextSelectionHandleControls], which turns the legacy
/// [buildToolbar] into a no-op: the `contextMenuBuilder` is the only toolbar
/// path, so `MaterialLocalizations` is never required.
class WindTextSelectionHandleControls extends TextSelectionControls
    with TextSelectionHandleControls {
  @override
  Size getHandleSize(double textLineHeight) {
    return Size(
      _kHandleRadius * 2,
      textLineHeight + _kHandleRadius * 2 - _kHandleOverlap,
    );
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    final Size size = getHandleSize(textLineHeight);

    return switch (type) {
      // Knob on top: the stem tip is the bottom of the selected line.
      TextSelectionHandleType.left => Offset(size.width / 2, size.height),
      // Flipped: the stem starts at the top of the line, just past the knob.
      TextSelectionHandleType.right => Offset(
        size.width / 2,
        size.height - _kHandleRadius * 2 + _kHandleOverlap,
      ),
      // The invisible caret box is centred on the line's bottom.
      TextSelectionHandleType.collapsed => Offset(
        size.width / 2,
        textLineHeight + (size.height - textLineHeight) / 2,
      ),
    };
  }

  /// Builds the handle widget, positioned by the overlay at the selection
  /// endpoint's bottom baseline and shifted by [getHandleAnchor].
  ///
  /// [onTap] is ignored: like the platform handles on iOS, these are dragged,
  /// never tapped.
  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
  ]) {
    final Size size = getHandleSize(textLineHeight);
    if (type == TextSelectionHandleType.collapsed) {
      return SizedBox.fromSize(size: size);
    }

    final Widget handle = SizedBox.fromSize(
      size: size,
      child: CustomPaint(
        painter: WindTextSelectionHandlePainter(
          DefaultSelectionStyle.of(context).cursorColor ??
              _kHandleFallbackColor,
        ),
      ),
    );
    if (type == TextSelectionHandleType.left) {
      return handle;
    }

    return Transform.rotate(angle: math.pi, child: handle);
  }
}

/// Paints one selection handle: a knob of [_kHandleRadius] at the top and a
/// 2px stem down to the bottom of the canvas.
class WindTextSelectionHandlePainter extends CustomPainter {
  /// Creates a painter that fills the handle with [color].
  const WindTextSelectionHandlePainter(this.color);

  /// The fill colour of the knob and the stem.
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path()
      ..addOval(
        Rect.fromCircle(
          center: const Offset(_kHandleRadius, _kHandleRadius),
          radius: _kHandleRadius,
        ),
      )
      ..addRect(
        Rect.fromLTRB(
          _kHandleRadius - 1,
          _kHandleRadius * 2 - _kHandleOverlap,
          _kHandleRadius + 1,
          size.height,
        ),
      );
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(WindTextSelectionHandlePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

/// The text selection toolbar `WInput` shows, built only on the widgets
/// layer: a rounded, shadowed row of [buttons] with a divider between each.
///
/// It sits above [anchorAbove] when it fits under the safe-area padding and
/// below [anchorBelow] otherwise, both in global coordinates (the overlay that
/// hosts it fills the screen). Colours are plain values from the caller, so
/// the toolbar reads no Material, Cupertino or Wind theme from the overlay,
/// which can sit above the field's `WindTheme`.
class WindTextSelectionToolbar extends StatelessWidget {
  /// Creates a toolbar anchored at the selection.
  const WindTextSelectionToolbar({
    super.key,
    required this.anchorAbove,
    required this.anchorBelow,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.dividerColor,
    required this.buttons,
  });

  /// The point the toolbar's bottom centre aims at when shown above the text.
  final Offset anchorAbove;

  /// The point the toolbar's top centre aims at when shown below the text.
  final Offset anchorBelow;

  /// The surface colour of the toolbar.
  final Color backgroundColor;

  /// The label colour of every button.
  final Color foregroundColor;

  /// The colour of the 1px divider between two buttons.
  final Color dividerColor;

  /// The actions, left to right.
  final List<WindTextSelectionToolbarButton> buttons;

  @override
  Widget build(BuildContext context) {
    // 1. Keep clear of the notch and the screen edges; the Padding moves the
    //    layout origin, so the global anchors move with it.
    final EdgeInsets safeArea =
        MediaQuery.maybePaddingOf(context) ?? EdgeInsets.zero;
    final EdgeInsets insets = EdgeInsets.fromLTRB(
      _kToolbarScreenPadding + safeArea.left,
      _kToolbarScreenPadding + safeArea.top,
      _kToolbarScreenPadding + safeArea.right,
      _kToolbarScreenPadding + safeArea.bottom,
    );
    final Offset origin = Offset(insets.left, insets.top);

    // 2. Separate the buttons with a hairline that spans the row's height.
    final List<Widget> row = [
      for (int i = 0; i < buttons.length; i++) ...[
        if (i > 0) SizedBox(width: 1, child: ColoredBox(color: dividerColor)),
        buttons[i],
      ],
    ];

    // 3. The framework already wraps every context menu in a
    //    TextFieldTapRegion, so a button tap keeps the field focused. A row
    //    wider than the screen (seven iOS actions, German labels) scrolls
    //    sideways instead of clipping, so every action stays reachable.
    return Padding(
      padding: insets,
      child: CustomSingleChildLayout(
        delegate: TextSelectionToolbarLayoutDelegate(
          anchorAbove:
              anchorAbove - origin - const Offset(0, _kToolbarContentDistance),
          anchorBelow:
              anchorBelow - origin + const Offset(0, _kToolbarContentDistance),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: DefaultTextStyle(
              style: TextStyle(color: foregroundColor, fontSize: 14),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context)
                    .copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: row,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One action in a [WindTextSelectionToolbar]: a text label that runs
/// [onPressed] on tap, styled by the toolbar's [DefaultTextStyle].
class WindTextSelectionToolbarButton extends StatelessWidget {
  /// Creates a toolbar button.
  const WindTextSelectionToolbarButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  /// The localized action name, for example "Copy".
  final String label;

  /// Runs the action; null leaves the button inert and reported as disabled.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Center(widthFactor: 1, heightFactor: 1, child: Text(label)),
        ),
      ),
    );
  }
}

/// Maps a context-menu action to its localized label: the
/// [WidgetsLocalizations] string for every action it names, the item's own
/// label for the rest (custom items, delete, Live Text), and null when there
/// is none, so the caller can leave a blank button out.
String? windContextMenuLabel(
  ContextMenuButtonItem item,
  WidgetsLocalizations localizations,
) {
  return switch (item.type) {
    ContextMenuButtonType.copy => localizations.copyButtonLabel,
    ContextMenuButtonType.cut => localizations.cutButtonLabel,
    ContextMenuButtonType.paste => localizations.pasteButtonLabel,
    ContextMenuButtonType.selectAll => localizations.selectAllButtonLabel,
    ContextMenuButtonType.lookUp => localizations.lookUpButtonLabel,
    ContextMenuButtonType.searchWeb => localizations.searchWebButtonLabel,
    ContextMenuButtonType.share => localizations.shareButtonLabel,
    ContextMenuButtonType.delete ||
    ContextMenuButtonType.liveTextInput ||
    ContextMenuButtonType.custom => item.label,
  };
}

// steer probe w_text_selection
