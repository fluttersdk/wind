import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

class WInputMultilineExamplePage extends StatelessWidget {
  const WInputMultilineExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'Multiline Input',
      description:
          'type: InputType.multiline + minLines/maxLines turns WInput into a text area. Grows with content up to maxLines.',
      gradient: 'from-blue-500 to-cyan-600',
      children: [
        ExampleSection(
          title: 'Basic Usage',
          description: 'Fixed 3-line minimum, grows to 5 max.',
          child: WInput(
            type: InputType.multiline,
            minLines: 3,
            maxLines: 5,
            placeholder: 'Tell us about yourself…',
            className: '''
              w-full p-3 rounded-lg
              bg-white dark:bg-slate-800
              border border-slate-300 dark:border-slate-600
              focus:border-blue-500 focus:ring-2 focus:ring-blue-500/30
            ''',
          ),
        ),
        ExampleSection(
          title: 'Unlimited Growth',
          description:
              'maxLines: null grows indefinitely as the user types. Wrap in a scroll if needed.',
          child: WInput(
            type: InputType.multiline,
            minLines: 2,
            maxLines: null,
            placeholder: 'Comment thread…',
            className: '''
              w-full p-3 rounded-lg font-mono text-sm
              bg-slate-50 dark:bg-slate-900
              border border-slate-200 dark:border-slate-700
            ''',
          ),
        ),
      ],
    );
  }
}
