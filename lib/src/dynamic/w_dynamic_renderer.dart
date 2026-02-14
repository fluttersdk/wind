import 'package:flutter/material.dart';

import '../../fluttersdk_wind.dart';

/// Renders a widget tree from JSON configuration.
///
/// Supports Wind widgets, Flutter core widgets, and custom widget builders.
/// Enforces security via whitelist, depth limits, and action handler integration.
///
/// Example JSON structure:
/// ```json
/// {
///   "type": "WDiv",
///   "props": {
///     "className": "flex gap-4 p-6",
///     "id": "container1"
///   },
///   "children": [
///     {
///       "type": "WText",
///       "props": {"text": "Hello", "className": "text-xl"}
///     }
///   ]
/// }
/// ```
class WindDynamicRenderer {
  final WindDynamicConfig config;
  final WindActionHandler actionHandler;
  final WindDynamicState state;

  const WindDynamicRenderer({
    required this.config,
    required this.actionHandler,
    required this.state,
  });

  /// Build a widget tree from JSON.
  Widget build(dynamic json) {
    return _buildRecursive(json, depth: 0);
  }

  Widget _buildRecursive(dynamic json, {required int depth}) {
    // Depth limit check
    if (depth > config.maxDepth) {
      return _buildError(
        'MaxDepth',
        'Recursion depth exceeded ${config.maxDepth}',
      );
    }

    // Null/empty check
    if (json == null) {
      return const SizedBox.shrink();
    }

    // Convert to safe map
    final Map<String, dynamic> safeJson = _deepConvertMap(json);

    if (safeJson.isEmpty) {
      return const SizedBox.shrink();
    }

    // Extract type and props
    final String type = safeJson['type'] ?? 'Unknown';
    final dynamic propsRaw = safeJson['props'];
    final Map<String, dynamic> props =
        propsRaw is Map ? _deepConvertMap(propsRaw) : <String, dynamic>{};

    // Extract children
    final List<dynamic> childrenRaw = safeJson['children'] ?? [];
    final List<Widget> children = childrenRaw
        .map((child) => _buildRecursive(child, depth: depth + 1))
        .toList();

    // Check whitelist
    if (!config.isAllowed(type)) {
      if (config.onUnknownWidget != null) {
        return config.onUnknownWidget!(type, props);
      }
      return _buildError('Denied', 'Widget type "$type" is not allowed');
    }

    // Try custom builder first
    if (config.builders.containsKey(type)) {
      try {
        return config.builders[type]!(props, children);
      } catch (e) {
        return _handleError(type, e);
      }
    }

    // Build widget by type
    try {
      return _buildByType(type, props, children);
    } catch (e) {
      return _handleError(type, e);
    }
  }

  Widget _buildByType(
    String type,
    Map<String, dynamic> props,
    List<Widget> children,
  ) {
    // Wind widgets
    switch (type) {
      case 'WDiv':
        return _buildWDiv(props, children);
      case 'WText':
        return _buildWText(props);
      case 'WButton':
        return _buildWButton(props, children);
      case 'WImage':
        return _buildWImage(props);
      case 'WIcon':
        return _buildWIcon(props);
      case 'WAnchor':
        return _buildWAnchor(props, children);
      case 'WInput':
        return _buildWInput(props);
      case 'WCheckbox':
        return _buildWCheckbox(props);
      case 'WSvg':
        return _buildWSvg(props);
      case 'WSelect':
        return _buildWSelect(props);
      case 'WPopover':
        return _buildWPopover(props, children);
      case 'WDatePicker':
        return _buildWDatePicker(props);
      case 'WSpacer':
        return _buildWSpacer(props);
    }

    // Flutter core widgets
    switch (type) {
      case 'Column':
        return _buildColumn(props, children);
      case 'Row':
        return _buildRow(props, children);
      case 'Center':
        return _buildCenter(children);
      case 'SizedBox':
        return _buildSizedBox(props, children);
      case 'Expanded':
        return _buildExpanded(props, children);
      case 'Container':
        return _buildContainer(props, children);
      case 'Wrap':
        return _buildWrap(props, children);
      case 'Stack':
        return _buildStack(props, children);
      case 'Positioned':
        return _buildPositioned(props, children);
      case 'Padding':
        return _buildPadding(props, children);
      case 'Align':
        return _buildAlign(props, children);
      case 'Opacity':
        return _buildOpacity(props, children);
      case 'AspectRatio':
        return _buildAspectRatio(props, children);
      case 'FittedBox':
        return _buildFittedBox(props, children);
      case 'ClipRRect':
        return _buildClipRRect(props, children);
      case 'Spacer':
        return _buildSpacer(props);
    }

    // Should never reach here if whitelist is correct
    return _buildError('Unknown', 'No builder for type "$type"');
  }

