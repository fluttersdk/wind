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
import 'pages/borders/borders_preview.dart';

// Buttons
import 'pages/buttons/button_basic.dart';
import 'pages/buttons/button_states.dart';

// Checkbox
import 'pages/checkbox/checkbox_basic.dart';

// Core Concepts
import 'pages/core-concepts/dark_mode_basic.dart';
import 'pages/core-concepts/debugging_basic.dart';
import 'pages/core-concepts/dynamic_rendering_basic.dart';
import 'pages/core-concepts/responsive_basic.dart';
import 'pages/core-concepts/state_management_overview.dart';
import 'pages/core-concepts/theme_binding.dart';
import 'pages/core-concepts/theming_example.dart';
import 'pages/core-concepts/utility_first_hero.dart';

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
import 'pages/forms/form_date_picker_basic.dart';
import 'pages/forms/form_date_picker_range.dart';
import 'pages/getting-started/installation_basic.dart';
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

// Icons
import 'pages/icons/icon_basic.dart';

// Interactivity
import 'pages/interactivity/anchor_basic.dart';
import 'pages/interactivity/animation_basic.dart';
import 'pages/interactivity/cursor_basic.dart';
import 'pages/interactivity/transition_basic.dart';

// Images
import 'pages/images/image_basic.dart';

// Layout
import 'pages/layout/display.dart';
import 'pages/layout/flex_align.dart';
import 'pages/layout/flex_basic.dart';
import 'pages/layout/flex_intro.dart';
import 'pages/layout/flex_grow.dart';
import 'pages/layout/flex_justify.dart';
import 'pages/layout/grid_cols.dart';
import 'pages/layout/grid_gap.dart';
import 'pages/layout/grid_responsive.dart';
import 'pages/layout/responsive.dart';
import 'pages/layout/responsive_display.dart';
import 'pages/layout/visibility.dart';
import 'pages/layout/z_index.dart';
import 'pages/layout/z_index_basic.dart';
import 'pages/layout/z_index_hover.dart';
import 'pages/layout/sizing_basic.dart';
import 'pages/layout/sizing_width.dart';
import 'pages/layout/sizing_height.dart';
import 'pages/layout/aspect_ratio_basic.dart';
import 'pages/layout/positioning.dart';

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
import 'pages/spacing/padding_margin_basic.dart';
import 'pages/spacing/directional.dart';

// Styling
import 'pages/styling/background_color_basic.dart';
import 'pages/styling/background_color_opacity.dart';
import 'pages/styling/background_gradient_basic.dart';
import 'pages/styling/background_gradient_stops.dart';
import 'pages/styling/wind_recipe_basic.dart';

// SVG
import 'pages/svg/svg_basic.dart';

// Utilities
import 'pages/utilities/color_helpers_basic.dart';
import 'pages/utilities/context_extensions_basic.dart';
import 'pages/utilities/responsive_helpers_basic.dart';
import 'pages/utilities/spacing_helpers_basic.dart';
import 'pages/utilities/style_parser_basic.dart';
import 'pages/utilities/typography_helpers_basic.dart';

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
import 'pages/widgets/w_text_transform.dart';
import 'pages/typography/text_transform.dart';
import 'pages/typography/text_overflow_truncate.dart';
import 'pages/typography/text_overflow_clip.dart';
import 'pages/typography/text_overflow_line_clamp.dart';
import 'pages/typography/text_color_basic.dart';
import 'pages/typography/text_color_opacity.dart';
import 'pages/typography/text_align_basic.dart';
import 'pages/typography/text_align_responsive.dart';
import 'pages/typography/decoration_color.dart';
import 'pages/typography/decoration_style.dart';
import 'pages/typography/decoration_thickness.dart';
import 'pages/typography/font_weight_basic.dart';
import 'pages/typography/font_style_basic.dart';
import 'pages/typography/whitespace_preview.dart';

// Widgets
import 'pages/widgets/w_breakpoint.dart';
import 'pages/widgets/w_date_picker.dart';
import 'pages/widgets/date_picker_basic.dart';
import 'pages/widgets/date_picker_range.dart';
import 'pages/widgets/date_picker_styled.dart';
import 'pages/widgets/w_dynamic_basic.dart';
import 'pages/widgets/w_input_multiline.dart';
import 'pages/widgets/w_input_search.dart';
import 'pages/widgets/w_image_fit.dart';
import 'pages/widgets/w_image_ratio.dart';
import 'pages/widgets/w_select_single.dart';
import 'pages/widgets/w_select_multi.dart';
import 'pages/widgets/w_popover_alignment.dart';
import 'pages/widgets/w_div_basic.dart';
import 'pages/widgets/w_spacer_basic.dart';
import 'pages/widgets/w_spacer_responsive.dart';
import 'pages/widgets/w_button_centered.dart';
import 'pages/widgets/w_icon_sizing.dart';
import 'pages/widgets/w_anchor_flex.dart';
import 'pages/widgets/w_form_input.dart';
import 'pages/widgets/w_form_input_layout.dart';
import 'pages/widgets/w_form_select.dart';
import 'pages/widgets/w_form_multiselect.dart';
import 'pages/widgets/w_form_checkbox.dart';
import 'pages/widgets/w_form_checkbox_layout.dart';
import 'pages/widgets/w_keyboard_actions_basic.dart';
import 'pages/widgets/wind_animation_wrapper_basic.dart';

