import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Child Order Example
/// Demonstrates order-* utilities and flex-*-reverse for reordering flex children.
class OrderExamplePage extends StatelessWidget {
  const OrderExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-2xl',
        children: [
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-blue-500 to-indigo-500
            ''',
            children: [
              WText(
                'Child Order & Reverse',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Reorder flex children with order-* and flex-*-reverse',
                className: 'text-sm text-blue-100',
              ),
            ],
          ),
          _buildSection(
            title: 'order-* overrides source order',
            code: 'order-3 / order-1 / order-2',
            child: WDiv(
              className:
                  'flex gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
              children: [
                _buildBox('A', 'bg-rose-500', orderCls: 'order-3'),
                _buildBox('B', 'bg-rose-500', orderCls: 'order-1'),
                _buildBox('C', 'bg-rose-500', orderCls: 'order-2'),
              ],
            ),
          ),
          _buildSection(
            title: 'order-first / order-last',
            code: 'order-last / order-first',
            child: WDiv(
              className:
                  'flex gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
              children: [
                _buildBox('A', 'bg-emerald-500', orderCls: 'order-last'),
                _buildBox('B', 'bg-emerald-500'),
                _buildBox('C', 'bg-emerald-500', orderCls: 'order-first'),
              ],
            ),
          ),
          _buildSection(
            title: 'flex-row-reverse',
            code: 'flex flex-row-reverse',
            child: WDiv(
              className:
                  'flex flex-row-reverse gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
              children: [
                _buildBox('1', 'bg-indigo-500'),
                _buildBox('2', 'bg-indigo-500'),
                _buildBox('3', 'bg-indigo-500'),
              ],
            ),
          ),
          _buildSection(
            title: 'flex-col-reverse',
            code: 'flex flex-col-reverse',
            child: WDiv(
              className:
                  'flex flex-col-reverse gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
              children: [
                _buildBox('1', 'bg-amber-500'),
                _buildBox('2', 'bg-amber-500'),
                _buildBox('3', 'bg-amber-500'),
              ],
            ),
          ),
          _buildSection(
            title: 'Responsive reorder (resize the window)',
            code: 'order-2 md:order-1 / order-1 md:order-2',
            child: WDiv(
              className:
                  'flex flex-col md:flex-row gap-2 p-4 bg-gray-100 dark:bg-slate-700 rounded-lg',
              children: [
                _buildBox(
                  'Sidebar',
                  'bg-sky-500',
                  orderCls: 'order-2 md:order-1',
                  wide: true,
                ),
                _buildBox(
                  'Main',
                  'bg-sky-600',
                  orderCls: 'order-1 md:order-2',
                  wide: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String code,
    required Widget child,
  }) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WDiv(
          className: 'flex items-center justify-between',
          children: [
            WText(
              title,
              className: 'font-semibold text-gray-800 dark:text-white',
            ),
            WDiv(
              className: 'px-2 py-1 rounded bg-slate-200 dark:bg-slate-600',
              child: WText(
                code,
                className: 'text-xs font-mono text-gray-600 dark:text-gray-300',
              ),
            ),
          ],
        ),
        child,
      ],
    );
  }

  Widget _buildBox(
    String label,
    String bgColor, {
    String orderCls = '',
    bool wide = false,
  }) {
    final size = wide ? 'px-4 h-12' : 'w-12 h-12';
    return WDiv(
      className:
          '$orderCls $bgColor $size rounded-lg flex items-center justify-center',
      child: WText(label, className: 'text-white font-bold'),
    );
  }
}
