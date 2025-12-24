import 'package:flutter/material.dart';

import 'pages/borders/colors_arbitrary.dart';
import 'pages/borders/colors_theme.dart';
import 'pages/borders/radius_basic.dart';
import 'pages/borders/width_basic.dart';
import 'pages/borders/width_sides.dart';
import 'pages/examples/basic.dart';
import 'pages/home.dart';
import 'pages/layout/display.dart';
import 'pages/layout/flex_align.dart';
import 'pages/layout/flex_basic.dart';
import 'pages/layout/flex_grow.dart';
import 'pages/layout/flex_justify.dart';
import 'pages/layout/grid_cols.dart';
import 'pages/layout/grid_gap.dart';
import 'pages/layout/responsive.dart';
import 'pages/backgrounds/colors.dart';
import 'pages/backgrounds/gradients.dart';
import 'pages/layout/visibility.dart';
import 'pages/sizing/height.dart';
import 'pages/sizing/width.dart';
import 'pages/spacing/margin.dart';
import 'pages/spacing/padding.dart';
import 'pages/typography/alignment.dart';
import 'pages/typography/basics.dart';
import 'pages/typography/colors.dart';
import 'pages/typography/decoration.dart';

// Effects
import 'pages/effects/shadows_basic.dart';
import 'pages/effects/shadows_colored.dart';

final Map<String, Widget> appRoutes = {
  // Effects
  '/effects/shadows_basic': ShadowsBasicExamplePage(),
  '/effects/shadows_colored': ShadowsColoredExamplePage(),
  '/': HomePage(),
  '/examples/basic': BasicExamplePage(),
  '/borders/radius_basic': RadiusBasicPage(),
  '/borders/width_basic': WidthBasicPage(),
  '/borders/width_sides': WidthSidesPage(),
  '/borders/colors_theme': ColorsThemePage(),
  '/borders/colors_arbitrary': ColorsArbitraryPage(),
  '/typography/basics': TypographyBasicsPage(),
  '/typography/colors': TypographyColorsPage(),
  '/typography/alignment': TypographyAlignmentPage(),

  '/typography/decoration': TypographyDecorationPage(),
  '/layout/display': DisplayExamplePage(),
  '/layout/visibility': VisibilityExamplePage(),
  '/layout/flex_basic': FlexBasicExamplePage(),
  '/layout/flex_grow': FlexGrowExamplePage(),
  '/layout/flex_justify': FlexJustifyExamplePage(),
  '/layout/flex_align': FlexAlignExamplePage(),
  '/layout/grid_cols': GridColsExamplePage(),
  '/layout/grid_gap': GridGapExamplePage(),
  '/layout/responsive': ResponsiveExamplePage(),
  '/spacing/padding': PaddingExamplePage(),
  '/spacing/margin': MarginExamplePage(),
  '/sizing/width': WidthExamplePage(),
  '/sizing/height': HeightExamplePage(),
  '/backgrounds/colors': BackgroundColorsPage(),
  '/backgrounds/gradients': BackgroundGradientsPage(),
};
