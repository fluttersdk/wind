import 'package:flutter/widgets.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../utils/wind_logger.dart';
import 'w_anchor.dart';
import 'w_div.dart';
import 'w_text.dart';

/// **A Utility-First Tabs Component**
///
/// `WTabs` is a controlled tabs widget that renders a tab list and a content
/// panel driven by [selectedIndex]. Each tab is a [WAnchor] wrapping a [WDiv],
/// with the `selected:` state active on the currently-selected tab so callers
/// can supply `selected:border-b-2 selected:text-blue-600` tokens through
/// [tabClassName] or [selectedTabClassName].
///
/// This is a controlled widget: [selectedIndex] must be managed by the caller.
/// Use [onChanged] to react to tab taps.
///
/// ### Supported Features:
/// - **Controlled:** [selectedIndex] + [onChanged], no internal state.
/// - **Selected state:** `selected:` className prefix activates on the active tab.
/// - **Slot classNames:** [listClassName], [tabClassName], [selectedTabClassName],
///   [panelClassName] for each structural region.
/// - **Panel builder:** [panelBuilder] receives the selected index each rebuild.
///
/// ### Example Usage:
///
/// ```dart
/// WTabs(
///   tabs: const ['Overview', 'Details', 'Settings'],
///   selectedIndex: _selectedTab,
///   onChanged: (i) => setState(() => _selectedTab = i),
///   listClassName: 'flex flex-row border-b border-gray-200 dark:border-gray-700',
///   tabClassName: '''
///     px-4 py-2 text-sm text-gray-500 dark:text-gray-400
///     selected:text-blue-600 dark:selected:text-blue-400
///     selected:border-b-2 selected:border-blue-600
///   ''',
///   panelClassName: 'pt-4',
///   panelBuilder: (index) => _panels[index],
/// )
/// ```
///
/// See also:
///
///  * [WAnchor], which provides the interaction state (hover, focus) for each tab.
///  * [WDiv], which is the structural container for the tab list and panel.
class WTabs extends StatelessWidget {
  /// The labels rendered for each tab, in display order.
  final List<String> tabs;

  /// The zero-based index of the currently selected tab.
  final int selectedIndex;

  /// Called when the user taps a tab, with its zero-based index.
  ///
  /// The caller is responsible for updating [selectedIndex] in response.
  final ValueChanged<int>? onChanged;

  /// Builder that returns the panel content for the currently selected tab.
  ///
  /// Receives the current [selectedIndex].
  final Widget Function(int index) panelBuilder;

  /// Utility classes for the outer tab-list row container.
  ///
  /// Example: `'flex flex-row border-b border-gray-200'`
  final String? listClassName;

  /// Utility classes applied to every tab's inner [WDiv].
  ///
  /// Supports `selected:` prefix tokens; they activate only on the selected tab.
  ///
  /// Example: `'px-4 py-2 text-sm text-gray-600 selected:text-blue-600'`
  final String? tabClassName;

  /// Extra utility classes appended to the active tab's [WDiv] only.
  ///
  /// Applied after [tabClassName] so callers can supply active-only tokens here
  /// without repeating them in [tabClassName] or adding `selected:` prefixes.
  ///
  /// Example: `'border-b-2 border-blue-600'`
  final String? selectedTabClassName;

  /// Utility classes for the panel wrapper [WDiv].
  ///
  /// Example: `'pt-4'`
  final String? panelClassName;

  /// Whether the tab list stretches to the full container width.
  ///
  /// A `flex-row` [WDiv] is content-width by default, so a `border-b` underline
  /// on [listClassName] would span only the tabs, not the container. With this
  /// `true` (the default), `w-full` is prepended to the tab list so the baseline
  /// rule spans the full width, the common tab design. The tabs themselves stay
  /// content-sized (left-aligned via the default `justify-start`). When
  /// [listClassName] already carries its own width token (`w-*`), that width is
  /// respected and `w-full` is NOT prepended, so an explicit width always wins.
  /// Set to `false` for a content-width tab strip (e.g. centered pill tabs).
  final bool fullWidthList;

