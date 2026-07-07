import 'package:flutter/material.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../state/wind_anchor_state.dart';
import '../state/wind_anchor_state_provider.dart';
import 'select_option.dart';
import 'w_div.dart';
import 'w_input.dart';
import 'w_text.dart';
import '../utils/wind_extensions.dart';
import '../utils/wind_logger.dart';

/// Signature for building a custom trigger widget for [WSelect].
///
/// The [selectedOption] is null when no value is selected.
/// For multi-select, use [MultiSelectTriggerBuilder] instead.
typedef SelectTriggerBuilder<T> = Widget Function(
  BuildContext context,
  SelectOption<T>? selectedOption,
  bool isOpen,
);

/// Signature for building a custom trigger widget for multi-select [WSelect].
typedef MultiSelectTriggerBuilder<T> = Widget Function(
  BuildContext context,
  List<SelectOption<T>> selectedOptions,
  bool isOpen,
);

/// Signature for building a custom item widget for [WSelect].
typedef SelectItemBuilder<T> = Widget Function(
  BuildContext context,
  SelectOption<T> option,
  bool isSelected,
  bool isHovered,
);

/// Signature for building a selected chip/tag in multi-select mode.
typedef SelectedChipBuilder<T> = Widget Function(
  BuildContext context,
  SelectOption<T> option,
  VoidCallback onRemove,
);

/// Signature for building the "create option" button.
typedef CreateOptionBuilder = Widget Function(
    BuildContext context, String query, VoidCallback onCreate);

/// Signature for building the empty state.
typedef EmptyStateBuilder = Widget Function(BuildContext context, String query);

/// Signature for building the loading indicator.
typedef LoadingBuilder = Widget Function(BuildContext context);

/// **The Utility-First Select Component**
///
/// `WSelect` is a highly customizable dropdown widget that combines
/// React-style controlled state management with Tailwind-like utility class styling.
///
/// ### Supported Features:
/// - **Selection:** Single or Multi-select (`isMulti: true`)
/// - **Searchable:** Built-in search input (`searchable: true`)
/// - **Remote Data:** Async search (`onSearch`) and Pagination (`onLoadMore`)
/// - **Tagging:** Create new options on the fly (`onCreateOption`)
/// - **Styling:** `className` (trigger) and `menuClassName` (dropdown)
///
/// ### Example Usage:
///
/// ```dart
/// WSelect<String>(
///   value: _selectedCountry,
///   options: countries,
///   onChange: (value) => setState(() => _selectedCountry = value),
///   className: 'w-64 bg-white border border-gray-300 rounded-lg',
///   menuClassName: 'bg-white shadow-xl rounded-lg border border-gray-100',
/// )
/// ```
///
/// ### Multi-Select Example:
///
/// ```dart
/// WSelect<String>(
///   isMulti: true,
///   values: _selectedTags,
///   options: tags,
///   onMultiChange: (values) => setState(() => _selectedTags = values),
///   searchable: true,
/// )
/// ```
class WSelect<T> extends StatefulWidget {
  // ============== SINGLE SELECT PROPS ==============

  /// The currently selected value (single-select mode).
  final T? value;

  /// Called when the user selects an option (single-select mode).
  final ValueChanged<T>? onChange;

  // ============== MULTI-SELECT PROPS ==============

  /// Whether to enable multi-select mode.
  ///
  /// When true, use `values` and `onMultiChange` instead of `value`/`onChange`.
  final bool isMulti;

  /// The currently selected values (multi-select mode).
  final List<T>? values;

  /// Called when selection changes (multi-select mode).
  final ValueChanged<List<T>>? onMultiChange;

  /// Custom builder for selected chips in multi-select mode.
  final SelectedChipBuilder<T>? selectedChipBuilder;

  // ============== OPTIONS ==============

  /// The list of available options.
  final List<SelectOption<T>> options;

  // ============== SEARCH ==============

  /// Whether the dropdown includes a search input.
  final bool searchable;

  /// Async search callback for fetching filtered options.
  final Future<List<SelectOption<T>>> Function(String query)? onSearch;

  /// Placeholder text for the search input.
  final String searchPlaceholder;

  // ============== TAGGING ==============

