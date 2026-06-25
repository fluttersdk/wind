import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import '../../widgets/example_scaffold.dart';

// A button recipe: base layout + intent + size variants, plus a compound variant.
final _button = WindRecipe(
  base: 'inline-flex items-center justify-center rounded-lg font-medium',
  variants: {
    'intent': {
      'primary': 'bg-blue-600 dark:bg-blue-500 text-white',
      'secondary':
          'bg-gray-100 dark:bg-gray-700 text-gray-800 dark:text-gray-100',
      'destructive': 'bg-red-600 dark:bg-red-500 text-white',
      'ghost': 'bg-transparent text-blue-600 dark:text-blue-400',
    },
    'size': {
      'sm': 'px-3 py-1.5 text-sm',
      'md': 'px-4 py-2 text-base',
      'lg': 'px-6 py-3 text-lg',
    },
  },
  compoundVariants: [
    WindCompoundVariant(
      conditions: {'intent': 'primary', 'size': 'lg'},
      className: 'shadow-lg',
    ),
    WindCompoundVariant(
      conditions: {'intent': 'destructive', 'size': 'lg'},
      className: 'shadow-lg',
    ),
  ],
  defaultVariants: {'intent': 'primary', 'size': 'md'},
);

// A badge recipe with a slot-less API demonstrating defaultVariants.
final _badge = WindRecipe(
  base:
      'inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium',
  variants: {
    'tone': {
      'success':
          'bg-green-100 dark:bg-green-900 text-green-800 dark:text-green-200',
      'warning':
          'bg-yellow-100 dark:bg-yellow-900 text-yellow-800 dark:text-yellow-200',
      'danger': 'bg-red-100 dark:bg-red-900 text-red-800 dark:text-red-200',
      'info': 'bg-blue-100 dark:bg-blue-900 text-blue-800 dark:text-blue-200',
      'neutral':
          'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300',
    },
  },
  defaultVariants: {'tone': 'info'},
);

// A card slot recipe: root, header, body each get independent classNames.
final _card = WindSlotRecipe(
  slots: {
    'root': 'rounded-xl border overflow-hidden',
    'header': 'px-5 py-4 border-b',
    'body': 'px-5 py-4',
  },
  variants: {
    'tone': {
      'default': {
        'root':
            'bg-white dark:bg-gray-800 border-gray-200 dark:border-gray-700',
        'header': 'border-gray-200 dark:border-gray-700',
        'body': '',
      },
      'highlighted': {
        'root':
            'bg-blue-50 dark:bg-blue-950 border-blue-200 dark:border-blue-800',
        'header': 'border-blue-200 dark:border-blue-800',
        'body': '',
      },
    },
  },
  defaultVariants: {'tone': 'default'},
);

class WindRecipeBasicExamplePage extends StatefulWidget {
  const WindRecipeBasicExamplePage({super.key});

  @override
  State<WindRecipeBasicExamplePage> createState() =>
      _WindRecipeBasicExamplePageState();
}

class _WindRecipeBasicExamplePageState
    extends State<WindRecipeBasicExamplePage> {
  String _cardTone = 'default';

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      title: 'WindRecipe',
      description:
          'Compose reusable className variants. base ++ variant ++ compound ++ caller.',
      gradient: 'from-amber-500 to-orange-600',
      children: [
        ExampleSection(
          title: 'WindRecipe: Button Variants',
          description:
              'One recipe, four intent values, three sizes. Compound: large primary gets shadow-lg.',
          child: WDiv(
            className: 'flex flex-col gap-4',
            children: [
              WDiv(
                className: 'wrap gap-3',
                children: [
                  WButton(
                    onTap: () {},
                    className:
                        _button(variants: {'intent': 'primary', 'size': 'sm'}),
                    child: WText('Primary SM'),
                  ),
                  WButton(
                    onTap: () {},
                    className: _button(),
                    child: WText('Primary MD (default)'),
                  ),
                  WButton(
                    onTap: () {},
                    className: _button(variants: {'size': 'lg'}),
                    child: WText('Primary LG + shadow'),
                  ),
                ],
              ),
              WDiv(
                className: 'wrap gap-3',
                children: [
                  WButton(
                    onTap: () {},
                    className: _button(variants: {'intent': 'secondary'}),
                    child: WText('Secondary'),
                  ),
                  WButton(
                    onTap: () {},
                    className: _button(variants: {'intent': 'destructive'}),
                    child: WText('Destructive'),
                  ),
                  WButton(
                    onTap: () {},
                    className: _button(variants: {'intent': 'ghost'}),
                    child: WText('Ghost'),
                  ),
                ],
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'WindRecipe: Badge Tones',
          description:
              'A recipe with a single axis; defaultVariants covers the no-argument call.',
          child: WDiv(
            className: 'wrap gap-2',
            children: [
              WBadge('Deployed',
                  className: _badge(variants: {'tone': 'success'})),
              WBadge('Pending',
                  className: _badge(variants: {'tone': 'warning'})),
              WBadge('Failed', className: _badge(variants: {'tone': 'danger'})),
              WBadge('Review', className: _badge()),
              WBadge('Draft', className: _badge(variants: {'tone': 'neutral'})),
            ],
          ),
        ),
        ExampleSection(
          title: 'WindSlotRecipe: Card Tones',
          description:
              'Each slot (root, header, body) gets independent classNames per variant.',
          child: WDiv(
            className: 'flex flex-col gap-4',
            children: [
              WDiv(
                className: 'flex flex-row gap-3',
                children: [
                  WButton(
                    onTap: () => setState(() => _cardTone = 'default'),
                    className: _button(
                      variants: {
                        'intent':
                            _cardTone == 'default' ? 'primary' : 'secondary',
                        'size': 'sm'
                      },
                    ),
                    child: WText('Default'),
                  ),
                  WButton(
                    onTap: () => setState(() => _cardTone = 'highlighted'),
                    className: _button(
                      variants: {
                        'intent': _cardTone == 'highlighted'
                            ? 'primary'
                            : 'secondary',
                        'size': 'sm',
                      },
                    ),
                    child: WText('Highlighted'),
                  ),
                ],
              ),
              Builder(
                builder: (ctx) {
                  final classes = _card(variants: {'tone': _cardTone});
                  return WCard(
                    className: classes['root'],
                    header: WDiv(
                      className: classes['header'],
                      child: WText(
                        'Account Summary',
                        className:
                            'text-sm font-semibold text-gray-700 dark:text-gray-300',
                      ),
                    ),
                    child: WDiv(
                      className: classes['body'],
                      children: [
                        WText(
                          'john.doe@example.com',
                          className:
                              'text-base font-medium text-gray-900 dark:text-white',
                        ),
                        WText(
                          'Pro plan, renews on July 15.',
                          className: 'text-sm text-gray-500 dark:text-gray-400',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        ExampleSection(
          title: 'Caller className Override',
          description:
              'Pass className: to _recipe() to append extra classes after the resolved set.',
          child: WDiv(
            className: 'wrap gap-3',
            children: [
              WButton(
                onTap: () {},
                className: _button(className: 'w-full'),
                child: WText('Full-width primary'),
              ),
              WButton(
                onTap: () {},
                className: _button(
                    variants: {'intent': 'secondary'}, className: 'italic'),
                child: WText('Secondary italic'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
