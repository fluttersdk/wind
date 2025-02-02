import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

import 'pages/backgrounds/background_color.dart';
import 'pages/borders/border_color.dart';
import 'pages/borders/border_radius.dart';
import 'pages/borders/border_width.dart';
import 'pages/core/dark_mode.dart';
import 'pages/core/responsive_design.dart';
import 'pages/core/state_based_styling.dart';
import 'pages/core/utility_first_flutter.dart';
import 'pages/core/utility_first_wind.dart';
import 'pages/effects/shadow.dart';
import 'pages/flex/align_items.dart';
import 'pages/flex/alignment.dart';
import 'pages/flex/axis_sizes.dart';
import 'pages/flex/flex_direction.dart';
import 'pages/flex/flex_fit.dart';
import 'pages/flex/flex_x.dart';
import 'pages/flex/gap.dart';
import 'pages/flex/gap_dynamic.dart';
import 'pages/flex/justify_content.dart';
import 'pages/flex/scrollable_overflow.dart';
import 'pages/home.dart';
import 'pages/sizing/height.dart';
import 'pages/sizing/width.dart';
import 'pages/spacing/margin.dart';
import 'pages/spacing/padding.dart';
import 'pages/typography/font_size.dart';
import 'pages/typography/font_style.dart';
import 'pages/typography/font_weight.dart';
import 'pages/typography/letter_spacing.dart';
import 'pages/typography/line_height.dart';
import 'pages/typography/text_alignment.dart';
import 'pages/typography/text_color.dart';
import 'pages/typography/text_decoration.dart';
import 'pages/typography/text_transform.dart';
import 'pages/widgets/wcontainer.dart';
import 'pages/widgets/wflex.dart';
import 'pages/widgets/wflexcontainer.dart';
import 'pages/widgets/wflexible.dart';
import 'pages/widgets/wtext.dart';

class MyApp extends StatelessWidget {
  final Widget Function(BuildContext) appCallback;

  const MyApp({super.key, required this.appCallback});

  @override
  Widget build(BuildContext context) {
    return appCallback(context);
  }
}

class AppLayoutWidget extends StatefulWidget {
  final Widget body;

  const AppLayoutWidget(this.body, {super.key});

  @override
  createState() => _AppLayoutWidgetState();
}

class _AppLayoutWidgetState extends State<AppLayoutWidget> {
  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Wind Demo',
      color: wColor('primary'),
      child: Scaffold(backgroundColor: wColor('white'), body: widget.body),
    );
  }
}

