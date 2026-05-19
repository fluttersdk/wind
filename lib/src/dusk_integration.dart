import 'package:flutter/material.dart';
import 'package:fluttersdk_dusk/dusk.dart';

import 'parser/wind_context.dart';
import 'parser/wind_parser.dart';
import 'parser/wind_style.dart';
import 'widgets/w_button.dart';
import 'widgets/w_checkbox.dart';
import 'widgets/w_date_picker.dart';
import 'widgets/w_div.dart';
import 'widgets/w_form_checkbox.dart';
import 'widgets/w_form_date_picker.dart';
import 'widgets/w_form_input.dart';
import 'widgets/w_form_select.dart';
import 'widgets/w_icon.dart';
import 'widgets/w_image.dart';
import 'widgets/w_input.dart';
import 'widgets/w_popover.dart';
import 'widgets/w_select.dart';
import 'widgets/w_spacer.dart';
import 'widgets/w_svg.dart';
import 'widgets/w_text.dart';

/// **Wind ↔ Dusk integration hook.**
///
/// Registers a [DuskSnapshotEnricher] that appends Wind-specific styling
/// metadata to every Dusk snapshot ref whose underlying widget consumes a
/// `className` (i.e. a W-prefixed widget).
///
/// Host integration:
/// ```dart
/// void main() {
///   WidgetsFlutterBinding.ensureInitialized();
///   if (kDebugMode) {
///     DuskPlugin.install();
///     WindDuskIntegration.install();
///   }
///   runApp(app);
/// }
/// ```
///
/// The enricher emits a flat YAML block under the snapshot ref. The first six
/// lines are always present (when the underlying [WindContext] / [WindStyle]
/// resolves to non-null values for `bgColor` / `textColor`):
///
/// ```yaml
/// wind:
///     breakpoint: md
///     brightness: light
///     platform: web
///     states: [hover]
///     bgColor: '#3B82F6'
///     textColor: '#FFFFFF'
/// ```
///
/// In addition the enricher surfaces ~60 further [WindStyle] fields when they
/// resolve to non-null / non-identity-default values: layout
/// (`displayType`, `flexDirection`, `mainAxisAlignment`, …), sizing (`width`,
/// `height`, `constraints`, `aspectRatio`), spacing (`padding`, `margin`),
/// typography (`fontSize`, `fontWeight`, `textAlign`, …), borders + ring,
/// effects (`opacity`, `transitionDuration`, `boxShadow`, …), position
/// (`positionType`, `positionTop`, `positionLeft`, …), animation, overflow,
/// SVG, and misc fields. Each value is capped at 60 characters (truncated with
/// `…`) so the snapshot YAML stays bounded.
///
/// `bgColor` and `textColor` are emitted only when the resolved [WindStyle]
/// carries a non-null `decoration.color` or `color`. The other four core
/// fields (`breakpoint`, `brightness`, `platform`, `states`) are always
/// present.
///
/// ### Provenance pass-through
///
/// When [enableProvenance] is invoked with `true`, subsequent enricher calls
/// pass `trackProvenance: true` to [WindParser.parse]. The parser records, per
/// resolved class token, the comma-separated path of prefixes that activated
/// it; the enricher emits this as a final `resolvedVia:` YAML line. The
/// toggle is module-static (the `DuskSnapshotEnricher` typedef is frozen at
/// `String? Function(Element, RefRegistry)`, so the flag cannot be threaded
/// through the call). The toggle defaults to `false`; flipping it back to
/// `false` immediately reverts to the production-cheap, cache-friendly path.
///
/// Idempotent: subsequent `install()` calls are no-ops, mirroring the
/// [DuskPlugin] install pattern.
class WindDuskIntegration {
  WindDuskIntegration._();

  static bool _installed = false;

  /// Whether [install] has already wired the enricher in this isolate.
  ///
  /// Exposed primarily for tests; production callers should rely on the
  /// idempotency contract of [install] itself.
  static bool get isInstalled => _installed;

