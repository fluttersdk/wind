import 'package:flutter/material.dart';

// Animation
import 'pages/animation/animation_basic.dart';
import 'pages/animation/animation_implicit.dart';

// Backgrounds
import 'pages/backgrounds/colors.dart';
import 'pages/backgrounds/gradients.dart';
import 'pages/backgrounds/image.dart';

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
import 'pages/effects/shadow.dart';
import 'pages/effects/states_basic.dart';
import 'pages/effects/states_custom.dart';
import 'pages/effects/transition_combined.dart';
import 'pages/effects/transition_duration.dart';
import 'pages/effects/transition_ease.dart';

// Examples (Misc)
import 'pages/examples/basic.dart';
import 'pages/examples/blog_section.dart';
import 'pages/examples/hero_card.dart';
import 'pages/examples/showcase.dart';
import 'pages/examples/stacked_layout.dart';
import 'pages/examples/theme_mode.dart';

// Forms
import 'pages/forms/input_basic.dart';
import 'pages/forms/input_states.dart';
import 'pages/forms/form_checkbox_basic.dart';
import 'pages/forms/form_input_basic.dart';
import 'pages/forms/form_select_basic.dart';
import 'pages/forms/input_styled.dart';
import 'pages/forms/select_basic.dart';
import 'pages/forms/select_multi.dart';
import 'pages/forms/select_pagination.dart';
import 'pages/forms/select_searchable.dart';

// Popover
import 'pages/popover/popover_alignment.dart';
import 'pages/popover/popover_basic.dart';

// Home
import 'pages/home.dart';

// Icons
import 'pages/icons/icon_basic.dart';

// Interactivity
import 'pages/interactivity/anchor_basic.dart';

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
import 'pages/layout/grid_responsive.dart';
import 'pages/layout/responsive.dart';
import 'pages/layout/responsive_display.dart';
import 'pages/layout/visibility.dart';
import 'pages/layout/z_index.dart';

// Responsive
import 'pages/responsive/card.dart';
import 'pages/responsive/grid.dart';
import 'pages/responsive/layout.dart';
import 'pages/responsive/spacing.dart';
import 'pages/responsive/typography.dart';
import 'pages/responsive/visibility.dart' as responsive_visibility;

// Sizing
import 'pages/sizing/aspectratio.dart';
import 'pages/sizing/height.dart';
import 'pages/sizing/sizing_overview.dart';
import 'pages/sizing/width.dart';

// Spacing
import 'pages/spacing/margin.dart';
import 'pages/spacing/padding.dart';

// SVG
import 'pages/svg/svg_basic.dart';

// Test
import 'pages/test/chrome_mcp_test.dart';
import 'pages/test/overflow_flex_grid_test.dart';

// Typography
import 'pages/typography/alignment.dart';
import 'pages/typography/basics.dart';
import 'pages/typography/colors.dart';
import 'pages/typography/decoration.dart';
import 'pages/typography/font_family.dart';
import 'pages/typography/font_size.dart';
import 'pages/typography/font_weight.dart';
import 'pages/typography/letter_spacing.dart';
import 'pages/typography/line_height.dart';
import 'pages/typography/text_overflow.dart';
import 'pages/widgets/w_text.dart';
import 'pages/widgets/w_div.dart';
import 'pages/typography/text_transform.dart';

