import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class CursorBasicExamplePage extends StatelessWidget {
  const CursorBasicExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Cursor',
      description:
          'cursor-* sets the mouse cursor over an element on web and desktop. '
          'A plain WDiv can feel clickable without WAnchor or a manual MouseRegion. '
          'Hover the tiles below (web/desktop) to see each cursor.',
      gradient: 'from-cyan-500 to-blue-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description:
              'cursor-pointer turns any container into a "this is clickable" '
              'surface, matching the look of a button on the web.',
          child: WDiv(
            className: '''
              cursor-pointer self-start
              px-6 py-4 rounded-lg
              bg-blue-500 hover:bg-blue-600
              dark:bg-blue-600 dark:hover:bg-blue-700
            ''',
            child: const WText(
              'Hover me (cursor-pointer)',
              className: 'text-white font-medium',
            ),
          ),
        ),
        ExampleSection(
          title: 'Interaction Cursors',
          description: 'The everyday set: pointer, text, wait, progress, help, '
              'not-allowed, none.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _CursorTile(label: 'cursor-pointer', cls: 'cursor-pointer'),
              _CursorTile(label: 'cursor-text', cls: 'cursor-text'),
              _CursorTile(label: 'cursor-wait', cls: 'cursor-wait'),
              _CursorTile(label: 'cursor-progress', cls: 'cursor-progress'),
              _CursorTile(label: 'cursor-help', cls: 'cursor-help'),
              _CursorTile(
                label: 'cursor-not-allowed',
                cls: 'cursor-not-allowed',
              ),
              _CursorTile(label: 'cursor-default', cls: 'cursor-default'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Drag & Zoom',
          description:
              'grab / grabbing for draggable handles, zoom-in / zoom-out for '
              'media viewers, move for repositionable items.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _CursorTile(label: 'cursor-grab', cls: 'cursor-grab'),
              _CursorTile(label: 'cursor-grabbing', cls: 'cursor-grabbing'),
              _CursorTile(label: 'cursor-move', cls: 'cursor-move'),
              _CursorTile(label: 'cursor-zoom-in', cls: 'cursor-zoom-in'),
              _CursorTile(label: 'cursor-zoom-out', cls: 'cursor-zoom-out'),
            ],
          ),
        ),
        ExampleSection(
          title: 'Resize',
          description:
              'Directional resize cursors map to the matching native arrows: '
              'col / row / edge / corner.',
          child: WDiv(
            className: 'wrap gap-3',
            children: const [
              _CursorTile(label: 'cursor-col-resize', cls: 'cursor-col-resize'),
              _CursorTile(label: 'cursor-row-resize', cls: 'cursor-row-resize'),
              _CursorTile(label: 'cursor-ew-resize', cls: 'cursor-ew-resize'),
              _CursorTile(label: 'cursor-ns-resize', cls: 'cursor-ns-resize'),
              _CursorTile(
                label: 'cursor-nwse-resize',
                cls: 'cursor-nwse-resize',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CursorTile extends StatelessWidget {
  final String label;
  final String cls;

  const _CursorTile({required this.label, required this.cls});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: '''
        $cls
        px-4 py-3 rounded-lg
        border border-slate-200 dark:border-slate-700
        bg-slate-50 hover:bg-slate-100
        dark:bg-slate-800 dark:hover:bg-slate-700
      ''',
      child: WText(
        label,
        className: 'font-mono text-sm text-slate-700 dark:text-slate-200',
      ),
    );
  }
}