import 'pages/widgets/w_badge_basic.dart';
import 'pages/widgets/w_card_basic.dart';
import 'pages/widgets/w_radio_basic.dart';
import 'pages/widgets/w_switch_basic.dart';
import 'pages/widgets/w_tabs_basic.dart';

import 'pages/widgets/w_svg.dart';

final Map<String, Widget> appRoutes = {
  // Animation
  '/animation/animation_basic': const AnimationBasicExamplePage(),
  '/animation/animation_implicit': const AnimationImplicitExamplePage(),

  // Backgrounds
  '/backgrounds/colors': const BackgroundColorsPage(),
  '/backgrounds/gradients': const BackgroundGradientsPage(),
  '/backgrounds/image': const BackgroundImagePage(),

  // Borders
  '/borders/borders_preview': const BordersPreviewExamplePage(),
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

  // Core Concepts
  '/core-concepts/dark_mode_basic': const DarkModeBasicExamplePage(),
  '/core-concepts/debugging_basic': const DebuggingBasicExamplePage(),
  '/core-concepts/dynamic_rendering_basic':
      const DynamicRenderingBasicExamplePage(),
  '/core-concepts/responsive_basic': const ResponsiveBasicExamplePage(),
  '/core-concepts/state_management_overview':
      const StateManagementOverviewExamplePage(),
  '/core-concepts/theme_binding': const ThemeBindingExamplePage(),
  '/core-concepts/theming_example': const ThemingExamplePage(),
  '/core-concepts/utility_first_hero': const UtilityFirstHeroExamplePage(),

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

  // Getting Started
  '/': const InstallationBasicExamplePage(),

  // Forms
  '/forms/input_basic': const InputBasicExamplePage(),
  '/forms/input_states': const InputStatesExamplePage(),
  '/forms/form_checkbox_basic': const FormCheckboxBasicExamplePage(),
  '/forms/form_date_picker_basic': const FormDatePickerBasicExamplePage(),
  '/forms/form_date_picker_range': const FormDatePickerRangeExamplePage(),
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
  '/interactivity/animation_basic': const InteractivityAnimationExamplePage(),
  '/interactivity/cursor_basic': const CursorBasicExamplePage(),
  '/interactivity/transition_basic': const TransitionBasicExamplePage(),

  // Images
  '/images/image_basic': const ImageBasicExamplePage(),

  // Layout
  '/layout/display': const DisplayExamplePage(),
  '/layout/flex_align': const FlexAlignExamplePage(),
  '/layout/flex_basic': const FlexBasicExamplePage(),
  '/layout/flex_intro': const FlexIntroExamplePage(),
  '/layout/flex_grow': const FlexGrowExamplePage(),
  '/layout/flex_justify': const FlexJustifyExamplePage(),
  '/layout/grid_cols': const GridColsExamplePage(),
  '/layout/grid_gap': const GridGapExamplePage(),
  '/layout/grid_responsive': const GridResponsiveExamplePage(),
  '/layout/responsive': const ResponsiveExamplePage(),
  '/layout/responsive_display': const ResponsiveDisplayExamplePage(),
  '/layout/visibility': const VisibilityExamplePage(),
  '/layout/z_index': const ZIndexExamplePage(),
  '/layout/z_index_basic': const ZIndexBasicExamplePage(),
  '/layout/z_index_hover': const ZIndexHoverExamplePage(),
  '/layout/sizing_basic': const SizingBasicExamplePage(),
  '/layout/sizing_width': const SizingWidthExamplePage(),
  '/layout/sizing_height': const SizingHeightExamplePage(),
  '/layout/aspect_ratio_basic': const AspectRatioBasicExamplePage(),
  '/layout/positioning': const PositioningExamplePage(),

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
  '/spacing/padding_margin_basic': const PaddingMarginBasicExamplePage(),
  '/spacing/directional': const DirectionalExamplePage(),

  // Styling
  '/styling/background_color_basic': const BackgroundColorBasicExamplePage(),
  '/styling/background_color_opacity':
      const BackgroundColorOpacityExamplePage(),
  '/styling/background_gradient_basic':
      const BackgroundGradientBasicExamplePage(),
  '/styling/background_gradient_stops':
      const BackgroundGradientStopsExamplePage(),
  '/styling/wind_recipe_basic': const WindRecipeBasicExamplePage(),

  // SVG
  '/svg/svg_basic': const SvgBasicExamplePage(),

  // Utilities
  '/utilities/color_helpers_basic': const ColorHelpersBasicExamplePage(),
  '/utilities/context_extensions_basic':
      const ContextExtensionsBasicExamplePage(),
  '/utilities/responsive_helpers_basic':
      const ResponsiveHelpersBasicExamplePage(),
  '/utilities/spacing_helpers_basic': const SpacingHelpersBasicExamplePage(),
  '/utilities/style_parser_basic': const StyleParserBasicExamplePage(),
  '/utilities/typography_helpers_basic':
      const TypographyHelpersBasicExamplePage(),

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
  '/widgets/w_text_transform': const WTextTransformExamplePage(),
  '/widgets/w_div': const WDivExamplePage(),
  '/typography/text_transform': const TextTransformExamplePage(),
  '/typography/text_overflow_truncate': const TextOverflowTruncateExamplePage(),
  '/typography/text_overflow_clip': const TextOverflowClipExamplePage(),
  '/typography/text_overflow_line_clamp':
      const TextOverflowLineClampExamplePage(),
  '/typography/text_color_basic': const TextColorBasicExamplePage(),
  '/typography/text_color_opacity': const TextColorOpacityExamplePage(),
  '/typography/text_align_basic': const TextAlignBasicExamplePage(),
  '/typography/text_align_responsive': const TextAlignResponsiveExamplePage(),
  '/typography/decoration_color': const DecorationColorExamplePage(),
  '/typography/decoration_style': const DecorationStyleExamplePage(),
  '/typography/decoration_thickness': const DecorationThicknessExamplePage(),
  '/typography/font_weight_basic': const FontWeightBasicExamplePage(),
  '/typography/font_style_basic': const FontStyleBasicExamplePage(),
  '/typography/whitespace_preview': const WhitespacePreviewExamplePage(),

  // Widgets
  '/widgets/w_input_multiline': const WInputMultilineExamplePage(),
  '/widgets/w_input_search': const WInputSearchExamplePage(),
  '/widgets/w_breakpoint': const WBreakpointExamplePage(),
  '/widgets/w_date_picker': const WDatePickerExamplePage(),
  '/widgets/date_picker_basic': const DatePickerBasicExamplePage(),
  '/widgets/date_picker_range': const DatePickerRangeExamplePage(),
  '/widgets/date_picker_styled': const DatePickerStyledExamplePage(),
  '/widgets/w_dynamic_basic': WDynamicBasicExamplePage(),
  '/widgets/w_image_fit': const WImageFitExamplePage(),
  '/widgets/w_image_ratio': const WImageRatioExamplePage(),
  '/widgets/w_select_single': const WSelectSingleExamplePage(),
  '/widgets/w_select_multi': const WSelectMultiExamplePage(),
  '/widgets/w_popover_alignment': const WPopoverAlignmentExamplePage(),
  '/widgets/w_div_basic': const WDivBasicExamplePage(),
  '/widgets/w_spacer_basic': const WSpacerBasicExamplePage(),
  '/widgets/w_spacer_responsive': const WSpacerResponsiveExamplePage(),
  '/widgets/w_button_centered': const WButtonCenteredExamplePage(),
  '/widgets/w_icon_sizing': const WIconSizingExamplePage(),
  '/widgets/w_anchor_flex': const WAnchorFlexExamplePage(),
  '/widgets/w_form_input': const WFormInputExamplePage(),
  '/widgets/w_form_input_layout': const WFormInputLayoutExamplePage(),
  '/widgets/w_form_select': const WFormSelectExamplePage(),
  '/widgets/w_form_multiselect': const WFormMultiSelectExamplePage(),
  '/widgets/w_form_checkbox': const WFormCheckboxExamplePage(),
  '/widgets/w_form_checkbox_layout': const WFormCheckboxLayoutExamplePage(),
  '/widgets/w_keyboard_actions_basic': const WKeyboardActionsBasicExamplePage(),
  '/widgets/wind_animation_wrapper_basic':
      const WindAnimationWrapperBasicExamplePage(),

  '/widgets/w_badge_basic': const WBadgeBasicExamplePage(),
  '/widgets/w_card_basic': const WCardBasicExamplePage(),
  '/widgets/w_radio_basic': const WRadioBasicExamplePage(),
  '/widgets/w_switch_basic': const WSwitchBasicExamplePage(),
  '/widgets/w_tabs_basic': const WTabsBasicExamplePage(),

  '/widgets/w_svg': const WSvgExamplePage(),
};
