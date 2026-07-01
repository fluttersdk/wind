import 'package:flutter/material.dart';

import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **Cursor Parser**
///
/// Maps Tailwind `cursor-*` utilities to Flutter [SystemMouseCursors]. The
/// resolved [MouseCursor] is applied by [WDiv] through a `MouseRegion`, so a
/// plain container can show a pointer cursor on web/desktop without being
/// wrapped in `WAnchor` or a manual `MouseRegion`.
///
/// ### Supported Utility Classes:
/// - **Interaction:** `cursor-pointer`, `cursor-default`, `cursor-auto`,
///   `cursor-wait`, `cursor-progress`, `cursor-text`, `cursor-help`,
///   `cursor-not-allowed`, `cursor-none`, `cursor-context-menu`, `cursor-cell`,
///   `cursor-crosshair`, `cursor-vertical-text`, `cursor-alias`, `cursor-copy`,
///   `cursor-no-drop`, `cursor-move`, `cursor-all-scroll`.
/// - **Drag:** `cursor-grab`, `cursor-grabbing`.
/// - **Zoom:** `cursor-zoom-in`, `cursor-zoom-out`.
/// - **Resize:** `cursor-col-resize`, `cursor-row-resize`, `cursor-n-resize`,
///   `cursor-e-resize`, `cursor-s-resize`, `cursor-w-resize`, `cursor-ne-resize`,
///   `cursor-nw-resize`, `cursor-se-resize`, `cursor-sw-resize`,
///   `cursor-ew-resize`, `cursor-ns-resize`, `cursor-nesw-resize`,
///   `cursor-nwse-resize`.
///
/// Returns a [WindStyle] with a [MouseCursor] in `mouseCursor`.
class CursorParser implements WindParserInterface {
  const CursorParser();

  /// Tailwind cursor name to the closest Flutter [SystemMouseCursors].
  ///
  /// Flutter has no "auto" cursor; `cursor-auto` falls back to the basic arrow
  /// like `cursor-default`, the predictable choice for a styled container.
  static const Map<String, MouseCursor> _cursors = {
    'auto': SystemMouseCursors.basic,
    'default': SystemMouseCursors.basic,
    'pointer': SystemMouseCursors.click,
    'wait': SystemMouseCursors.wait,
    'progress': SystemMouseCursors.progress,
    'text': SystemMouseCursors.text,
    'vertical-text': SystemMouseCursors.verticalText,
    'move': SystemMouseCursors.move,
    'help': SystemMouseCursors.help,
    'not-allowed': SystemMouseCursors.forbidden,
    'none': SystemMouseCursors.none,
    'context-menu': SystemMouseCursors.contextMenu,
    'cell': SystemMouseCursors.cell,
    'crosshair': SystemMouseCursors.precise,
    'alias': SystemMouseCursors.alias,
    'copy': SystemMouseCursors.copy,
    'no-drop': SystemMouseCursors.noDrop,
    'grab': SystemMouseCursors.grab,
    'grabbing': SystemMouseCursors.grabbing,
    'all-scroll': SystemMouseCursors.allScroll,
    'col-resize': SystemMouseCursors.resizeColumn,
    'row-resize': SystemMouseCursors.resizeRow,
    'n-resize': SystemMouseCursors.resizeUp,
    'e-resize': SystemMouseCursors.resizeRight,
    's-resize': SystemMouseCursors.resizeDown,
    'w-resize': SystemMouseCursors.resizeLeft,
    'ne-resize': SystemMouseCursors.resizeUpRight,
    'nw-resize': SystemMouseCursors.resizeUpLeft,
    'se-resize': SystemMouseCursors.resizeDownRight,
    'sw-resize': SystemMouseCursors.resizeDownLeft,
    'ew-resize': SystemMouseCursors.resizeLeftRight,
    'ns-resize': SystemMouseCursors.resizeUpDown,
    'nesw-resize': SystemMouseCursors.resizeUpRightDownLeft,
    'nwse-resize': SystemMouseCursors.resizeUpLeftDownRight,
    'zoom-in': SystemMouseCursors.zoomIn,
    'zoom-out': SystemMouseCursors.zoomOut,
  };

  @override
  bool canParse(String className) {
    return className.startsWith('cursor-');
  }

  @override
  WindStyle parse(WindStyle style, List<String>? classes, WindContext context) {
    if (classes == null) return style;

    MouseCursor? cursor;

    // Walk backwards so the last cursor token wins, matching the parser-wide
    // last-class-wins contract.
    for (var i = classes.length - 1; i >= 0; i--) {
      final value = classes[i].replaceFirst('cursor-', '');
      final resolved = _cursors[value];
      if (resolved != null) {
        cursor = resolved;
        break;
      }
    }

    return style.copyWith(mouseCursor: cursor);
  }
}