  /// Callback to create a new option from search query.
  ///
  /// When provided and search returns no matches, a "Create X" button appears.
  final Future<SelectOption<T>> Function(String query)? onCreateOption;

  /// Custom builder for the "Create X" button.
  final CreateOptionBuilder? createOptionBuilder;

  // ============== PAGINATION ==============

  /// Callback for loading more options (infinite scroll).
  final Future<List<SelectOption<T>>> Function()? onLoadMore;

  /// Whether more pages are available for pagination.
  final bool hasMore;

  // ============== STYLING ==============

  /// Tailwind-like utility classes for the trigger container.
  ///
  /// Supports:
  /// - **Box Model:** `w-64`, `p-3`, `rounded-lg`
  /// - **Visuals:** `bg-white`, `border`, `border-gray-300`
  /// - **States:** `hover:border-blue-500`, `focus:ring-2`
  ///
  /// Example: `'w-full p-2 bg-white border rounded shadow-sm'`
  final String? className;

  /// Tailwind-like utility classes for the dropdown menu container.
  ///
  /// *Note: This container holds the scrollable list.*
  ///
  /// Supports:
  /// - **Box Model:** `rounded-lg`, `border`
  /// - **Shadow:** `shadow-xl`, `shadow-gray-200`
  /// - **Background:** `bg-white` (Recommended)
  ///
  /// Example: `'bg-white border border-gray-100 shadow-lg rounded-xl'`
  final String? menuClassName;

  /// Placeholder text shown when no value is selected.
  final String placeholder;

  /// Whether the select is disabled.
  final bool disabled;

  /// Width of the dropdown menu.
  final double? menuWidth;

  /// Maximum height of the dropdown menu.
  final double maxMenuHeight;

  /// Custom states for dynamic styling.
  final Set<String>? states;

  // ============== CUSTOM BUILDERS ==============

  /// Custom builder for the trigger widget (single-select).
  final SelectTriggerBuilder<T>? triggerBuilder;

  /// Custom builder for the trigger widget (multi-select).
  final MultiSelectTriggerBuilder<T>? multiTriggerBuilder;

  /// Custom builder for option items.
  final SelectItemBuilder<T>? itemBuilder;

  /// Custom builder for empty state.
  final EmptyStateBuilder? emptyBuilder;

  /// Custom builder for loading indicator.
  final LoadingBuilder? loadingBuilder;

  /// Creates a new [WSelect] instance.
  const WSelect({
    super.key,
    // Single select
    this.value,
    this.onChange,
    // Multi select
    this.isMulti = false,
    this.values,
    this.onMultiChange,
    this.selectedChipBuilder,
    // Options
    required this.options,
    // Search
    this.searchable = false,
    this.onSearch,
    this.searchPlaceholder = 'Search...',
    // Tagging
    this.onCreateOption,
    this.createOptionBuilder,
    // Pagination
    this.onLoadMore,
    this.hasMore = false,
    // Styling
    this.className,
    this.menuClassName,
    this.placeholder = 'Select an option',
    this.disabled = false,
    this.menuWidth,
    this.maxMenuHeight = 300,
    this.states,
    // Builders
    this.triggerBuilder,
    this.multiTriggerBuilder,
    this.itemBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
  });

  @override
  State<WSelect<T>> createState() => _WSelectState<T>();
}

class _WSelectState<T> extends State<WSelect<T>> {
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _overlayController = OverlayPortalController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _triggerKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  bool _isOpen = false;
  bool _isHovering = false;
  bool _openUpward = false;

  /// The theme's `primary` swatch, used for the raw [Icon] colors that cannot
  /// take a className. `primary` is always present in the resolved color map
  /// (Wind seeds it into the default theme), so the brand color drives these
  /// icons the same way `bg-primary`/`text-primary` drive the surrounding text.
  MaterialColor get _primaryColor => context.windColors['primary']!;