  /// Registers the Wind className enricher with [DuskPlugin].
  ///
  /// Safe to call multiple times — only the first call mutates
  /// [DuskPlugin.enrichers]. Pair with [DuskPlugin.install] inside the
  /// host's `kDebugMode` branch.
  static void install() {
    if (_installed) {
      return;
    }
    _installed = true;
    DuskPlugin.enrichers.add(windClassNameEnricher);
  }

  /// Removes the enricher from [DuskPlugin.enrichers] and clears the
  /// `_installed` flag. Test-only — production code should never call this.
  static void resetForTesting() {
    DuskPlugin.enrichers.remove(windClassNameEnricher);
    _installed = false;
    _provenanceEnabled = false;
  }

  /// Toggles the parser's `trackProvenance` opt-in for subsequent enricher
  /// invocations. Defaults to `false`. Test-only / debug-tool surface.
  static void enableProvenance(bool enabled) {
    _provenanceEnabled = enabled;
  }

  /// Whether [windClassNameEnricher] currently routes through
  /// `WindParser.parse(..., trackProvenance: true)`. Exposed for tests.
  static bool get provenanceEnabled => _provenanceEnabled;
}

/// Module-static provenance trigger. Read by [windClassNameEnricher] at every
/// call; toggled via [WindDuskIntegration.enableProvenance]. Lives at module
/// scope (not on a class) because the [DuskSnapshotEnricher] typedef is frozen
/// at `String? Function(Element, RefRegistry)` and cannot accept a third arg.
bool _provenanceEnabled = false;