  /// Creates a [WTabs] widget.
  ///
  /// The constructor is not `const`: the [tabs] non-emptiness and
  /// [selectedIndex] range asserts read `tabs.length`, which is not a valid
  /// constant expression, so a `const` constructor cannot host them.
  WTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.panelBuilder,
    this.onChanged,
    this.listClassName,
    this.tabClassName,
    this.selectedTabClassName,
    this.panelClassName,
    this.fullWidthList = true,
  })  : assert(tabs.isNotEmpty, 'WTabs: tabs must not be empty.'),
        assert(
          selectedIndex >= 0 && selectedIndex < tabs.length,
          'WTabs: selectedIndex must be within the tabs range.',
        );

  @override
  Widget build(BuildContext context) {
    // 1. Parse panel className for debug: delegates the tab-level parse to each tab builder.
    final WindStyle panelStyles = panelClassName != null
        ? WindParser.parse(panelClassName!, context)
        : const WindStyle();

    final logger = WindLogger(
      debug: panelStyles.debug,
      widgetName: runtimeType.toString(),
    );

    if (panelStyles.debug) {
      logger.logStep('tabs', tabs.toString());
      logger.logStep('selectedIndex', selectedIndex.toString());
      logger.setCoreWidget('WDiv(list) + WDiv(panel)');
      logger.printFinalCode();
    }

    // 2. Build the tab list row. Prepend w-full so a border-b baseline spans
    //    the full container width, UNLESS the caller opted out or already set
    //    their own width token: w-full and an explicit w-* target different
    //    WindStyle fields (widthFactor vs width), so adding both would be
    //    ambiguous. Skipping the prepend lets an explicit width win cleanly.
    final bool prependFullWidth =
        fullWidthList && !_hasWidthToken(listClassName);
    final String? effectiveListClassName = _joinClassNames([
      if (prependFullWidth) 'w-full',
      listClassName,
    ]);
    final Widget tabList = WDiv(
      className: effectiveListClassName,
      children: List<Widget>.generate(tabs.length, (index) {
        return _buildTab(context, index);
      }),
    );

    // 3. Build the panel for the current selection.
    final Widget panel = WDiv(
      className: panelClassName,
      child: panelBuilder(selectedIndex),
    );

    // 4. Compose the full tabs widget (list above panel).
    return WDiv(
      children: [
        tabList,
        panel,
      ],
    );
  }

  /// Builds a single tab at [index], threading the [selected] state into the
  /// [WAnchor] and the [WDiv] when this is the active tab.
  Widget _buildTab(BuildContext context, int index) {
    final bool isSelected = index == selectedIndex;

    // A null onChanged makes the whole tab strip non-interactive: mark each tab
    // disabled so WAnchor reports `enabled: false`, suppresses hover/focus, and
    // activates `disabled:` className tokens via the state provider.
    final bool isDisabled = onChanged == null;

    // The `selected:` state activates className tokens like
    // `selected:text-blue-600` or `selected:border-b-2` on the active tab.
    final Set<String> tabStates = {
      if (isSelected) 'selected',
      if (isDisabled) 'disabled',
    };

    // Build the effective tab className:
    // base tabClassName ++ selectedTabClassName (active tab only).
    final String? effectiveTabClassName = _joinClassNames([
      tabClassName,
      if (isSelected) selectedTabClassName,
    ]);

    return WAnchor(
      // Only attach a gesture when a callback exists; a null onChanged keeps
      // the tab non-interactive instead of a no-op tappable surface.
      onTap: isDisabled ? null : () => onChanged!.call(index),
      isDisabled: isDisabled,
      states: tabStates,
      child: WDiv(
        className: effectiveTabClassName,
        states: tabStates,
        child: WText(tabs[index]),
      ),
    );
  }

  /// Joins a list of nullable className strings into a single non-null string,
  /// trimming and skipping blanks.
  static String? _joinClassNames(List<String?> parts) {
    final joined = parts
        .where((p) => p != null && p.trim().isNotEmpty)
        .map((p) => p!.trim())
        .join(' ');
    return joined.isEmpty ? null : joined;
  }

  /// Whether [className] already carries a width token (`w-full`, `w-32`,
  /// `w-1/2`, `w-screen`, `w-[..]`, including a state/breakpoint variant), so
  /// the auto `w-full` prepend should be skipped and the caller's width respected.
  /// `min-w-*` / `max-w-*` are constraints, not a width, so they do not count.
  static bool _hasWidthToken(String? className) {
    if (className == null) return false;
    for (final raw in className.split(RegExp(r'\s+'))) {
      if (raw.isEmpty) continue;
      final token = raw.contains(':') ? raw.split(':').last : raw;
      if (token.startsWith('w-')) return true;
    }
    return false;
  }
}