final Map<String, Widget> appRoutes = {
  // Root
  '/': const HomePage(),

  // Animation
  '/animation/animation_basic': const AnimationBasicExamplePage(),
  '/animation/animation_implicit': const AnimationImplicitExamplePage(),

  // Backgrounds
  '/backgrounds/colors': const BackgroundColorsPage(),
  '/backgrounds/gradients': const BackgroundGradientsPage(),
  '/backgrounds/image': const BackgroundImagePage(),

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
  '/effects/shadow': const ShadowExamplePage(),
  '/effects/states_basic': const StatesBasicExamplePage(),
  '/effects/states_custom': const StatesCustomExamplePage(),
  '/effects/transition_combined': const TransitionCombinedPage(),
  '/effects/transition_duration': const TransitionDurationPage(),
  '/effects/transition_ease': const TransitionEasePage(),

  // Examples
  '/examples/basic': const BasicExamplePage(),
  '/examples/blog_section': const BlogSectionExamplePage(),
  '/examples/hero_card': const HeroCardExamplePage(),
  '/examples/showcase': const ShowcaseExamplePage(),
  '/examples/stacked_layout': const StackedLayoutExamplePage(),
  '/examples/theme_mode': const ThemeModeExamplePage(),

  // Forms
  '/forms/input_basic': const InputBasicExamplePage(),
  '/forms/input_states': const InputStatesExamplePage(),
  '/forms/form_checkbox_basic': const FormCheckboxBasicExamplePage(),
  '/forms/form_input_basic': const FormInputBasicExamplePage(),
  '/forms/form_select_basic': const FormSelectBasicExamplePage(),
  '/forms/input_styled': const InputStyledExamplePage(),
  '/forms/select_basic': const SelectBasicExamplePage(),
  '/forms/select_multi': const SelectMultiExamplePage(),
  '/forms/select_pagination': const SelectPaginationExamplePage(),
  '/forms/select_searchable': const SelectSearchableExamplePage(),

  // Popover
  '/popover/popover_basic': const PopoverBasicExamplePage(),
  '/popover/popover_alignment': const PopoverAlignmentExamplePage(),

  // Icons
  '/icons/icon_basic': const IconBasicExamplePage(),

  // Interactivity
  '/interactivity/anchor_basic': const AnchorBasicExamplePage(),

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
  '/layout/grid_responsive': const GridResponsiveExamplePage(),
  '/layout/responsive': const ResponsiveExamplePage(),
  '/layout/responsive_display': const ResponsiveDisplayExamplePage(),
  '/layout/visibility': const VisibilityExamplePage(),
  '/layout/z_index': const ZIndexExamplePage(),

  // Responsive
  '/responsive/card': const ResponsiveCardExamplePage(),
  '/responsive/grid': const ResponsiveGridExamplePage(),
  '/responsive/layout': const ResponsiveLayoutExamplePage(),
  '/responsive/spacing': const ResponsiveSpacingExamplePage(),
  '/responsive/typography': const ResponsiveTypographyExamplePage(),
  '/responsive/visibility':
      const responsive_visibility.ResponsiveVisibilityExamplePage(),

  // Sizing
  '/sizing/aspectratio': const AspectRatioExamplePage(),
  '/sizing/height': const HeightExamplePage(),
  '/sizing/sizing_overview': const SizingOverviewExamplePage(),
  '/sizing/width': const WidthExamplePage(),

  // Spacing
  '/spacing/margin': const MarginExamplePage(),
  '/spacing/padding': const PaddingExamplePage(),

  // SVG
  '/svg/svg_basic': const SvgBasicExamplePage(),

  // Test
  '/test/chrome-mcp': const ChromeMcpTestPage(),
  '/test/overflow-flex-grid': const OverflowFlexGridTestPage(),

  // Typography
  '/typography/alignment': const TypographyAlignmentPage(),
  '/typography/basics': const TypographyBasicsPage(),
  '/typography/colors': const TypographyColorsPage(),
  '/typography/decoration': const TypographyDecorationPage(),
  '/typography/font_family': const FontFamilyExamplePage(),
  '/typography/font_size': const FontSizeExamplePage(),
  '/typography/font_weight': const FontWeightExamplePage(),
  '/typography/letter_spacing': const LetterSpacingExamplePage(),
  '/typography/line_height': const LineHeightExamplePage(),
  '/typography/text_overflow': const TextOverflowExamplePage(),
  '/widgets/w_text': const WTextExamplePage(),
  '/widgets/w_div': const WDivExamplePage(),
  '/typography/text_transform': const TextTransformExamplePage(),
};