/// Wind className enricher. Matches the [DuskSnapshotEnricher] typedef.
///
/// Returns null when the [element] is not a W-prefixed widget or carries
/// no className — the dispatcher skips null returns per the
/// [DuskSnapshotEnricher] contract.
///
/// Public so test suites can invoke it directly without going through the
/// full `DuskPlugin.enrichers` dispatch.
String? windClassNameEnricher(Element element, RefRegistry refs) {
  final widget = element.widget;

  // 1. Filter to W-prefixed widgets that expose a className API.
  if (!_isWindWidget(widget)) {
    return null;
  }

  // 2. Extract className via dynamic dispatch — the surface is uniform
  //    across every W-widget so a single accessor covers all 17 types.
  final dynamic w = widget;
  final String? className = w.className as String?;
  if (className == null || className.isEmpty) {
    return null;
  }

  // 3. Resolve context + style at snapshot time so the captured values
  //    reflect the active breakpoint, brightness, platform, and states.
  final WindContext context = WindContext.build(element);
  final WindStyle style = WindParser.parse(
    className,
    element,
    trackProvenance: _provenanceEnabled,
  );

  // 4. Assemble the flat YAML block. Existing 6 fields stay in their
  //    historical slots (breakpoint, brightness, platform, states,
  //    bgColor, textColor); 50+ additional fields follow only when their
  //    resolved value is non-null AND non-identity-default. Indent matches
  //    dusk's snapshot bullet convention (4-space indent under the ref).
  final StringBuffer buf = StringBuffer('wind:\n');
  _writeKv(buf, 'breakpoint', context.activeBreakpoint);
  _writeKv(
    buf,
    'brightness',
    context.theme.brightness == Brightness.dark ? 'dark' : 'light',
  );
  _writeKv(buf, 'platform', context.platform);
  _writeKv(buf, 'states', '[${context.activeStates.join(', ')}]');

  // bg / text colors first (preserve historical slot 5 + 6).
  final Color? bgColor = style.decoration?.color;
  if (bgColor != null) {
    _writeKv(buf, 'bgColor', "'#${_hexRgb(bgColor)}'");
  }
  final Color? textColor = style.color;
  if (textColor != null) {
    _writeKv(buf, 'textColor', "'#${_hexRgb(textColor)}'");
  }

  // Layout
  _maybeWriteEnum(buf, 'displayType', style.displayType,
      skipDefault: WindDisplayType.block);
  _maybeWriteEnum(buf, 'flexDirection', style.flexDirection);
  _maybeWriteEnum(buf, 'mainAxisAlignment', style.mainAxisAlignment);
  _maybeWriteEnum(buf, 'crossAxisAlignment', style.crossAxisAlignment);
  _maybeWriteEnum(buf, 'runAlignment', style.runAlignment);
  _maybeWriteEnum(buf, 'mainAxisSize', style.mainAxisSize);
  if (style.alignment != null) {
    _writeKv(buf, 'alignment', style.alignment!.toString());
  }
  if (style.flex != null) {
    _writeKv(buf, 'flex', style.flex.toString());
  }
  _maybeWriteEnum(buf, 'flexFit', style.flexFit);
  if (style.gapX != null) {
    _writeKv(buf, 'gapX', _fmtNum(style.gapX!));
  }
  if (style.gapY != null) {
    _writeKv(buf, 'gapY', _fmtNum(style.gapY!));
  }

  // Sizing
  if (style.width != null) {
    _writeKv(buf, 'width', _fmtNum(style.width!));
  }
  if (style.height != null) {
    _writeKv(buf, 'height', _fmtNum(style.height!));
  }
  if (style.widthFactor != null) {
    _writeKv(buf, 'widthFactor', _fmtNum(style.widthFactor!));
  }
  if (style.heightFactor != null) {
    _writeKv(buf, 'heightFactor', _fmtNum(style.heightFactor!));
  }
  if (style.constraints != null) {
    _writeKv(buf, 'constraints', _fmtConstraints(style.constraints!));
  }
  if (style.aspectRatio != null) {
    _writeKv(buf, 'aspectRatio', _fmtNum(style.aspectRatio!));
  }

  // Spacing
  if (style.padding != null) {
    _writeKv(buf, 'padding', _fmtEdgeInsets(style.padding!));
  }
  if (style.margin != null) {
    _writeKv(buf, 'margin', _fmtEdgeInsets(style.margin!));
  }
  if (style.marginXAuto) {
    _writeKv(buf, 'marginXAuto', 'true');
  }

  // Typography
  if (style.fontSize != null) {
    _writeKv(buf, 'fontSize', _fmtNum(style.fontSize!));
  }
  if (style.fontWeight != null) {
    _writeKv(buf, 'fontWeight', _fmtFontWeight(style.fontWeight!));
  }
  _maybeWriteEnum(buf, 'fontStyle', style.fontStyle);
  if (style.fontFamily != null) {
    _writeKv(buf, 'fontFamily', style.fontFamily!);
  }
  if (style.letterSpacing != null) {
    _writeKv(buf, 'letterSpacing', _fmtNum(style.letterSpacing!));
  }
  if (style.heightLine != null) {
    _writeKv(buf, 'heightLine', _fmtNum(style.heightLine!));
  }
  if (style.heightLineFactor != null) {
    _writeKv(buf, 'heightLineFactor', _fmtNum(style.heightLineFactor!));
  }
  if (style.textDecoration != null) {
    _writeKv(buf, 'textDecoration', style.textDecoration!.toString());
  }
  if (style.textDecorationColor != null) {
    _writeKv(
      buf,
      'textDecorationColor',
      "'#${_hexRgb(style.textDecorationColor!)}'",
    );
  }
  _maybeWriteEnum(buf, 'textDecorationStyle', style.textDecorationStyle);
  if (style.textDecorationThickness != null) {
    _writeKv(
      buf,
      'textDecorationThickness',
      _fmtNum(style.textDecorationThickness!),
    );
  }
  _maybeWriteEnum(buf, 'textAlign', style.textAlign);
  _maybeWriteEnum(buf, 'textOverflow', style.textOverflow);
  if (style.maxLines != null) {
    _writeKv(buf, 'maxLines', style.maxLines.toString());
  }
  if (style.softWrap != null) {
    _writeKv(buf, 'softWrap', style.softWrap.toString());
  }
  _maybeWriteEnum(buf, 'textTransform', style.textTransform);

  // Borders + Ring
  if (style.ringColor != null) {
    _writeKv(buf, 'ringColor', "'#${_hexRgb(style.ringColor!)}'");
  }
  if (style.ringWidth != null) {
    _writeKv(buf, 'ringWidth', _fmtNum(style.ringWidth!));
  }
  if (style.ringOffset != null) {
    _writeKv(buf, 'ringOffset', _fmtNum(style.ringOffset!));
  }
  if (style.ringInset != null) {
    _writeKv(buf, 'ringInset', style.ringInset.toString());
  }
  final Border? border = _maybeBorder(style.decoration?.border);
  if (border != null) {
    _writeKv(buf, 'border', _fmtBorder(border));
  }

  // Effects
  if (style.boxShadow != null && style.boxShadow!.isNotEmpty) {
    _writeKv(buf, 'boxShadow', _fmtBoxShadows(style.boxShadow!));
  }
  if (style.shadowColor != null) {
    _writeKv(buf, 'shadowColor', "'#${_hexRgb(style.shadowColor!)}'");
  }
  if (style.opacity != null) {
    _writeKv(buf, 'opacity', _fmtNum(style.opacity!));
  }
  if (style.transitionDuration != null) {
    _writeKv(
      buf,
      'transitionDuration',
      '${style.transitionDuration!.inMilliseconds}ms',
    );
  }
  if (style.transitionCurve != null) {
    _writeKv(buf, 'transitionCurve', style.transitionCurve!.toString());
  }

  // Position
  _maybeWriteEnum(buf, 'positionType', style.positionType);
  if (style.positionTop != null) {
    _writeKv(buf, 'positionTop', _fmtNum(style.positionTop!));
  }
  if (style.positionRight != null) {
    _writeKv(buf, 'positionRight', _fmtNum(style.positionRight!));
  }
  if (style.positionBottom != null) {
    _writeKv(buf, 'positionBottom', _fmtNum(style.positionBottom!));
  }
  if (style.positionLeft != null) {
    _writeKv(buf, 'positionLeft', _fmtNum(style.positionLeft!));
  }

  // Animation
  _maybeWriteEnum(buf, 'animationType', style.animationType);

  // Overflow
  _maybeWriteEnum(buf, 'overflow', style.overflow);
  _maybeWriteEnum(buf, 'overflowX', style.overflowX);
  _maybeWriteEnum(buf, 'overflowY', style.overflowY);

  // SVG
  if (style.fillColor != null) {
    _writeKv(buf, 'fillColor', "'#${_hexRgb(style.fillColor!)}'");
  }
  if (style.strokeColor != null) {
    _writeKv(buf, 'strokeColor', "'#${_hexRgb(style.strokeColor!)}'");
  }
  if (style.preserveColors) {
    _writeKv(buf, 'preserveColors', 'true');
  }

  // Misc
  if (style.isHidden) {
    _writeKv(buf, 'isHidden', 'true');
  }
  if (style.debug) {
    _writeKv(buf, 'debug', 'true');
  }

  // Provenance (debug-only, opt-in via WindDuskIntegration.enableProvenance).
  final Map<String, String>? provenance = style.resolvedVia;
  if (provenance != null && provenance.isNotEmpty) {
    final String body =
        provenance.entries.map((e) => '${e.key}=${e.value}').join(',');
    _writeKv(buf, 'resolvedVia', body);
  }

  return buf.toString();
}