  /// Shared [TapRegion] group for the trigger and the open menu, so re-tapping
  /// the trigger toggles it closed (the tap is inside the group) rather than
  /// being treated as an outside tap. The opening-tap self-close is handled
  /// separately by deferring the overlay mount one frame (see [_toggleMenu]).
  final Object _tapGroupId = Object();
  String _searchQuery = '';
  List<SelectOption<T>> _filteredOptions = [];
  bool _isSearching = false;
  bool _isLoadingMore = false;
  bool _isCreating = false;
  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(WSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options != oldWidget.options) {
      _filteredOptions = widget.options;
      if (_searchQuery.isNotEmpty) {
        _filterOptions(_searchQuery);
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Handle scroll for infinite scroll pagination
  void _onScroll() {
    if (!widget.hasMore || _isLoadingMore || widget.onLoadMore == null) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 50) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || widget.onLoadMore == null) return;

    setState(() => _isLoadingMore = true);
    try {
      final moreOptions = await widget.onLoadMore!();
      if (mounted) {
        setState(() {
          _filteredOptions = [..._filteredOptions, ...moreOptions];
          _isLoadingMore = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  void _toggleMenu() {
    if (widget.disabled) return;

    if (!_isOpen) {
      // Calculate whether to open upward based on available space
      final RenderBox? triggerBox =
          _triggerKey.currentContext?.findRenderObject() as RenderBox?;
      if (triggerBox != null) {
        final triggerPosition = triggerBox.localToGlobal(Offset.zero);
        final screenHeight = MediaQuery.of(context).size.height;
        final spaceBelow =
            screenHeight - triggerPosition.dy - triggerBox.size.height;
        final menuMaxHeight = widget.maxMenuHeight;
        _openUpward =
            spaceBelow < menuMaxHeight && triggerPosition.dy > spaceBelow;
      }
    }

    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _searchQuery = '';
        _filteredOptions = widget.options;
        _hoveredIndex = -1;
        // Defer the overlay mount to the next frame so the opening tap's own
        // pointer-up is fully dispatched BEFORE the overlay's TapRegion exists.
        // OverlayPortal mounts synchronously, so showing it now routes that
        // same pointer-up to the fresh overlay's onTapOutside, closing the menu
        // on the frame it opened (a one-frame suppress guard is not enough).
        // The shared groupId still stops a trigger re-tap from self-closing.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isOpen) _overlayController.show();
        });
      } else {
        _overlayController.hide();
      }
    });
  }

  void _closeMenu() {
    if (_isOpen) {
      setState(() {
        _isOpen = false;
        _overlayController.hide();
      });
    }
  }

  void _selectOption(SelectOption<T> option) {
    if (option.disabled) return;

    if (widget.isMulti) {
      _toggleMultiSelection(option);
    } else {
      widget.onChange?.call(option.value);
      _closeMenu();
    }
  }

  void _toggleMultiSelection(SelectOption<T> option) {
    final currentValues = List<T>.from(widget.values ?? []);
    final isSelected = currentValues.contains(option.value);

    if (isSelected) {
      currentValues.remove(option.value);
    } else {
      currentValues.add(option.value);
    }

    widget.onMultiChange?.call(currentValues);
    // Don't close menu in multi-select
  }

  void _removeValue(T value) {
    final currentValues = List<T>.from(widget.values ?? []);
    currentValues.remove(value);
    widget.onMultiChange?.call(currentValues);
  }

