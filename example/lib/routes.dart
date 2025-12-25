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
import 'pages/sizing/aspectratio.dart';
import 'pages/spacing/margin.dart';
import 'pages/spacing/padding.dart';
import 'pages/typography/alignment.dart';
import 'pages/typography/basics.dart';
import 'pages/typography/colors.dart';
import 'pages/typography/decoration.dart';
import 'pages/typography/font_family.dart';

// Effects
import 'pages/effects/shadows_basic.dart';
import 'pages/effects/shadows_colored.dart';
import 'pages/effects/opacity.dart';
import 'pages/effects/overflow_basic.dart';
import 'pages/effects/overflow_directional.dart';
import 'pages/effects/transition_duration.dart';
import 'pages/effects/transition_ease.dart';
import 'pages/effects/transition_combined.dart';
import 'pages/effects/ring_basic.dart';
import 'pages/effects/ring_colors.dart';
import 'pages/effects/ring_opacity.dart';
import 'pages/effects/states_basic.dart';
import 'pages/effects/states_custom.dart';

// Forms
import 'pages/forms/input_basic.dart';
import 'pages/forms/input_styled.dart';
import 'pages/forms/input_states.dart';

final Map<String, Widget> appRoutes = {
  // Effects
  '/effects/shadows_basic': const ShadowsBasicExamplePage(),
  '/effects/shadows_colored': const ShadowsColoredExamplePage(),
  '/effects/opacity': const OpacityExamplePage(),
  '/effects/overflow_basic': const OverflowBasicExamplePage(),
  '/effects/overflow_directional': const OverflowDirectionalExamplePage(),
  '/effects/transition_duration': const TransitionDurationPage(),
  '/effects/transition_ease': const TransitionEasePage(),
  '/effects/transition_combined': const TransitionCombinedPage(),
  '/effects/ring_basic': const RingBasicExamplePage(),
  '/effects/ring_colors': const RingColorsExamplePage(),
  '/effects/ring_opacity': const RingOpacityExamplePage(),
  '/effects/states_basic': const StatesBasicExamplePage(),
  '/effects/states_custom': const StatesCustomExamplePage(),
  // Forms
  '/forms/input_basic': const InputBasicExamplePage(),
  '/forms/input_styled': const InputStyledExamplePage(),
  '/forms/input_states': const InputStatesExamplePage(),
  '/': const HomePage(),
  '/examples/basic': const BasicExamplePage(),
  '/borders/radius_basic': const RadiusBasicPage(),
  '/borders/width_basic': const WidthBasicPage(),
  '/borders/width_sides': const WidthSidesPage(),
  '/borders/colors_theme': const ColorsThemePage(),
  '/borders/colors_arbitrary': const ColorsArbitraryPage(),
  '/typography/basics': const TypographyBasicsPage(),
  '/typography/colors': const TypographyColorsPage(),
  '/typography/alignment': const TypographyAlignmentPage(),

  '/typography/decoration': const TypographyDecorationPage(),
  '/typography/font_family': const FontFamilyExamplePage(),
  '/layout/display': const DisplayExamplePage(),
  '/layout/visibility': const VisibilityExamplePage(),
  '/layout/flex_basic': const FlexBasicExamplePage(),
  '/layout/flex_grow': const FlexGrowExamplePage(),
  '/layout/flex_justify': const FlexJustifyExamplePage(),
  '/layout/flex_align': const FlexAlignExamplePage(),
  '/layout/grid_cols': const GridColsExamplePage(),
  '/layout/grid_gap': const GridGapExamplePage(),
  '/layout/responsive': const ResponsiveExamplePage(),
  '/spacing/padding': const PaddingExamplePage(),
  '/spacing/margin': const MarginExamplePage(),
  '/sizing/width': const WidthExamplePage(),
  '/sizing/height': const HeightExamplePage(),
  '/sizing/aspectratio': const AspectRatioExamplePage(),
  '/backgrounds/colors': const BackgroundColorsPage(),
  '/backgrounds/gradients': const BackgroundGradientsPage(),
};