/// Returns true when [widget] is one of the 17 W-prefixed widgets that
/// accept a className. WAnchor / WBreakpoint / WindAnimationWrapper /
/// WKeyboardActions are intentionally excluded — they do not consume
/// className tokens directly.
bool _isWindWidget(Widget widget) {
  return widget is WDiv ||
      widget is WText ||
      widget is WButton ||
      widget is WInput ||
      widget is WFormInput ||
      widget is WSelect ||
      widget is WFormSelect ||
      widget is WFormMultiSelect ||
      widget is WCheckbox ||
      widget is WFormCheckbox ||
      widget is WDatePicker ||
      widget is WFormDatePicker ||
      widget is WIcon ||
      widget is WImage ||
      widget is WSvg ||
      widget is WPopover ||
      widget is WSpacer;
}

// ---------------------------------------------------------------------------
// Formatting helpers
// ---------------------------------------------------------------------------

/// Maximum length of an emitted YAML value (after the `key: ` prefix). Values
/// longer than this are truncated with a single trailing `…`.
const int _maxValueLen = 60;

/// Writes one `key: value` line, indented 4 spaces, capped at [_maxValueLen]
/// characters on the value side. Truncation appends `…` so the cap is visible.
void _writeKv(StringBuffer buf, String key, String value) {
  final String capped = value.length > _maxValueLen
      ? '${value.substring(0, _maxValueLen)}…'
      : value;
  buf.writeln('    $key: $capped');
}