  // ============================================================
  // Wind Widget Builders
  // ============================================================

  Widget _buildWDiv(Map<String, dynamic> props, List<Widget> children) {
    return WDiv(
      className: props['className'],
      child: children.length == 1 ? children.first : null,
      children: children.length != 1 ? children : null,
    );
  }

  Widget _buildWText(Map<String, dynamic> props) {
    final String text = props['text']?.toString() ?? props['value']?.toString() ?? '';
    return WText(text, className: props['className']);
  }

  Widget _buildWButton(Map<String, dynamic> props, List<Widget> children) {
    final onTap = actionHandler.parseAction(props['onTap']);
    return WButton(
      onTap: onTap,
      className: props['className'],
      disabled: props['disabled'] == true,
      isLoading: props['isLoading'] == true,
      child: children.isNotEmpty ? children.first : const SizedBox.shrink(),
    );
  }

  Widget _buildWImage(Map<String, dynamic> props) {
    final String? src = props['src'];
    if (src == null || src.isEmpty) {
      return const SizedBox.shrink();
    }
    return WImage(src: src, className: props['className']);
  }

  Widget _buildWIcon(Map<String, dynamic> props) {
    final IconData icon = _parseIcon(props['icon']);
    return WIcon(icon, className: props['className']);
  }

  Widget _buildWAnchor(Map<String, dynamic> props, List<Widget> children) {
    final onTap = actionHandler.parseAction(props['onTap']);
    final child = children.isEmpty
        ? const SizedBox.shrink()
        : children.length == 1
            ? children.first
            : WDiv(children: children);
    return WAnchor(onTap: onTap, child: child);
  }

  Widget _buildWInput(Map<String, dynamic> props) {
    final String? id = props['id'];
    final String initialValue = props['value']?.toString() ?? '';
    final InputType type = _parseInputType(props['type']);
    final String? placeholder = props['placeholder'];

    // Read current value from state if id exists
    final String value = id != null && state.has(id)
        ? (state.get(id)?.toString() ?? initialValue)
        : initialValue;

    // Parse onChange action
    final onChanged = actionHandler.parseValueAction<String>(
      props['onChange'],
      stateId: id,
    );

    return WInput(
      value: value,
      onChanged: onChanged,
      type: type,
      placeholder: placeholder,
      className: props['className'],
    );
  }

  Widget _buildWCheckbox(Map<String, dynamic> props) {
    final String? id = props['id'];
    final bool initialValue = props['checked'] == true || props['value'] == true;

    // Read current value from state if id exists
    final bool value = id != null && state.has(id)
        ? (state.get(id) == true)
        : initialValue;

    // Parse onChange action
    final onChanged = actionHandler.parseValueAction<bool>(
      props['onChange'],
      stateId: id,
    );

    return WCheckbox(
      value: value,
      onChanged: onChanged,
      className: props['className'],
    );
  }

  Widget _buildWSvg(Map<String, dynamic> props) {
    final String? svgContent = props['svgContent'];
    final String? assetPath = props['asset'];

    if (svgContent != null && svgContent.isNotEmpty) {
      return WSvg.string(svgContent, className: props['className']);
    } else if (assetPath != null && assetPath.isNotEmpty) {
      return WSvg(src: assetPath, className: props['className']);
    }

    // Fallback icon
    return WIcon(Icons.image_outlined, className: props['className']);
  }

