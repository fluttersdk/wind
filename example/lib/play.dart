import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:web/web.dart' as web;

void main() {
  runApp(const WindPlaygroundApp());
}

/// Wind Playground App - Renders Wind widgets from JSON received via postMessage
class WindPlaygroundApp extends StatelessWidget {
  const WindPlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      data: WindThemeData(
        colors: {'primary': Colors.indigo, 'secondary': Colors.teal},
      ),
      builder: (context, controller) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: controller.data.toThemeData(),
          home: const PlaygroundScreen(),
        );
      },
    );
  }
}

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  Widget? _renderedWidget;
  bool _autoCenter = true;
  bool _autoOverflow = true;
  String _themeMode = 'dark';

  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _renderDefaultState();

    if (kIsWeb) {
      _listenToWebMessages();
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  void _renderDefaultState() {
    // Don't render default widget - wait for actual content from parent
    // This prevents the default "Wind Playground" card from briefly appearing
    setState(() {
      _renderedWidget = null;
    });
  }

  void _listenToWebMessages() {
    _messageSubscription = web.window.onMessage.listen((
      web.MessageEvent event,
    ) {
      final data = event.data.dartify();
      if (data is Map) {
        final type = data['type'];

        if (type == 'RENDER_JSON' && data['payload'] != null) {
          // Also handle options if present in RENDER_JSON
          if (data['options'] != null) {
            _handleUpdateOptions(data['options']);
          }
          _handleRenderJson(data['payload']);
        } else if (type == 'UPDATE_OPTIONS') {
          _handleUpdateOptions(data);
        }
      }
    });
  }

  void _handleRenderJson(dynamic payload) {
    debugPrint("Playground: Received RENDER_JSON");

    if (payload is String) {
      try {
        payload = jsonDecode(payload);
      } catch (e) {
        debugPrint("Playground: JSON decode error -> $e");
        _showError("JSON Parse Error: $e");
        return;
      }
    }

    if (payload is Map<String, dynamic>) {
      _renderJson(payload);
    } else if (payload is Map) {
      _renderJson(Map<String, dynamic>.from(payload));
    }
  }

  void _handleUpdateOptions(Map data) {
    debugPrint("Playground: Received options -> $data");
    setState(() {
      if (data['autoCenter'] != null) {
        _autoCenter = data['autoCenter'] == true;
        debugPrint("Playground: autoCenter = $_autoCenter");
      }
      if (data['autoOverflow'] != null) {
        _autoOverflow = data['autoOverflow'] == true;
        debugPrint("Playground: autoOverflow = $_autoOverflow");
      }
      if (data['theme'] != null) {
        final newTheme = data['theme']?.toString() ?? 'dark';
        if (newTheme == 'light' || newTheme == 'dark') {
          _themeMode = newTheme;
          debugPrint("Playground: themeMode = $_themeMode");
        }
      }
    });
  }

  void _renderJson(Map<String, dynamic> jsonData) {
    try {
      final widgetTree = DynamicRenderer.buildFromJson(jsonData);
      setState(() {
        _renderedWidget = widgetTree;
      });
    } catch (e) {
      _showError("Render Error: $e");
    }
  }

  void _showError(String message) {
    setState(() {
      _renderedWidget = Center(
        child: WDiv(
          className: 'p-4 bg-red-500/10 border border-red-500/50 rounded-lg',
          child: WText(
            message,
            className: 'text-red-400 text-sm font-mono',
          ),
        ),
      );
    });
  }

  void _toggleTheme() {
    final newTheme = _themeMode == 'dark' ? 'light' : 'dark';
    setState(() {
      _themeMode = newTheme;
    });

    // Post theme change back to Vue
    if (kIsWeb) {
      web.window.parent?.postMessage(
        {'type': 'THEME_CHANGED', 'theme': newTheme}.jsify(),
        '*'.toJS,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeMode == 'dark';

    return Theme(
      data: isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor:
            isDark ? wColor(context, 'black') : wColor(context, 'white'),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: isDark
              ? wColor(context, 'gray', shade: 800)
              : wColor(context, 'gray', shade: 200),
          onPressed: _toggleTheme,
          child: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: isDark ? Colors.amber : Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    // If no widget yet, show empty - loading state is handled by parent container
    Widget content = _renderedWidget ?? const SizedBox.shrink();

    // When autoOverflow is enabled, wrap in ScrollView
    if (_autoOverflow) {
      return LayoutBuilder(
        builder: (context, constraints) {
          Widget scrollContent = content;

          // If autoCenter is enabled, center the content and use minHeight
          if (_autoCenter) {
            scrollContent = ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: Center(child: content),
            );
          }

          // Use both horizontal and vertical scroll to prevent clipping
          return SingleChildScrollView(
            primary: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: scrollContent,
            ),
          );
        },
      );
    }

    // No scroll - just apply alignment
    if (_autoCenter) {
      return Center(child: content);
    }

    // No scroll, no center - align to top-left
    return Align(
      alignment: Alignment.topLeft,
      child: content,
    );
  }
}

/// Dynamic JSON to Widget renderer
class DynamicRenderer {
  static Map<String, dynamic> _deepConvertMap(Map map) {
    return map.map((key, value) {
      final newKey = key.toString();
      dynamic newValue = value;
      if (value is Map) {
        newValue = _deepConvertMap(value);
      } else if (value is List) {
        newValue = value.map((e) => e is Map ? _deepConvertMap(e) : e).toList();
      }
      return MapEntry(newKey, newValue);
    });
  }

  static Widget buildFromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return const SizedBox.shrink();
    }

    final String type = json['type'] ?? 'Unknown';
    final props = json['props'];
    final Map<String, dynamic> safeProps =
        props is Map ? _deepConvertMap(props) : <String, dynamic>{};
    final List<dynamic> childrenRaw = json['children'] ?? [];

    List<Widget> children = childrenRaw.map((childJson) {
      if (childJson is Map) {
        return buildFromJson(_deepConvertMap(childJson));
      }
      return const SizedBox.shrink();
    }).toList();

    try {
      switch (type) {
        // Wind Widgets
        case 'WDiv':
          return _buildWDiv(safeProps, children);
        case 'WText':
          return _buildWText(safeProps);
        case 'WButton':
          return _buildWButton(safeProps, children);
        case 'WImage':
          return _buildWImage(safeProps);
        case 'WIcon':
          return _buildWIcon(safeProps);
        case 'WAnchor':
          return _buildWAnchor(safeProps, children);
        case 'WInput':
          return _buildWInput(safeProps);
        case 'WCheckbox':
          return _buildWCheckbox(safeProps);
        case 'WSvg':
          return _buildWSvg(safeProps);

        // Flutter Core Widgets
        case 'Column':
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
        case 'Row':
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
        case 'Center':
          return Center(child: children.isNotEmpty ? children.first : null);
        case 'SizedBox':
          return SizedBox(
            width: _parseDouble(safeProps['width']),
            height: _parseDouble(safeProps['height']),
            child: children.isNotEmpty ? children.first : null,
          );
        case 'Expanded':
          return Expanded(
            flex: safeProps['flex'] ?? 1,
            child: children.isNotEmpty ? children.first : const SizedBox(),
          );
        case 'Container':
          return SizedBox(
            width: _parseDouble(safeProps['width']),
            height: _parseDouble(safeProps['height']),
            child: children.isNotEmpty ? children.first : null,
          );

        default:
          return _buildErrorWidget("Unknown: $type");
      }
    } catch (e) {
      return _buildErrorWidget("Error ($type): $e");
    }
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static Widget _buildWDiv(Map<String, dynamic> props, List<Widget> children) {
    return WDiv(
      className: props['className'],
      child: children.length == 1 ? children.first : null,
      children: children.length > 1 ? children : null,
    );
  }

  static Widget _buildWText(Map<String, dynamic> props) {
    final String textContent = props['text'] ?? props['value'] ?? '';
    return WText(textContent, className: props['className']);
  }

  static Widget _buildWButton(
    Map<String, dynamic> props,
    List<Widget> children,
  ) {
    return WButton(
      onTap: () => debugPrint("Playground: Button tapped"),
      className: props['className'],
      disabled: props['disabled'] == true,
      isLoading: props['isLoading'] == true,
      child: children.isNotEmpty ? children.first : const SizedBox.shrink(),
    );
  }

  static Widget _buildWImage(Map<String, dynamic> props) {
    return WImage(
      src: props['src'] ?? 'https://via.placeholder.com/150',
      className: props['className'],
    );
  }

  static Widget _buildWIcon(Map<String, dynamic> props) {
    final iconName = props['icon'] ?? 'help';
    return WIcon(_parseIcon(iconName), className: props['className']);
  }

  static Widget _buildWAnchor(
    Map<String, dynamic> props,
    List<Widget> children,
  ) {
    return WAnchor(
      onTap: () => debugPrint("Playground: Anchor clicked"),
      child: children.isNotEmpty
          ? (children.length == 1 ? children.first : WDiv(children: children))
          : const SizedBox.shrink(),
    );
  }

  static Widget _buildWInput(Map<String, dynamic> props) {
    return WInput(
      value: props['value'] ?? '',
      onChanged: (v) => debugPrint("Playground: Input -> $v"),
      type: _parseInputType(props['type']),
      placeholder: props['placeholder'],
      className: props['className'],
    );
  }

  static Widget _buildWCheckbox(Map<String, dynamic> props) {
    return WCheckbox(
      value: props['checked'] == true,
      onChanged: (v) => debugPrint("Playground: Checkbox -> $v"),
      className: props['className'],
    );
  }

  static Widget _buildWSvg(Map<String, dynamic> props) {
    final String? svgContent = props['svgContent'];
    if (svgContent != null && svgContent.isNotEmpty) {
      return WSvg.string(svgContent, className: props['className']);
    }
    return WIcon(Icons.image_outlined, className: props['className']);
  }

  static InputType _parseInputType(String? type) {
    return switch (type) {
      'email' => InputType.email,
      'password' => InputType.password,
      'number' => InputType.number,
      'multiline' || 'textarea' => InputType.multiline,
      _ => InputType.text,
    };
  }

  static IconData _parseIcon(String? iconName) {
    const iconMap = {
      'star': Icons.star,
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
      'mail': Icons.mail,
      'menu': Icons.menu,
      'info': Icons.info,
      'warning': Icons.warning,
      'error': Icons.error,
      'help': Icons.help,
      'code': Icons.code,
    };
    return iconMap[iconName] ?? Icons.help_outline;
  }

  static Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        color: Colors.red.shade50,
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