/// Writes the enum value's [Enum.name] when [value] is non-null AND not equal
/// to the identity default. Used for every backed enum field.
void _maybeWriteEnum<E extends Enum>(
  StringBuffer buf,
  String key,
  E? value, {
  E? skipDefault,
}) {
  if (value == null) return;
  if (skipDefault != null && value == skipDefault) return;
  _writeKv(buf, key, value.name);
}

/// Formats [color] as a 6-char RGB hex string (alpha dropped, uppercase).
///
/// `toARGB32()` yields a 32-bit `0xAARRGGBB` integer; padding to 8 hex
/// chars then slicing the trailing 6 keeps the RGB triplet only.
String _hexRgb(Color color) {
  final String hex = color.toARGB32().toRadixString(16).padLeft(8, '0');
  return hex.substring(2).toUpperCase();
}

/// Formats a double, stripping the trailing `.0` when the value is integral so
/// the snapshot stays compact (`16` instead of `16.0`).
String _fmtNum(double value) {
  if (value == value.truncateToDouble()) {
    return value.toInt().toString();
  }
  return value.toString();
}

/// Formats an [EdgeInsets] as `T,R,B,L` (compact, matches CSS shorthand
/// ordering convention familiar to Tailwind users).
String _fmtEdgeInsets(EdgeInsets edge) {
  return '${_fmtNum(edge.top)},${_fmtNum(edge.right)},'
      '${_fmtNum(edge.bottom)},${_fmtNum(edge.left)}';
}

/// Formats a [BoxConstraints] as `min=WxH,max=WxH` (Infinity → `inf`).
String _fmtConstraints(BoxConstraints c) {
  String n(double v) => v.isInfinite ? 'inf' : _fmtNum(v);
  return 'min=${n(c.minWidth)}x${n(c.minHeight)},'
      'max=${n(c.maxWidth)}x${n(c.maxHeight)}';
}

/// Formats a [FontWeight] as its 3-digit numeric value (e.g. `700`).
///
/// The Flutter SDK exposes weights as `FontWeight.w<N>`; [FontWeight.value]
/// is the int. Falls back to `toString()` for custom subclasses.
String _fmtFontWeight(FontWeight weight) {
  return weight.value.toString();
}

/// Extracts a single [Border] from a [BoxBorder] when possible; returns null
/// for `BorderDirectional` or other variants we cannot summarise without
/// losing information.
Border? _maybeBorder(BoxBorder? boxBorder) {
  if (boxBorder is Border) return boxBorder;
  return null;
}

/// Formats a [Border] as `width=<W>,color=#RRGGBB` using the top side as the
/// representative side (Wind sets all sides uniformly through `border-*`).
String _fmtBorder(Border border) {
  final BorderSide side = border.top;
  final String width = _fmtNum(side.width);
  final String color = '#${_hexRgb(side.color)}';
  return 'width=$width,color=$color';
}

/// Formats a list of [BoxShadow] as a comma-separated value tuple list
/// `offsetX,offsetY,blur,spread,color;…`.
String _fmtBoxShadows(List<BoxShadow> shadows) {
  return shadows
      .map((s) => '${_fmtNum(s.offset.dx)},${_fmtNum(s.offset.dy)},'
          '${_fmtNum(s.blurRadius)},${_fmtNum(s.spreadRadius)},'
          '#${_hexRgb(s.color)}')
      .join(';');
}
