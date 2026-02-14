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
  Map<String, dynamic> _jsonData = {
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
            setState(() => _jsonData = payload);
          } else if (payload is Map) {
            setState(() => _jsonData = Map<String, dynamic>.from(payload));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wColor(context, 'white', darkColorName: 'black'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            primary: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: WDynamic(
                json: _jsonData,
                actions: {
                  'log': (Map<String, dynamic> args) {
                    debugPrint("Playground action: $args");
                  },
                },
              ),
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