void main() {
  WindTheme.addColor(
      'primary',
      MaterialColor(0xff0986e0, {
        50: Color(0xffa5d7fb),
        100: Color(0xff92cffb),
        200: Color(0xff6abdf9),
        300: Color(0xff43acf7),
        400: Color(0xff1c9bf6),
        500: Color(0xff0986e0),
        600: Color(0xff0766aa),
        700: Color(0xff054574),
        800: Color(0xff02253e),
        900: Color(0xff000508),
        950: Color(0xff000000),
      }));

  runApp(MyApp(
    appCallback: (context) {
      return MaterialApp(
        title: 'Wind Demo',
        theme: WindTheme.toThemeCallback(context),
        home: AppLayoutWidget(Home()),
        routes: {
          '/core/utility_first_wind': (context) =>
              AppLayoutWidget(UtilityFirstWind()),
          '/core/utility_first_flutter': (context) =>
              AppLayoutWidget(UtilityFirstFlutter()),
          '/core/state_based_styling': (context) =>
              AppLayoutWidget(StateBasedStyling()),
          '/core/responsive_design': (context) =>
              AppLayoutWidget(ResponsiveDesign()),
          '/core/dark_mode': (context) => AppLayoutWidget(DarkMode()),
          '/flex/align_items': (context) => AppLayoutWidget(AlignItems()),
          '/flex/flex_direction': (context) => AppLayoutWidget(FlexDirection()),
          '/flex/justify_content': (context) =>
              AppLayoutWidget(JustifyContent()),
          '/flex/gap': (context) => AppLayoutWidget(Gap()),
          '/flex/gap_dynamic': (context) => AppLayoutWidget(GapDynamic()),
          '/flex/axis_sizes': (context) => AppLayoutWidget(AxisSizes()),
          '/flex/scrollable_overflow': (context) =>
              AppLayoutWidget(ScrollableOverflow()),
          '/flex/flex_fit': (context) => AppLayoutWidget(FlexFitWidget()),
          '/flex/flex_x': (context) => AppLayoutWidget(FlexX()),
          '/flex/alignments': (context) => AppLayoutWidget(AlignmentWidget()),
          '/flex/alignment_top_left': (context) =>
              AppLayoutWidget(AlignmentTopLeftWidget()),
          '/flex/alignment_complex': (context) =>
              AppLayoutWidget(AlignmentComplex()),
          '/borders/border_width': (context) => AppLayoutWidget(BorderWidth()),
          '/borders/border_color': (context) => AppLayoutWidget(BorderColor()),
          '/borders/border_color_custom': (context) =>
              AppLayoutWidget(BorderColorCustom()),
          '/borders/border_radius': (context) =>
              AppLayoutWidget(BorderRadiusWidget()),
          '/borders/border_radius_custom': (context) =>
              AppLayoutWidget(BorderRadiusCustom()),
          '/backgrounds/background_color': (context) =>
              AppLayoutWidget(BackgroundColor()),
          '/backgrounds/background_color_custom': (context) =>
              AppLayoutWidget(BackgroundColorCustom()),
          '/typography/text_alignment_center': (context) =>
              AppLayoutWidget(TextAlignmentCenter()),
          '/typography/text_alignment_right': (context) =>
              AppLayoutWidget(TextAlignmentRight()),
          '/typography/text_alignment_justify': (context) =>
              AppLayoutWidget(TextAlignmentJustify()),
          '/typography/text_color_predefined': (context) =>
              AppLayoutWidget(TextColorPredefined()),
          '/typography/text_color_arbitrary': (context) =>
              AppLayoutWidget(TextColorArbitrary()),
          '/typography/text_decoration': (context) =>
              AppLayoutWidget(TextDecorationWidget()),
          '/typography/text_transform': (context) =>
              AppLayoutWidget(TextTransformWidget()),
          '/typography/font_size': (context) => AppLayoutWidget(FontSizeWidget()),
          '/typography/font_size_arbitrary': (context) =>
              AppLayoutWidget(FontSizeArbitraryWidget()),
          '/typography/font_weight': (context) =>
              AppLayoutWidget(FontWeightWidget()),
          '/typography/font_style': (context) =>
              AppLayoutWidget(FontStyleWidget()),
          '/typography/line_height': (context) =>
              AppLayoutWidget(LineHeightWidget()),
          '/typography/letter_spacing': (context) =>
              AppLayoutWidget(LetterSpacingWidget()),
          '/effects/shadow': (context) => AppLayoutWidget(ShadowWidget()),
          '/effects/shadow_custom': (context) =>
              AppLayoutWidget(ShadowCustomWidget()),
          '/sizing/width': (context) => AppLayoutWidget(WidthWidget()),
          '/sizing/max_width': (context) => AppLayoutWidget(MaxWidthWidget()),
          '/sizing/min_width': (context) => AppLayoutWidget(MinWidthWidget()),
          '/sizing/height': (context) => AppLayoutWidget(HeightWidget()),
          '/sizing/max_height': (context) => AppLayoutWidget(MaxHeightWidget()),
          '/sizing/min_height': (context) => AppLayoutWidget(MinHeightWidget()),
          '/spacing/padding': (context) => AppLayoutWidget(PaddingWidget()),
          '/spacing/padding_arbitrary': (context) =>
              AppLayoutWidget(PaddingArbitraryWidget()),
          '/spacing/padding_specific': (context) =>
              AppLayoutWidget(PaddingSpecificWidget()),
          '/spacing/margin': (context) => AppLayoutWidget(MarginWidget()),
          '/spacing/margin_arbitrary': (context) =>
              AppLayoutWidget(MarginArbitraryWidget()),
          '/spacing/margin_specific': (context) =>
              AppLayoutWidget(MarginSpecificWidget()),
          '/widgets/wtext': (context) => AppLayoutWidget(WTextWidget()),
          '/widgets/wtext_parameters': (context) =>
              AppLayoutWidget(WTextParameterWidget()),
          '/widgets/wflex': (context) => AppLayoutWidget(WFlexWidget()),
          '/widgets/wflexcontainer': (context) =>
              AppLayoutWidget(WFlexContainerWidget()),
          '/widgets/wflexible': (context) =>
              AppLayoutWidget(WFlexibleWidget()),
          '/widgets/wcontainer': (context) =>
              AppLayoutWidget(WContainerWidget()),
        },
      );
    },
  ));
}