  Widget _buildWSelect(Map<String, dynamic> props) {
    final String? id = props['id'];
    final dynamic initialValue = props['value'];
    final List<dynamic> optionsRaw = props['options'] ?? [];

    // Parse options
    final List<SelectOption> options = optionsRaw.map((opt) {
      if (opt is Map) {
        final optMap = _deepConvertMap(opt);
        return SelectOption(
          value: optMap['value'],
          label: optMap['label']?.toString() ?? optMap['value']?.toString() ?? '',
        );
      }
      // Simple string option
      return SelectOption(value: opt, label: opt.toString());
    }).toList();

    // Read current value from state if id exists
    final dynamic value = id != null && state.has(id)
        ? state.get(id)
        : initialValue;

    // Parse onChange action
    final onChanged = actionHandler.parseValueAction<dynamic>(
      props['onChange'],
      stateId: id,
    );

    return WSelect(
      value: value,
      options: options,
      onChange: onChanged,
      placeholder: props['placeholder'],
      className: props['className'],
    );
  }

  Widget _buildWPopover(Map<String, dynamic> props, List<Widget> children) {
    // First child is trigger, second is content
    final Widget triggerWidget = children.isNotEmpty ? children.first : const SizedBox.shrink();
    final Widget contentWidget = children.length > 1 ? children[1] : const SizedBox.shrink();

    return WPopover(
      triggerBuilder: (context, isOpen, isHovering) => triggerWidget,
      contentBuilder: (context, close) => contentWidget,
      className: props['className'],
    );
  }

  Widget _buildWDatePicker(Map<String, dynamic> props) {
    final String? id = props['id'];
    final dynamic initialValueRaw = props['value'];
    DateTime? initialValue;

    if (initialValueRaw is String) {
      initialValue = DateTime.tryParse(initialValueRaw);
    } else if (initialValueRaw is DateTime) {
      initialValue = initialValueRaw;
    }

    // Read current value from state if id exists
    final DateTime? value = id != null && state.has(id)
        ? (state.get(id) as DateTime?)
        : initialValue;

    // Parse onChange action
    final actionCallback = actionHandler.parseAction(props['onChange']);

    return WDatePicker(
      value: value,
      onChanged: (DateTime date) {
        if (id != null) {
          state.set(id, date);
        }
        actionCallback?.call();
      },
      placeholder: props['placeholder'] ?? 'Select a date',
      className: props['className'],
    );
  }

  Widget _buildWSpacer(Map<String, dynamic> props) {
    return WSpacer(className: props['className']);
  }

  // ============================================================
  // Flutter Core Widget Builders
  // ============================================================

  Widget _buildColumn(Map<String, dynamic> props, List<Widget> children) {
    return Column(
      mainAxisSize: _parseMainAxisSize(props['mainAxisSize']),
      mainAxisAlignment: _parseMainAxisAlignment(props['mainAxisAlignment']),
      crossAxisAlignment: _parseCrossAxisAlignment(props['crossAxisAlignment']),
      children: children,
    );
  }

  Widget _buildRow(Map<String, dynamic> props, List<Widget> children) {
    return Row(
      mainAxisSize: _parseMainAxisSize(props['mainAxisSize']),
      mainAxisAlignment: _parseMainAxisAlignment(props['mainAxisAlignment']),
      crossAxisAlignment: _parseCrossAxisAlignment(props['crossAxisAlignment']),
      children: children,
    );
  }

  Widget _buildCenter(List<Widget> children) {
    return Center(child: children.isNotEmpty ? children.first : null);
  }

  Widget _buildSizedBox(Map<String, dynamic> props, List<Widget> children) {
    return SizedBox(
      width: _parseDouble(props['width']),
      height: _parseDouble(props['height']),
      child: children.isNotEmpty ? children.first : null,
    );
  }

  Widget _buildExpanded(Map<String, dynamic> props, List<Widget> children) {
    return Expanded(
      flex: _parseInt(props['flex']) ?? 1,
      child: children.isNotEmpty ? children.first : const SizedBox.shrink(),
    );
  }

  Widget _buildContainer(Map<String, dynamic> props, List<Widget> children) {
    return SizedBox(
      width: _parseDouble(props['width']),
      height: _parseDouble(props['height']),
      child: children.isNotEmpty ? children.first : null,
    );
  }

  Widget _buildWrap(Map<String, dynamic> props, List<Widget> children) {
    return Wrap(
      spacing: _parseDouble(props['spacing']) ?? 0.0,
      runSpacing: _parseDouble(props['runSpacing']) ?? 0.0,
      alignment: _parseWrapAlignment(props['alignment']),
      children: children,
    );
  }

