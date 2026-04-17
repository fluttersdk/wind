import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// **Order Parser**
///
/// Parses `order-*` utilities that control the position of a child within a
/// flex container, mirroring Tailwind's `order` property. The parent flex
/// container (typically a `WDiv`) resolves the order of each child and
/// stable-sorts them before layout.
///
/// ### Supported Utility Classes:
/// - `order-0` .. `order-12` — explicit index
/// - `order-first` — sentinel `-9999`
/// - `order-last` — sentinel `9999`
/// - `order-none` — reset to `0`
/// - `order-[N]` — arbitrary integer value (supports negative)
///
/// Prefixes such as `sm:`, `dark:`, `hover:` are stripped by the orchestrator
/// before classes reach this parser; the full responsive + state stack works
/// out of the box (e.g. `sm:order-last`, `lg:dark:order-first`).
///
/// Children without any `order-*` class default to `0` in the parent's sort.
class OrderParser implements WindParserInterface {
  const OrderParser();

  static final RegExp _orderRegex = RegExp(
    r'^order-(?<value>first|last|none|\d+|\[-?\d+\])$',
  );

  static const int _first = -9999;
  static const int _last = 9999;

  @override
  bool canParse(String className) {
    // Fast path — `canParse` must stay O(1). We match the literal prefix and
    // let `parse` do the full regex validation.
    return className.startsWith('order-');
  }

  @override
  WindStyle parse(
    WindStyle styles,
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null) return styles;

    int? order;

    // Reverse iteration — last class wins, consistent with other parsers.
    for (var i = classes.length - 1; i >= 0; i--) {
      final match = _orderRegex.firstMatch(classes[i]);
      if (match == null) continue;

      final raw = match.namedGroup('value')!;
      if (raw == 'first') {
        order = _first;
      } else if (raw == 'last') {
        order = _last;
      } else if (raw == 'none') {
        order = 0;
      } else if (raw.startsWith('[')) {
        order = int.tryParse(raw.substring(1, raw.length - 1));
      } else {
        order = int.tryParse(raw);
      }
      if (order != null) break;
    }

    if (order == null) return styles;
    return styles.copyWith(order: order);
  }
}
