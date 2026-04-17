import 'package:flutter/widgets.dart';

import '../parser/wind_context.dart';

/// **Declarative Breakpoint-Keyed Builder**
///
/// `WBreakpoint` renders a different widget tree per responsive breakpoint,
/// using Wind's own breakpoint resolution (`WindContext.activeBreakpoint`)
/// so `WindThemeData.screens` overrides and custom screens are honored.
///
/// This is an **escape hatch**. Prefer className-first solutions when the
/// difference is purely stylistic:
/// - `sm:flex-row`, `md:gap-8` — swap styles per breakpoint
/// - `hidden sm:block` / `block sm:hidden` — swap visibility per breakpoint
/// - `order-2 md:order-1` — reorder flex children per breakpoint
///
/// Reach for `WBreakpoint` only when the widget **tree structure** genuinely
/// differs per breakpoint (different widget types, different child counts,
/// fundamentally different layouts).
///
/// ### Resolution Semantics
///
/// 1. Reads active breakpoint via [WindContext.build].
/// 2. Walks the breakpoint chain in descending order by min width, restricted
///    to breakpoints whose min width ≤ the active breakpoint's min width.
/// 3. Returns the first builder found — i.e. the builder for the highest
///    defined breakpoint that is still ≤ the active breakpoint.
/// 4. Falls back to [base] if no matching builder exists.
///
/// ### Supported Features:
/// - Built-in breakpoints: `base`, `sm`, `md`, `lg`, `xl`, `xxl` (named args)
/// - Custom breakpoints via [custom] map (uses `WindThemeData.screens` keys)
/// - Rebuilds naturally on `MediaQuery.size` changes
/// - Respects nested `WindTheme` overrides and test harnesses
///
/// ### Example Usage:
///
/// ```dart
/// // Built-in breakpoints
/// WBreakpoint(
///   base: (ctx) => const MobileTabsScrollable(),
///   sm:   (ctx) => const DistributedTabs(),
/// )
///
/// // Custom breakpoint from WindThemeData.screens
/// WBreakpoint(
///   base: (ctx)   => const MobileTable(),
///   custom: {
///     'tablet': (ctx) => const TabletTable(),
///   },
///   lg: (ctx) => const DesktopTable(),
/// )
/// ```
class WBreakpoint extends StatelessWidget {
  const WBreakpoint({
    super.key,
    required this.base,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.custom = const {},
  });

  /// Fallback builder. Used when no higher breakpoint builder matches.
  final WidgetBuilder base;

  /// Builder for the `sm` breakpoint (default min width 640).
  final WidgetBuilder? sm;

  /// Builder for the `md` breakpoint (default min width 768).
  final WidgetBuilder? md;

  /// Builder for the `lg` breakpoint (default min width 1024).
  final WidgetBuilder? lg;

  /// Builder for the `xl` breakpoint (default min width 1280).
  final WidgetBuilder? xl;

  /// Builder for the `2xl` breakpoint (default min width 1536). Named `xxl`
  /// because Dart identifiers cannot start with a digit; mapped to `2xl` in
  /// `WindThemeData.screens`.
  final WidgetBuilder? xxl;

  /// Builders for custom breakpoint keys defined in `WindThemeData.screens`.
  /// Keys must match exactly (e.g. `'tablet'`, `'wide'`).
  final Map<String, WidgetBuilder> custom;

  @override
  Widget build(BuildContext context) {
    final windContext = WindContext.build(context);
    return _resolve(windContext)(context);
  }

  WidgetBuilder _resolve(WindContext ctx) {
    final builders = <String, WidgetBuilder>{
      if (sm != null) 'sm': sm!,
      if (md != null) 'md': md!,
      if (lg != null) 'lg': lg!,
      if (xl != null) 'xl': xl!,
      if (xxl != null) '2xl': xxl!,
      ...custom,
    };

    if (builders.isEmpty) return base;

    final screens = ctx.theme.screens;
    final sortedActive = screens.entries
        .where((e) => e.value <= (screens[ctx.activeBreakpoint] ?? 0))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    assert(() {
      for (final key in custom.keys) {
        if (!screens.containsKey(key)) {
          throw FlutterError(
            'WBreakpoint: custom breakpoint "$key" is not defined in '
            'WindThemeData.screens. Register it on the theme first, or remove '
            'it from the custom map. Known screens: ${screens.keys.toList()}.',
          );
        }
      }
      return true;
    }());

    for (final entry in sortedActive) {
      final builder = builders[entry.key];
      if (builder != null) return builder;
    }

    return base;
  }
}
