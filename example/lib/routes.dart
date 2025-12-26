import 'package:flutter/material.dart';

// Animation
import 'pages/animation/animation_basic.dart';
import 'pages/animation/animation_implicit.dart';

// Backgrounds
import 'pages/backgrounds/colors.dart';
import 'pages/backgrounds/gradients.dart';

// Borders
import 'pages/borders/colors_arbitrary.dart';
import 'pages/borders/colors_theme.dart';
import 'pages/borders/radius_basic.dart';
import 'pages/borders/width_basic.dart';
import 'pages/borders/width_sides.dart';

// Buttons
import 'pages/buttons/button_basic.dart';
import 'pages/buttons/button_states.dart';

// Checkbox
import 'pages/checkbox/checkbox_basic.dart';

// Effects
import 'pages/effects/opacity.dart';
import 'pages/effects/overflow_basic.dart';
import 'pages/effects/overflow_directional.dart';
import 'pages/effects/ring_basic.dart';
import 'pages/effects/ring_colors.dart';
import 'pages/effects/ring_opacity.dart';
import 'pages/effects/shadows_basic.dart';
import 'pages/effects/shadows_colored.dart';
import 'pages/effects/states_basic.dart';
import 'pages/effects/states_custom.dart';
import 'pages/effects/transition_combined.dart';
import 'pages/effects/transition_duration.dart';
import 'pages/effects/transition_ease.dart';

// Examples (Misc)
import 'pages/examples/basic.dart';

// Forms
import 'pages/forms/input_basic.dart';
import 'pages/forms/input_states.dart';
import 'pages/forms/input_styled.dart';
import 'pages/forms/select_basic.dart';
import 'pages/forms/select_multi.dart';
import 'pages/forms/select_pagination.dart';
import 'pages/forms/select_searchable.dart';

// Home
import 'pages/home.dart';

// Icons
import 'pages/icons/icon_basic.dart';

// Images
import 'pages/images/image_basic.dart';

// Layout
import 'pages/layout/display.dart';
import 'pages/layout/flex_align.dart';
import 'pages/layout/flex_basic.dart';
import 'pages/layout/flex_grow.dart';
import 'pages/layout/flex_justify.dart';
import 'pages/layout/grid_cols.dart';
import 'pages/layout/grid_gap.dart';
import 'pages/layout/responsive.dart';
import 'pages/layout/visibility.dart';

// Sizing
import 'pages/sizing/aspectratio.dart';
import 'pages/sizing/height.dart';
import 'pages/sizing/width.dart';

// Spacing
import 'pages/spacing/margin.dart';
import 'pages/spacing/padding.dart';

// SVG
import 'pages/svg/svg_basic.dart';

// Typography
import 'pages/typography/alignment.dart';
import 'pages/typography/basics.dart';
import 'pages/typography/colors.dart';
import 'pages/typography/decoration.dart';
import 'pages/typography/font_family.dart';

final Map<String, Widget> appRoutes = {
  // Root
  '/': const HomePage(),

  // Animation
  '/animation/animation_basic': const AnimationBasicExamplePage(),
  '/animation/animation_implicit': const AnimationImplicitExamplePage(),

  // Backgrounds
  '/backgrounds/colors': const BackgroundColorsPage(),
  '/backgrounds/gradients': const BackgroundGradientsPage(),

  // Borders
  '/borders/colors_arbitrary': const ColorsArbitraryPage(),
  '/borders/colors_theme': const ColorsThemePage(),
  '/borders/radius_basic': const RadiusBasicPage(),
  '/borders/width_basic': const WidthBasicPage(),
  '/borders/width_sides': const WidthSidesPage(),

  // Buttons
  '/buttons/button_basic': const ButtonBasicExamplePage(),
  '/buttons/button_states': const ButtonStatesExamplePage(),

  // Checkbox
  '/checkbox/checkbox_basic': const CheckboxBasicExamplePage(),

  // Effects
  '/effects/opacity': const OpacityExamplePage(),
  '/effects/overflow_basic': const OverflowBasicExamplePage(),
  '/effects/overflow_directional': const OverflowDirectionalExamplePage(),
  '/effects/ring_basic': const RingBasicExamplePage(),
  '/effects/ring_colors': const RingColorsExamplePage(),
  '/effects/ring_opacity': const RingOpacityExamplePage(),
  '/effects/shadows_basic': const ShadowsBasicExamplePage(),
  '/effects/shadows_colored': const ShadowsColoredExamplePage(),
  '/effects/states_basic': const StatesBasicExamplePage(),
  '/effects/states_custom': const StatesCustomExamplePage(),
  '/effects/transition_combined': const TransitionCombinedPage(),
  '/effects/transition_duration': const TransitionDurationPage(),
  '/effects/transition_ease': const TransitionEasePage(),

  // Examples
  '/examples/basic': const BasicExamplePage(),

  // Forms
  '/forms/input_basic': const InputBasicExamplePage(),
  '/forms/input_states': const InputStatesExamplePage(),
  '/forms/input_styled': const InputStyledExamplePage(),
  '/forms/select_basic': const SelectBasicExamplePage(),
  '/forms/select_multi': const SelectMultiExamplePage(),
  '/forms/select_pagination': const SelectPaginationExamplePage(),
  '/forms/select_searchable': const SelectSearchableExamplePage(),

  // Icons
  '/icons/icon_basic': const IconBasicExamplePage(),

  // Images
  '/images/image_basic': const ImageBasicExamplePage(),

  // Layout
  '/layout/display': const DisplayExamplePage(),
  '/layout/flex_align': const FlexAlignExamplePage(),
  '/layout/flex_basic': const FlexBasicExamplePage(),
  '/layout/flex_grow': const FlexGrowExamplePage(),
  '/layout/flex_justify': const FlexJustifyExamplePage(),
  '/layout/grid_cols': const GridColsExamplePage(),
  '/layout/grid_gap': const GridGapExamplePage(),
  '/layout/responsive': const ResponsiveExamplePage(),
  '/layout/visibility': const VisibilityExamplePage(),

  // Sizing
  '/sizing/aspectratio': const AspectRatioExamplePage(),
  '/sizing/height': const HeightExamplePage(),
  '/sizing/width': const WidthExamplePage(),

  // Spacing
  '/spacing/margin': const MarginExamplePage(),
  '/spacing/padding': const PaddingExamplePage(),

  // SVG
  '/svg/svg_basic': const SvgBasicExamplePage(),

  // Typography
  '/typography/alignment': const TypographyAlignmentPage(),
  '/typography/basics': const TypographyBasicsPage(),
  '/typography/colors': const TypographyColorsPage(),
  '/typography/decoration': const TypographyDecorationPage(),
  '/typography/font_family': const FontFamilyExamplePage(),
};