  Widget _buildStack(Map<String, dynamic> props, List<Widget> children) {
    return Stack(
      alignment: _parseAlignmentGeometry(props['alignment']),
      fit: _parseStackFit(props['fit']),
      children: children,
    );
  }

  Widget _buildPositioned(Map<String, dynamic> props, List<Widget> children) {
    return Positioned(
      top: _parseDouble(props['top']),
      bottom: _parseDouble(props['bottom']),
      left: _parseDouble(props['left']),
      right: _parseDouble(props['right']),
      width: _parseDouble(props['width']),
      height: _parseDouble(props['height']),
      child: children.isNotEmpty ? children.first : const SizedBox.shrink(),
    );
  }

  Widget _buildPadding(Map<String, dynamic> props, List<Widget> children) {
    final double? all = _parseDouble(props['padding']);
    final EdgeInsets padding = all != null
        ? EdgeInsets.all(all)
        : EdgeInsets.only(
            top: _parseDouble(props['top']) ?? 0,
            bottom: _parseDouble(props['bottom']) ?? 0,
            left: _parseDouble(props['left']) ?? 0,
            right: _parseDouble(props['right']) ?? 0,
          );

    return Padding(
      padding: padding,
      child: children.isNotEmpty ? children.first : null,
    );
  }

  Widget _buildAlign(Map<String, dynamic> props, List<Widget> children) {
    return Align(
      alignment: _parseAlignmentGeometry(props['alignment']),
      widthFactor: _parseDouble(props['widthFactor']),
      heightFactor: _parseDouble(props['heightFactor']),
      child: children.isNotEmpty ? children.first : null,
    );
  }

  Widget _buildOpacity(Map<String, dynamic> props, List<Widget> children) {
    return Opacity(
      opacity: _parseDouble(props['opacity']) ?? 1.0,
      child: children.isNotEmpty ? children.first : null,
    );
  }

  Widget _buildAspectRatio(Map<String, dynamic> props, List<Widget> children) {
    return AspectRatio(
      aspectRatio: _parseDouble(props['aspectRatio']) ?? 1.0,
      child: children.isNotEmpty ? children.first : null,
    );
  }

  Widget _buildFittedBox(Map<String, dynamic> props, List<Widget> children) {
    return FittedBox(
      fit: _parseBoxFit(props['fit']),
      alignment: _parseAlignmentGeometry(props['alignment']),
      child: children.isNotEmpty ? children.first : null,
    );
  }

