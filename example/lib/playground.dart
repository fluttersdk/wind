import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
import 'package:web/web.dart' as web;

void main() {
  runApp(const JsonPlaygroundApp());
}

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
        default:
          return _buildErrorWidget("Unknown Widget Type: $type");
      }
    } catch (e) {
      return _buildErrorWidget("Render Error ($type): $e");
    }
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
      onTap: () {
        debugPrint("Playground: Button clicked!");
      },
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
      onTap: () {
        debugPrint("Playground: Anchor clicked! href: ${props['href']}");
      },
      child: children.isNotEmpty
          ? (children.length == 1 ? children.first : WDiv(children: children))
          : const SizedBox.shrink(),
    );
  }

  static Widget _buildWInput(Map<String, dynamic> props) {
    final String? className = props['className'];

    Widget input = WInput(
      value: props['value'] ?? '',
      onChanged: (v) {
        debugPrint("Playground: Input changed: $v");
      },
      type: _parseInputType(props['type']),
      placeholder: props['placeholder'],
      className: className,
    );

    return input;
  }

  static Widget _buildWCheckbox(Map<String, dynamic> props) {
    return WCheckbox(
      value: props['checked'] == true,
      onChanged: (v) {
        debugPrint("Playground: Checkbox changed: $v");
      },
      className: props['className'],
    );
  }

  static Widget _buildWSvg(Map<String, dynamic> props) {
    final String? svgContent = props['svgContent'];
    if (svgContent != null && svgContent.isNotEmpty) {
      return WSvg.string(svgContent, className: props['className']);
    }
    // Fallback to placeholder icon if no SVG content
    return WIcon(Icons.image_outlined, className: props['className']);
  }

  static InputType _parseInputType(String? type) {
    switch (type) {
      case 'email':
        return InputType.email;
      case 'password':
        return InputType.password;
      case 'number':
        return InputType.number;
      case 'multiline':
      case 'textarea':
        return InputType.multiline;
      default:
        return InputType.text;
    }
  }

  static IconData _parseIcon(String? iconName) {
    const iconMap = {
      'star': Icons.star,
      'star_outline': Icons.star_outline,
      'home': Icons.home,
      'user': Icons.person,
      'person': Icons.person,
      'check': Icons.check,
      'check_circle': Icons.check_circle,
      'close': Icons.close,
      'refresh': Icons.refresh,
      'settings': Icons.settings,
      'arrow_right': Icons.arrow_forward,
      'arrow_forward': Icons.arrow_forward,
      'arrow_left': Icons.arrow_back,
      'arrow_back': Icons.arrow_back,
      'arrow_up': Icons.arrow_upward,
      'arrow_down': Icons.arrow_downward,
      'search': Icons.search,
      'add': Icons.add,
      'remove': Icons.remove,
      'edit': Icons.edit,
      'delete': Icons.delete,
      'favorite': Icons.favorite,
      'favorite_outline': Icons.favorite_outline,
      'heart': Icons.favorite,
      'mail': Icons.mail,
      'email': Icons.email,
      'phone': Icons.phone,
      'camera': Icons.camera_alt,
      'image': Icons.image,
      'play': Icons.play_arrow,
      'pause': Icons.pause,
      'stop': Icons.stop,
      'menu': Icons.menu,
      'more': Icons.more_vert,
      'more_horiz': Icons.more_horiz,
      'info': Icons.info,
      'warning': Icons.warning,
      'error': Icons.error,
      'help': Icons.help,
      'shopping_cart': Icons.shopping_cart,
      'visibility': Icons.visibility,
      'visibility_off': Icons.visibility_off,
      'lock': Icons.lock,
      'unlock': Icons.lock_open,
      'notifications': Icons.notifications,
      'calendar': Icons.calendar_today,
      'clock': Icons.access_time,
      'location': Icons.location_on,
      'download': Icons.download,
      'upload': Icons.upload,
      'share': Icons.share,
      'copy': Icons.copy,
      'link': Icons.link,
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

class JsonPlaygroundApp extends StatelessWidget {
  const JsonPlaygroundApp({super.key});

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

  final Map<String, dynamic> _defaultJsonData = {
    'type': 'WDiv',
    'props': {'className': "flex items-center justify-center w-full h-full"},
    'children': [
      {
        'type': 'WDiv',
        'props': {
          'className':
              'w-96 rounded-3xl shadow-2xl bg-primary-600 p-6 border border-dark-600 dark:bg-primary-800 dark:border-dark-600',
        },
        'children': [
          {
            'type': 'WDiv',
            'props': {'className': 'flex justify-center mb-4'},
            'children': [
              {
                'type': 'WIcon',
                'props': {
                  'icon': 'star',
                  'className': 'text-yellow-400 text-4xl animate-bounce',
                },
              },
            ],
          },
          {
            'type': 'WText',
            'props': {
              'text': 'Wind Playground Ready',
              'className': 'text-white text-2xl font-bold text-center mb-2',
            },
          },
          {
            'type': 'WText',
            'props': {
              'text': 'Waiting for JSON data from parent window...',
              'className': 'text-gray-400 text-center text-sm',
            },
          },
        ],
      },
    ],
  };

  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();

    _renderJson(_defaultJsonData);

    if (kIsWeb) {
      _listenToWebMessages();
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  void _listenToWebMessages() {
    _messageSubscription = web.window.onMessage.listen((
      web.MessageEvent event,
    ) {
      final data = event.data.dartify();
      if (data is Map) {
        if (data['type'] == 'RENDER_JSON' && data['payload'] != null) {
          debugPrint("Playground: New JSON data received.");

          dynamic payload = data['payload'];

          if (payload is String) {
            try {
              payload = jsonDecode(payload);
            } catch (e) {
              debugPrint("Playground: JSON decode error -> $e");
              return;
            }
          }

          if (payload is Map<String, dynamic>) {
            _renderJson(payload);
          } else if (payload is Map) {
            _renderJson(Map<String, dynamic>.from(payload));
          }
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
      setState(() {
        _renderedWidget = Text(
          "JSON Parse Error: $e",
          style: const TextStyle(color: Colors.red),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wColor(context, 'white', darkColorName: 'black'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            primary: true,
            // ConstrainedBox is required for 'min-h-full' and vertical centering to work inside a ScrollView
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: _renderedWidget ??
                  const Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: wColor(
          context,
          'white',
          darkColorName: 'gray',
          darkShade: 800,
        ),
        onPressed: () {
          context.windTheme.toggleTheme();
        },
        child: const Icon(Icons.dark_mode),
      ),
    );
  }
}