  /// Deferred setState for hovering to avoid mouse_tracker conflicts
  void _setHovering(bool value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isHovering != value) {
        setState(() => _isHovering = value);
      }
    });
  }

  /// Deferred setState for hovered index to avoid mouse_tracker conflicts
  void _setHoveredIndex(int value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _hoveredIndex != value) {
        setState(() => _hoveredIndex = value);
      }
    });
  }

  Future<void> _createOption() async {
    if (widget.onCreateOption == null || _searchQuery.isEmpty) return;

    setState(() => _isCreating = true);
    try {
      final newOption = await widget.onCreateOption!(_searchQuery);
      if (mounted) {
        _selectOption(newOption);
        setState(() {
          _searchQuery = '';
          _isCreating = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  Future<void> _filterOptions(String query) async {
    _searchQuery = query;

    if (widget.onSearch != null) {
      setState(() => _isSearching = true);
      try {
        final results = await widget.onSearch!(query);
        if (mounted && _searchQuery == query) {
          setState(() {
            _filteredOptions = results;
            _isSearching = false;
          });
        }
      } catch (_) {
        if (mounted) {
          setState(() => _isSearching = false);
        }
      }
    } else {
      // Local filtering
      setState(() {
        if (query.isEmpty) {
          _filteredOptions = widget.options;
        } else {
          _filteredOptions = widget.options
              .where(
                (opt) => opt.label.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
        }
      });
    }
  }

  SelectOption<T>? get _selectedOption {
    if (widget.value == null) return null;
    try {
      return widget.options.firstWhere((opt) => opt.value == widget.value);
    } catch (_) {
      return null;
    }
  }

  List<SelectOption<T>> get _selectedOptions {
    if (widget.values == null || widget.values!.isEmpty) return [];
    return widget.options
        .where((opt) => widget.values!.contains(opt.value))
        .toList();
  }

  bool _isValueSelected(T value) {
    if (widget.isMulti) {
      return widget.values?.contains(value) ?? false;
    }
    return widget.value == value;
  }

  /// Resolves the Semantics label for the closed-trigger state.
  ///
  /// Preference order matches the public contract documented in
  /// `.ac/plans/ai-test-v2/plan.md` Step 1: explicit `placeholder` wins
  /// (it is the caller-supplied trigger label); when no placeholder is
  /// supplied or the placeholder equals the default, the resolver falls
  /// back to the selected option's label so a populated trigger still
  /// surfaces a meaningful accessible name.
  String? _resolveSemanticsLabel() {
    if (widget.placeholder.isNotEmpty) {
      return widget.placeholder;
    }
    if (widget.isMulti) {
      final List<SelectOption<T>> selected = _selectedOptions;
      if (selected.isNotEmpty) {
        return selected.map((SelectOption<T> opt) => opt.label).join(', ');
      }
      return null;
    }
    return _selectedOption?.label;
  }

  @override
  Widget build(BuildContext context) {
    // Accessibility: surface the closed trigger as a `button` SemanticsNode
    // labelled with the placeholder (or the selected option label as
    // fallback) so Playwright `getByRole('button', { name: ... })` resolves
    // on the collapsed dropdown. The MergeSemantics collapses the inner
    // trigger subtree (icon + selected label text) into the parent node.
    return Semantics(
      container: true,
      button: true,
      enabled: !widget.disabled,
      label: _resolveSemanticsLabel(),
      child: MergeSemantics(
        child: OverlayPortal(
          controller: _overlayController,
          overlayChildBuilder: _buildOverlay,
          child: CompositedTransformTarget(
            link: _layerLink,
            child: Focus(
              focusNode: _focusNode,
              child:
                  KeyedSubtree(key: _triggerKey, child: _buildTrigger(context)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrigger(BuildContext context) {
    // Custom trigger builders. Tag them with the shared tap group too, so the
    // open menu's onTapOutside ignores the tap that lands on a custom trigger
    // (a bare GestureDetector would be seen as an outside tap and self-close).
    if (widget.isMulti && widget.multiTriggerBuilder != null) {
      return TapRegion(
        groupId: _tapGroupId,
        child: GestureDetector(
          onTap: _toggleMenu,
          child: MouseRegion(
            onEnter: (_) => _setHovering(true),
            onExit: (_) => _setHovering(false),
            cursor: widget.disabled
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: widget.multiTriggerBuilder!(
              context,
              _selectedOptions,
              _isOpen,
            ),
          ),
        ),
      );
    }

    if (!widget.isMulti && widget.triggerBuilder != null) {
      return TapRegion(
        groupId: _tapGroupId,
        child: GestureDetector(
          onTap: _toggleMenu,
          child: MouseRegion(
            onEnter: (_) => _setHovering(true),
            onExit: (_) => _setHovering(false),
            cursor: widget.disabled
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: widget.triggerBuilder!(context, _selectedOption, _isOpen),
          ),
        ),
      );
    }

    // Build active states (auto-managed states + user's custom states)
    final bool hasSelection = widget.isMulti
        ? (widget.values?.isNotEmpty ?? false)
        : widget.value != null;

    final Set<String> activeStates = {
      ...?widget.states,
      if (widget.disabled) 'disabled',
      if (_isHovering) 'hover',
      if (_isOpen) 'focus',
      if (_isOpen) 'open',
      if (hasSelection) 'selected',
    };

    final String triggerClassName =
        widget.className ?? 'bg-white border border-gray-300 rounded-lg p-3';

    // Logger integration
    final styles = WindParser.parse(
      triggerClassName,
      context,
      states: activeStates,
    );
    final logger = WindLogger(
      debug: styles.debug,
      widgetName: "WSelect (Trigger)",
    );

    if (styles.debug) {
      logger.logStep("ClassName", "'$triggerClassName'");
      logger.setCoreWidget("WDiv -> Trigger Content");
      logger.printFinalCode();
    }

    // Default trigger rendering. Tag it with the shared tap group so the open
    // menu's onTapOutside ignores the tap that opened it.
    return TapRegion(
      groupId: _tapGroupId,
      child: GestureDetector(
        onTap: _toggleMenu,
        child: MouseRegion(
          onEnter: (_) => _setHovering(true),
          onExit: (_) => _setHovering(false),
          cursor: widget.disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: WDiv(
            className: triggerClassName,
            states: activeStates,
            children: [
              WDiv(
                className: 'flex items-center gap-2',
                children: [
                  WDiv(
                    className: 'flex-1',
                    child: widget.isMulti
                        ? _buildMultiSelectTriggerContent()
                        : _buildSingleSelectTriggerContent(),
                  ),
                  Icon(
                    _isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleSelectTriggerContent() {
    final textColor = _selectedOption != null
        ? 'text-gray-800 dark:text-gray-100'
        : 'text-gray-400 dark:text-gray-500';
    return WText(
      _selectedOption?.label ?? widget.placeholder,
      className: '$textColor truncate',
    );
  }

  Widget _buildMultiSelectTriggerContent() {
    if (_selectedOptions.isEmpty) {
      return WText(
        widget.placeholder,
        className: 'text-gray-400 dark:text-gray-500 truncate',
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: WDiv(
        className: 'flex gap-1',
        children: _selectedOptions.map((opt) {
          if (widget.selectedChipBuilder != null) {
            return widget.selectedChipBuilder!(
              context,
              opt,
              () => _removeValue(opt.value),
            );
          }
          return _buildDefaultChip(opt);
        }).toList(),
      ),
    );
  }

  Widget _buildDefaultChip(SelectOption<T> option) {
    return WDiv(
      className: 'flex items-center gap-1 bg-primary-100 rounded px-2 py-0.5',
      children: [
        WText(option.label, className: 'text-primary-800 text-sm'),
        GestureDetector(
          onTap: () => _removeValue(option.value),
          child: Icon(
            Icons.close,
            size: 14,
            color: _primaryColor.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final RenderBox? triggerBox =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final double triggerWidth = triggerBox?.size.width ?? 200;

    final WindStyle menuStyles = widget.menuClassName != null
        ? WindParser.parse(widget.menuClassName!, context)
        : const WindStyle();

    final double menuWidth =
        widget.menuWidth ?? menuStyles.width ?? triggerWidth;
    final double maxHeight =
        menuStyles.constraints?.maxHeight ?? widget.maxMenuHeight;
    final BorderRadius borderRadius =
        (menuStyles.decoration?.borderRadius as BorderRadius?) ??
            BorderRadius.circular(8);

    // Logger integration for Menu
    final logger = WindLogger(
      debug: menuStyles.debug,
      widgetName: "WSelect (Menu)",
    );

    if (menuStyles.debug) {
      logger.logStep("Menu ClassName", "'${widget.menuClassName}'");
      logger.setCoreWidget("OverlayPortal -> Container -> Column");
      logger.printFinalCode();
    }

    return CompositedTransformFollower(
      link: _layerLink,
      targetAnchor: _openUpward ? Alignment.topLeft : Alignment.bottomLeft,
      followerAnchor: _openUpward ? Alignment.bottomLeft : Alignment.topLeft,
      offset: Offset(0, _openUpward ? -4 : 4),
      child: Align(
        alignment: _openUpward ? Alignment.bottomLeft : Alignment.topLeft,
        widthFactor: 1,
        heightFactor: 1,
        child: TapRegion(
          groupId: _tapGroupId,
          onTapOutside: (_) => _closeMenu(),
          child: Material(
            elevation: 0,
            color: Colors.transparent,
            child: Container(
              width: menuWidth,
              constraints: BoxConstraints(maxHeight: maxHeight),
              decoration: menuStyles.decoration ??
                  BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: borderRadius,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: WDiv(
                  className: 'flex flex-col',
                  children: [
                    if (widget.searchable) _buildSearchInput(),
                    Flexible(child: _buildOptionsContent()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return WDiv(
      className: 'p-2',
      child: WInput(
        placeholder: widget.searchPlaceholder,
        autofocus: true,
        className: 'p-2 border border-gray-300 rounded text-sm',
        onChanged: _filterOptions,
      ),
    );
  }

  Widget _buildOptionsContent() {
    if (_isSearching) {
      return widget.loadingBuilder?.call(context) ?? _buildLoadingIndicator();
    }

    if (_filteredOptions.isEmpty) {
      return WDiv(
        className: 'flex flex-col',
        children: [
          widget.emptyBuilder?.call(context, _searchQuery) ??
              _buildEmptyState(),
          if (widget.onCreateOption != null && _searchQuery.isNotEmpty)
            _buildCreateButton(),
        ],
      );
    }

    return _buildOptionsList();
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return WDiv(
      className: 'p-4',
      child: WText('No options found', className: 'text-gray-500'),
    );
  }

  Widget _buildCreateButton() {
    if (widget.createOptionBuilder != null) {
      return widget.createOptionBuilder!(context, _searchQuery, _createOption);
    }

    return GestureDetector(
      onTap: _isCreating ? null : _createOption,
      child: WDiv(
        className: '''
          w-full flex items-center gap-2 px-3 py-2
          hover:bg-gray-50 dark:hover:bg-slate-700
        ''',
        children: [
          if (_isCreating)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Icon(
              Icons.add,
              size: 16,
              color: _primaryColor.shade400,
            ),
          WText(
            'Create "$_searchQuery"',
            className: 'text-primary-500 dark:text-primary-400 font-medium',
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList() {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: _filteredOptions.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading at bottom for pagination
        if (index == _filteredOptions.length) {
          return _buildLoadingIndicator();
        }

        final option = _filteredOptions[index];
        final isSelected = _isValueSelected(option.value);
        final isHovered = index == _hoveredIndex;

        return _buildOptionItem(option, isSelected, isHovered, index);
      },
    );
  }

  Widget _buildOptionItem(
    SelectOption<T> option,
    bool isSelected,
    bool isHovered,
    int index,
  ) {
    if (widget.itemBuilder != null) {
      return GestureDetector(
        onTap: () => _selectOption(option),
        child: MouseRegion(
          onEnter: (_) => _setHoveredIndex(index),
          onExit: (_) => _setHoveredIndex(-1),
          cursor: option.disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: widget.itemBuilder!(context, option, isSelected, isHovered),
        ),
      );
    }

    final String bgClass = isSelected
        ? 'bg-primary-50 dark:bg-primary-900/30'
        : isHovered
            ? 'bg-gray-100 dark:bg-slate-700'
            : 'bg-transparent';
    final String textColorClass = option.disabled
        ? 'text-gray-400 dark:text-gray-500'
        : isSelected
            ? 'text-primary-700 dark:text-primary-300 font-medium'
            : 'text-gray-800 dark:text-gray-200';

    return WindAnchorStateProvider(
      state: WindAnchorState(
        isHovering: isHovered,
        isFocused: false,
        isDisabled: option.disabled,
      ),
      child: GestureDetector(
        onTap: () => _selectOption(option),
        child: MouseRegion(
          onEnter: (_) => _setHoveredIndex(index),
          onExit: (_) => _setHoveredIndex(-1),
          cursor: option.disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: WDiv(
            className: 'flex items-center gap-2 px-3 py-2 $bgClass',
            children: [
              if (widget.isMulti)
                Icon(
                  isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 18,
                  color: isSelected
                      ? _primaryColor.shade600
                      : Colors.grey.shade400,
                ),
              if (option.icon != null) option.icon!,
              WDiv(
                className: 'flex-1',
                child: WText(option.label, className: textColorClass),
              ),
              if (!widget.isMulti && isSelected)
                Icon(
                  Icons.check,
                  size: 18,
                  color: _primaryColor.shade600,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
