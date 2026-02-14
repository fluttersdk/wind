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
  Map<String, dynamic>? _jsonData;
  Widget? _errorWidget;
  bool _autoCenter = true;
  bool _autoOverflow = true;
  String _themeMode = 'dark';

  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();

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
      setState(() => _jsonData = payload);
    } else if (payload is Map) {
      setState(() => _jsonData = Map<String, dynamic>.from(payload));
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

  void _showError(String message) {
    setState(() {
      _jsonData = null;
      _errorWidget = Center(
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
    // Show error widget if present
    if (_errorWidget != null) {
      return Center(child: _errorWidget!);
    }

    // If no JSON yet, show empty - loading state is handled by parent container
    if (_jsonData == null) {
      return const SizedBox.shrink();
    }

    Widget content = WDynamic(
      json: _jsonData!,
      actions: {
        'log': (Map<String, dynamic> args) {
          debugPrint("Playground action: $args");
        },
      },
      onError: (type, error) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          color: Colors.red.shade50,
        ),
        child: Text(
          'Error ($type): $error',
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      ),
    );

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
