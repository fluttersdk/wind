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
    final Map<String, dynamic> safeProps = props is Map
        ? _deepConvertMap(props)
        : <String, dynamic>{};
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
    // return Scaffold(
    //   body: WDiv(
    //     className: "w-512 w-128",
    //     child: WDiv(
    //       className: "bg-gray-900 py-16 sm:py-24 lg:py-32",
    //       children: [
    //         WDiv(
    //           className: "mx-auto max-w-7xl px-6 lg:px-8",
    //           child: WDiv(
    //             className:
    //                 "mx-auto grid max-w-2xl grid-cols-1 gap-x-8 gap-y-16 lg:max-w-none lg:grid-cols-2",
    //             children: [
    //               WDiv(
    //                 className: "max-w-xl lg:max-w-lg",
    //                 children: [
    //                   WText(
    //                     "Subscribe to our newsletter",
    //                     className:
    //                         "text-4xl font-semibold tracking-tight text-white",
    //                   ),
    //                   WText(
    //                     "Nostrud amet eu ullamco nisi aute in ad minim nostrud adipisicing velit quis. Duis tempor incididunt dolore.",
    //                     className: "mt-4 text-lg text-gray-300",
    //                   ),
    //                   WDiv(
    //                     className: "mt-6 flex max-w-md gap-x-4",
    //                     children: [
    //                       WText("Email address"),
    //                       WInput(
    //                         className:
    //                             "min-w-0 flex-auto rounded-md bg-white/5 px-3.5 py-2 text-base text-white outline-white/10 placeholder:text-gray-500 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-500 sm:text-sm/6",
    //                         value: "",
    //                         onChanged: (v) {},
    //                         type: InputType.email,
    //                         placeholder: "Enter your email",
    //                       ),
    //                       WButton(
    //                         className:
    //                             "flex-none rounded-md bg-indigo-500 px-3.5 py-2.5 text-sm font-semibold text-white shadow-xs hover:bg-indigo-400",
    //                         onTap: () {},
    //                         child: WText("Subscribe"),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //               WDiv(
    //                 className:
    //                     "grid grid-cols-1 gap-x-8 gap-y-10 sm:grid-cols-2 lg:pt-2",
    //                 children: [
    //                   WDiv(
    //                     className: "flex flex-col items-start",
    //                     children: [
    //                       WDiv(
    //                         className:
    //                             "rounded-md bg-white/5 p-2 ring-1 ring-white/10",
    //                         child: WSvg.string(
    //                           '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" data-slot="icon" aria-hidden="true" class="size-6 text-white"><path d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5m-9-6h.008v.008H12v-.008ZM12 15h.008v.008H12V15Zm0 2.25h.008v.008H12v-.008ZM9.75 15h.008v.008H9.75V15Zm0 2.25h.008v.008H9.75v-.008ZM7.5 15h.008v.008H7.5V15Zm0 2.25h.008v.008H7.5v-.008Zm6.75-4.5h.008v.008h-.008v-.008Zm0 2.25h.008v.008h-.008V15Zm0 2.25h.008v.008h-.008v-.008Zm2.25-4.5h.008v.008H16.5v-.008Zm0 2.25h.008v.008H16.5V15Z" stroke-linecap="round" stroke-linejoin="round"></path></svg>',
    //                           className: "w-6 h-6 text-white",
    //                         ),
    //                       ),
    //                       WDiv(
    //                         className:
    //                             "mt-4 text-base font-semibold text-white",
    //                         child: WText("Weekly articles"),
    //                       ),
    //                       WDiv(
    //                         className: "mt-2 text-base/7 text-gray-400",
    //                         child: WText(
    //                           "Non laboris consequat cupidatat laborum magna. Eiusmod non irure cupidatat duis commodo amet.",
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   WDiv(
    //                     className: "flex flex-col items-start",
    //                     children: [
    //                       WDiv(
    //                         className:
    //                             "rounded-md bg-white/5 p-2 ring-1 ring-white/10",
    //                         child: WSvg.string(
    //                           '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" data-slot="icon" aria-hidden="true" class="size-6 text-white"><path d="M10.05 4.575a1.575 1.575 0 1 0-3.15 0v3m3.15-3v-1.5a1.575 1.575 0 0 1 3.15 0v1.5m-3.15 0 .075 5.925m3.075.75V4.575m0 0a1.575 1.575 0 0 1 3.15 0V15M6.9 7.575a1.575 1.575 0 1 0-3.15 0v8.175a6.75 6.75 0 0 0 6.75 6.75h2.018a5.25 5.25 0 0 0 3.712-1.538l1.732-1.732a5.25 5.25 0 0 0 1.538-3.712l.003-2.024a.668.668 0 0 1 .198-.471 1.575 1.575 0 1 0-2.228-2.228 3.818 3.818 0 0 0-1.12 2.687M6.9 7.575V12m6.27 4.318A4.49 4.49 0 0 1 16.35 15m.002 0h-.002" stroke-linecap="round" stroke-linejoin="round"></path></svg>',
    //                           className: "w-6 h-6 text-white",
    //                         ),
    //                       ),
    //                       WDiv(
    //                         className:
    //                             "mt-4 text-base font-semibold text-white",
    //                         child: WText("No spam"),
    //                       ),
    //                       WDiv(
    //                         className: "mt-2 text-base/7 text-gray-400",
    //                         child: WText(
    //                           "Officia excepteur ullamco ut sint duis proident non adipisicing. Voluptate incididunt anim.",
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //         WDiv(
    //           className:
    //               "absolute top-0 left-1/2 -z-10 -translate-x-1/2 xl:-top-6",
    //           child: WDiv(
    //             className:
    //                 "aspect-1155/678 w-288.75 bg-linear-to-tr from-[#ff80b5] to-[#9089fc] opacity-30",
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return Scaffold(
      backgroundColor: wColor(context, 'white', darkColorName: 'black'),
      // Use SizedBox.expand to provide bounded constraints for h-full/w-full
      // Wrap in ClipRect to clip overflow instead of showing stripes
      // Content should use overflow-auto class if scrolling is needed
      body: ClipRect(
        child: SizedBox.expand(
          child:
              _renderedWidget ??
              const Center(child: CircularProgressIndicator()),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: wColor(
              context,
              'white',
              darkColorName: 'gray',
              darkShade: 800,
            ),
            onPressed: () {
              _renderJson(_defaultJsonData);
            },
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
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
        ],
      ),
    );
  }
}