  Widget _buildClipRRect(Map<String, dynamic> props, List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_parseDouble(props['borderRadius']) ?? 0),
      child: children.isNotEmpty ? children.first : null,
    );
  }

  Widget _buildSpacer(Map<String, dynamic> props) {
    return Spacer(flex: _parseInt(props['flex']) ?? 1);
  }

  // ============================================================
  // Parsing Utilities
  // ============================================================

  Map<String, dynamic> _deepConvertMap(dynamic input) {
    if (input is! Map) return {};
    return input.map((key, value) {
      final String newKey = key.toString();
      dynamic newValue = value;
      if (value is Map) {
        newValue = _deepConvertMap(value);
      } else if (value is List) {
        newValue = value.map((e) => e is Map ? _deepConvertMap(e) : e).toList();
      }
      return MapEntry(newKey, newValue);
    });
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  InputType _parseInputType(dynamic type) {
    if (type is! String) return InputType.text;
    return switch (type.toLowerCase()) {
      'email' => InputType.email,
      'password' => InputType.password,
      'number' => InputType.number,
      'multiline' || 'textarea' => InputType.multiline,
      _ => InputType.text,
    };
  }

  IconData _parseIcon(dynamic iconName) {
    if (iconName is IconData) return iconName;
    if (iconName is! String) return Icons.help_outline;

    const iconMap = {
      'star': Icons.star,
      'star_outline': Icons.star_outline,
      'home': Icons.home,
      'person': Icons.person,
      'check': Icons.check,
      'close': Icons.close,
      'settings': Icons.settings,
      'search': Icons.search,
      'add': Icons.add,
      'edit': Icons.edit,
      'delete': Icons.delete,
      'favorite': Icons.favorite,
      'favorite_outline': Icons.favorite_outline,
      'mail': Icons.mail,
      'menu': Icons.menu,
      'info': Icons.info,
      'warning': Icons.warning,
      'error': Icons.error,
      'help': Icons.help,
      'code': Icons.code,
      'chevron_left': Icons.chevron_left,
      'chevron_right': Icons.chevron_right,
      'arrow_back': Icons.arrow_back,
      'arrow_forward': Icons.arrow_forward,
    };

    return iconMap[iconName.toLowerCase()] ?? Icons.help_outline;
  }

  MainAxisSize _parseMainAxisSize(dynamic value) {
    if (value is! String) return MainAxisSize.min;
    return switch (value.toLowerCase()) {
      'max' => MainAxisSize.max,
      _ => MainAxisSize.min,
    };
  }

  MainAxisAlignment _parseMainAxisAlignment(dynamic value) {
    if (value is! String) return MainAxisAlignment.start;
    return switch (value.toLowerCase()) {
      'center' => MainAxisAlignment.center,
      'end' => MainAxisAlignment.end,
      'spacebetween' || 'space-between' => MainAxisAlignment.spaceBetween,
      'spacearound' || 'space-around' => MainAxisAlignment.spaceAround,
      'spaceevenly' || 'space-evenly' => MainAxisAlignment.spaceEvenly,
      _ => MainAxisAlignment.start,
    };
  }

  CrossAxisAlignment _parseCrossAxisAlignment(dynamic value) {
    if (value is! String) return CrossAxisAlignment.center;
    return switch (value.toLowerCase()) {
      'start' => CrossAxisAlignment.start,
      'end' => CrossAxisAlignment.end,
      'stretch' => CrossAxisAlignment.stretch,
      'baseline' => CrossAxisAlignment.baseline,
      _ => CrossAxisAlignment.center,
    };
  }

  WrapAlignment _parseWrapAlignment(dynamic value) {
    if (value is! String) return WrapAlignment.start;
    return switch (value.toLowerCase()) {
      'center' => WrapAlignment.center,
      'end' => WrapAlignment.end,
      'spacebetween' || 'space-between' => WrapAlignment.spaceBetween,
      'spacearound' || 'space-around' => WrapAlignment.spaceAround,
      'spaceevenly' || 'space-evenly' => WrapAlignment.spaceEvenly,
      _ => WrapAlignment.start,
    };
  }

  AlignmentGeometry _parseAlignmentGeometry(dynamic value) {
    if (value is! String) return Alignment.center;
    return switch (value.toLowerCase()) {
      'topleft' || 'top-left' => Alignment.topLeft,
      'topcenter' || 'top-center' => Alignment.topCenter,
      'topright' || 'top-right' => Alignment.topRight,
      'centerleft' || 'center-left' => Alignment.centerLeft,
      'center' => Alignment.center,
      'centerright' || 'center-right' => Alignment.centerRight,
      'bottomleft' || 'bottom-left' => Alignment.bottomLeft,
      'bottomcenter' || 'bottom-center' => Alignment.bottomCenter,
      'bottomright' || 'bottom-right' => Alignment.bottomRight,
      _ => Alignment.center,
    };
  }

  StackFit _parseStackFit(dynamic value) {
    if (value is! String) return StackFit.loose;
    return switch (value.toLowerCase()) {
      'expand' => StackFit.expand,
      'passthrough' => StackFit.passthrough,
      _ => StackFit.loose,
    };
  }

  BoxFit _parseBoxFit(dynamic value) {
    if (value is! String) return BoxFit.contain;
    return switch (value.toLowerCase()) {
      'fill' => BoxFit.fill,
      'cover' => BoxFit.cover,
      'fitwidth' || 'fit-width' => BoxFit.fitWidth,
      'fitheight' || 'fit-height' => BoxFit.fitHeight,
      'none' => BoxFit.none,
      'scaledown' || 'scale-down' => BoxFit.scaleDown,
      _ => BoxFit.contain,
    };
  }

  // ============================================================
  // Error Handling
  // ============================================================

  Widget _handleError(String type, Object error) {
    if (config.onError != null) {
      return config.onError!(type, error);
    }
    return _buildError(type, error.toString());
  }

  Widget _buildError(String type, String message) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Error: $type',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: const TextStyle(color: Colors.red, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
