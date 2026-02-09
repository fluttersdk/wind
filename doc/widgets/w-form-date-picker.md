# WFormDatePicker

A form-integrated date picker widget that wraps `WDatePicker` with `FormField` to provide built-in validation, labels, hints, and error messaging.

- [Basic Usage](#basic-usage)
- [Constructor](#constructor)
- [Props](#props)
- [Selection Modes](#selection-modes)
- [Event Handling](#event-handling)
- [State Variants](#state-variants)
- [Styling Examples](#styling-examples)
- [All Supported Classes](#all-supported-classes)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="forms/form_date_picker_basic" size="md" source="example/lib/pages/forms/form_date_picker_basic.dart"></x-preview>

<a name="basic-usage"></a>
## Basic Usage

The `WFormDatePicker` simplifies date selection in forms by handling the boilerplate of `FormField`. It automatically displays labels above and error messages/hints below the picker.

```dart
Form(
  child: Column(
    children: [
      WFormDatePicker(
        label: 'Birth Date',
        hint: 'We use this to calculate your age',
        initialValue: DateTime(1990, 1, 1),
        validator: (date) {
          if (date == null) return 'Required';
          if (date.isAfter(DateTime.now())) return 'Cannot be in future';
          return null;
        },
      ),
    ],
  ),
)
```

<a name="constructor"></a>
## Constructor

```dart
WFormDatePicker({
  Key? key,
  DateTime? initialValue,
  String? Function(DateTime?)? validator,
  void Function(DateTime?)? onSaved,
  AutovalidateMode? autovalidateMode,
  bool enabled = true,
  String? label,
  String? labelClassName,
  String? hint,
  String? hintClassName,
  String? errorClassName,
  String? placeholder,
  String? className,
  String? menuClassName,
  DateTime? minDate,
  DateTime? maxDate,
  List<DatePreset>? presets,
  bool showPresets = false,
  ValueChanged<DateTime?>? onChanged,
})
```

<a name="props"></a>
## Props

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `initialValue` | `DateTime?` | `null` | Initial selected date |
| `validator` | `String? Function(DateTime?)?` | `null` | Validation logic |
| `onSaved` | `void Function(DateTime?)?` | `null` | Called when form is saved |
| `label` | `String?` | `null` | Label text displayed above |
| `labelClassName` | `String?` | `null` | Custom styling for the label |
| `hint` | `String?` | `null` | Hint text displayed below |
| `hintClassName` | `String?` | `null` | Custom styling for the hint |
| `errorClassName` | `String?` | `null` | Custom styling for error text |
| `placeholder` | `String?` | `null` | Text shown when no date selected |
| `className` | `String?` | `null` | Styling for the picker trigger |
| `menuClassName` | `String?` | `null` | Styling for the calendar popup |
| `minDate` | `DateTime?` | `null` | Minimum selectable date |
| `maxDate` | `DateTime?` | `null` | Maximum selectable date |
| `presets` | `List<DatePreset>?` | `null` | Quick selection options |
| `showPresets` | `bool` | `false` | Whether to display presets |

<a name="selection-modes"></a>
## Selection Modes

### Date Range Selection
Use `WFormDateRangePicker` for selecting start and end date pairs within a form.

<x-preview path="forms/form_date_range_picker_basic" size="md" source="example/lib/pages/forms/form_date_range_picker_basic.dart"></x-preview>

```dart
WFormDateRangePicker(
  label: 'Stay Duration',
  showPresets: true,
  presets: [
    DatePreset.last7Days(),
    DatePreset.last30Days(),
  ],
  validator: (range) => range == null ? 'Required' : null,
)
```

<a name="event-handling"></a>
## Event Handling

```dart
WFormDatePicker(
  onChanged: (DateTime? date) {
    print('Date changed: $date');
  },
  onSaved: (DateTime? date) {
    // Save to database
  },
)
```

<a name="state-variants"></a>
## State Variants

Since `WFormDatePicker` wraps `WDatePicker`, the `className` supports all interactive state prefixes for the trigger. Additionally, the widget automatically applies error styles when validation fails.

```dart
WFormDatePicker(
  className: 'border-gray-200 hover:border-blue-500 focus:ring-2 focus:ring-blue-200 disabled:bg-gray-50',
  enabled: _isEditable,
)
```

<a name="styling-examples"></a>
## Styling Examples

### Minimal Underline Style
```dart
WFormDatePicker(
  label: 'Appointment',
  className: 'border-b border-gray-300 rounded-none px-0 py-1 bg-transparent hover:border-gray-900',
  labelClassName: 'text-xs uppercase tracking-wider text-gray-500 mb-0',
)
```

### Filled with Custom Error Styling
```dart
WFormDatePicker(
  className: 'bg-gray-100 border-transparent rounded-xl px-4 py-3 focus:bg-white focus:border-blue-500',
  errorClassName: 'text-red-600 font-bold mt-2',
)
```

<a name="all-supported-classes"></a>
## All Supported Classes

| Category | Classes |
|:---------|:--------|
| Layout | `flex`, `grid`, `block`, `hidden` |
| Spacing | `p-{n}`, `m-{n}`, `gap-{n}` |
| Sizing | `w-{size}`, `h-{size}` |
| Typography | `text-{size}`, `font-{weight}` (applied to labels/hints/errors) |
| Colors | `bg-{color}`, `text-{color}` |
| Borders | `border`, `rounded`, `ring` |

<a name="customizing-theme"></a>
## Customizing Theme

Form widgets utilize standard theme scales. You can override global defaults in `WindThemeData`:

```dart
WindTheme(
  data: WindThemeData(
    colors: {
      'primary': Colors.indigo,
    },
    baseSpacingUnit: 4.0,
  ),
  child: MyApp(),
)
```

<a name="related-documentation"></a>
## Related Documentation

- [WDatePicker](./w-date-picker.md) - The underlying date picker widget
- [WFormInput](./w-form-input.md) - Standard text input for forms
- [WFormSelect](./w-form-select.md) - Selection dropdown for forms
