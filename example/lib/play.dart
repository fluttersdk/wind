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

const _playgroundIcons = <String, IconData>{
  'air': Icons.air,
  'bolt': Icons.bolt,
  'cloud': Icons.cloud,
  'dark_mode': Icons.dark_mode,
  'light_mode': Icons.light_mode,
  'flash_on': Icons.flash_on,
  'flash_off': Icons.flash_off,
  'rocket_launch': Icons.rocket_launch,
  'language': Icons.language,
  'public': Icons.public,
  'lock': Icons.lock,
  'lock_open': Icons.lock_open,
  'visibility': Icons.visibility,
  'visibility_off': Icons.visibility_off,
  'notifications': Icons.notifications,
  'notifications_off': Icons.notifications_off,
  'thumb_up': Icons.thumb_up,
  'thumb_down': Icons.thumb_down,
  'share': Icons.share,
  'download': Icons.download,
  'upload': Icons.upload,
  'refresh': Icons.refresh,
  'sync': Icons.sync,
  'play_arrow': Icons.play_arrow,
  'pause': Icons.pause,
  'stop': Icons.stop,
  'skip_next': Icons.skip_next,
  'skip_previous': Icons.skip_previous,
  'volume_up': Icons.volume_up,
  'volume_off': Icons.volume_off,
  'mic': Icons.mic,
  'mic_off': Icons.mic_off,
  'camera': Icons.camera,
  'camera_alt': Icons.camera_alt,
  'photo': Icons.photo,
  'image': Icons.image,
  'palette': Icons.palette,
  'brush': Icons.brush,
  'format_paint': Icons.format_paint,
  'auto_fix_high': Icons.auto_fix_high,
  'tune': Icons.tune,
  'filter_list': Icons.filter_list,
  'sort': Icons.sort,
  'dashboard': Icons.dashboard,
  'grid_view': Icons.grid_view,
  'list': Icons.list,
  'view_list': Icons.view_list,
  'calendar_today': Icons.calendar_today,
  'schedule': Icons.schedule,
  'access_time': Icons.access_time,
  'timer': Icons.timer,
  'alarm': Icons.alarm,
  'location_on': Icons.location_on,
  'location_off': Icons.location_off,
  'map': Icons.map,
  'navigation': Icons.navigation,
  'directions': Icons.directions,
  'call': Icons.call,
  'call_end': Icons.call_end,
  'chat': Icons.chat,
  'chat_bubble': Icons.chat_bubble,
  'forum': Icons.forum,
  'send': Icons.send,
  'attach_file': Icons.attach_file,
  'link': Icons.link,
  'link_off': Icons.link_off,
  'content_copy': Icons.content_copy,
  'content_cut': Icons.content_cut,
  'content_paste': Icons.content_paste,
  'save': Icons.save,
  'folder': Icons.folder,
  'folder_open': Icons.folder_open,
  'file_copy': Icons.file_copy,
  'description': Icons.description,
  'article': Icons.article,
  'note': Icons.note,
  'note_add': Icons.note_add,
  'bookmark': Icons.bookmark,
  'bookmark_border': Icons.bookmark_border,
  'label': Icons.label,
  'flag': Icons.flag,
  'push_pin': Icons.push_pin,
  'shopping_cart': Icons.shopping_cart,
  'shopping_bag': Icons.shopping_bag,
  'store': Icons.store,
  'local_offer': Icons.local_offer,
  'payment': Icons.payment,
  'credit_card': Icons.credit_card,
  'account_balance': Icons.account_balance,
  'account_balance_wallet': Icons.account_balance_wallet,
  'receipt': Icons.receipt,
  'group': Icons.group,
  'person_add': Icons.person_add,
  'person_remove': Icons.person_remove,
  'people': Icons.people,
  'school': Icons.school,
  'work': Icons.work,
  'business': Icons.business,
  'apartment': Icons.apartment,
  'house': Icons.house,
  'key': Icons.key,
  'vpn_key': Icons.vpn_key,
  'security': Icons.security,
  'shield': Icons.shield,
  'verified': Icons.verified,
  'verified_user': Icons.verified_user,
  'admin_panel_settings': Icons.admin_panel_settings,
  'build': Icons.build,
  'construction': Icons.construction,
  'engineering': Icons.engineering,
  'terminal': Icons.terminal,
  'data_object': Icons.data_object,
  'storage': Icons.storage,
  'dns': Icons.dns,
  'cloud_upload': Icons.cloud_upload,
  'cloud_download': Icons.cloud_download,
  'cloud_done': Icons.cloud_done,
  'wifi': Icons.wifi,
  'wifi_off': Icons.wifi_off,
  'bluetooth': Icons.bluetooth,
  'usb': Icons.usb,
  'devices': Icons.devices,
  'phone_android': Icons.phone_android,
  'phone_iphone': Icons.phone_iphone,
  'computer': Icons.computer,
  'desktop_mac': Icons.desktop_mac,
  'laptop': Icons.laptop,
  'tablet': Icons.tablet,
  'watch': Icons.watch,
  'tv': Icons.tv,
  'monitor': Icons.monitor,
  'keyboard': Icons.keyboard,
  'mouse': Icons.mouse,
  'headphones': Icons.headphones,
  'speaker': Icons.speaker,
  'print': Icons.print,
  'qr_code': Icons.qr_code,
  'fingerprint': Icons.fingerprint,
  'face': Icons.face,
  'emoji_emotions': Icons.emoji_emotions,
  'mood': Icons.mood,
  'sentiment_satisfied': Icons.sentiment_satisfied,
  'sentiment_dissatisfied': Icons.sentiment_dissatisfied,
  'celebration': Icons.celebration,
  'cake': Icons.cake,
  'local_fire_department': Icons.local_fire_department,
  'whatshot': Icons.whatshot,
  'eco': Icons.eco,
  'park': Icons.park,
  'pets': Icons.pets,
  'fitness_center': Icons.fitness_center,
  'sports_esports': Icons.sports_esports,
  'restaurant': Icons.restaurant,
  'local_cafe': Icons.local_cafe,
  'local_bar': Icons.local_bar,
  'flight': Icons.flight,
  'directions_car': Icons.directions_car,
  'directions_bus': Icons.directions_bus,
  'directions_bike': Icons.directions_bike,
  'directions_walk': Icons.directions_walk,
  'train': Icons.train,
  'electric_bolt': Icons.electric_bolt,
  'water_drop': Icons.water_drop,
  'sunny': Icons.sunny,
  'nights_stay': Icons.nights_stay,
  'thermostat': Icons.thermostat,
  'ac_unit': Icons.ac_unit,
  'waves': Icons.waves,
  'expand_more': Icons.expand_more,
  'expand_less': Icons.expand_less,
  'unfold_more': Icons.unfold_more,
  'unfold_less': Icons.unfold_less,
  'open_in_new': Icons.open_in_new,
  'launch': Icons.launch,
  'fullscreen': Icons.fullscreen,
  'fullscreen_exit': Icons.fullscreen_exit,
  'zoom_in': Icons.zoom_in,
  'zoom_out': Icons.zoom_out,
  'crop': Icons.crop,
  'rotate_left': Icons.rotate_left,
  'rotate_right': Icons.rotate_right,
  'flip': Icons.flip,
  'undo': Icons.undo,
  'redo': Icons.redo,
  'done': Icons.done,
  'done_all': Icons.done_all,
  'clear': Icons.clear,
  'cancel': Icons.cancel,
  'block': Icons.block,
  'do_not_disturb': Icons.do_not_disturb,
  'remove_circle': Icons.remove_circle,
  'add_circle': Icons.add_circle,
  'check_circle': Icons.check_circle,
  'highlight_off': Icons.highlight_off,
  'radio_button_checked': Icons.radio_button_checked,
  'radio_button_unchecked': Icons.radio_button_unchecked,
  'check_box': Icons.check_box,
  'check_box_outline_blank': Icons.check_box_outline_blank,
  'toggle_on': Icons.toggle_on,
  'toggle_off': Icons.toggle_off,
  'more_horiz': Icons.more_horiz,
  'more_vert': Icons.more_vert,
  'drag_handle': Icons.drag_handle,
  'reorder': Icons.reorder,
  'apps': Icons.apps,
  'widgets': Icons.widgets,
  'category': Icons.category,
  'extension': Icons.extension,
  'inventory': Icons.inventory,
  'science': Icons.science,
  'biotech': Icons.biotech,
  'psychology': Icons.psychology,
  'lightbulb': Icons.lightbulb,
  'tips_and_updates': Icons.tips_and_updates,
  'trending_up': Icons.trending_up,
  'trending_down': Icons.trending_down,
  'trending_flat': Icons.trending_flat,
  'analytics': Icons.analytics,
  'insights': Icons.insights,
  'bar_chart': Icons.bar_chart,
  'pie_chart': Icons.pie_chart,
  'show_chart': Icons.show_chart,
  'table_chart': Icons.table_chart,
  'speed': Icons.speed,
  'task': Icons.task,
  'task_alt': Icons.task_alt,
  'assignment': Icons.assignment,
  'pending': Icons.pending,
  'hourglass_empty': Icons.hourglass_empty,
  'token': Icons.token,
  'hexagon': Icons.hexagon,
  'circle': Icons.circle,
  'square': Icons.square,
  'rectangle': Icons.rectangle,
  'change_history': Icons.change_history,
  'star_rate': Icons.star_rate,
  'grade': Icons.grade,
  'military_tech': Icons.military_tech,
  'emoji_events': Icons.emoji_events,
  'workspace_premium': Icons.workspace_premium,
};

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
      customIcons: _playgroundIcons,
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
          // Constrain content to viewport width so w-full resolves to
          // the actual screen width instead of infinity.
          Widget scrollContent = ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              maxWidth: constraints.maxWidth,
              minHeight: _autoCenter ? constraints.maxHeight : 0,
            ),
            child: _autoCenter ? Center(child: content) : content,
          );

          return SingleChildScrollView(
            primary: true,
            child: scrollContent,
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
