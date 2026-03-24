---
path: "lib/src/widgets/**/*.dart"
---

# Widget Domain

- All widgets use `W` prefix: `WDiv`, `WButton`, `WText`, `WFormInput`, `WSvg`
- Form-integrated variants: `WForm{Feature}` (WFormInput, WFormSelect, WFormCheckbox, WFormDatePicker)
- Always `const` constructor with `super.key` first, required params next, optional last, trailing commas
- One class per file named after the widget: `w_button.dart` → `WButton` + `_WButtonState`
- `className` is the primary styling API — it takes precedence over any explicit style properties
- Widget build flow: parse className → detect displayType (flex/grid/block) → build minimal widget tree
- Use `WindParser.parse(className, WindContext.of(context), states: states)` — always with context
- WAnchor is required for `hover:`, `focus:`, `active:` states — WDiv auto-wraps if these prefixes detected
- `child` XOR `children` — never both. `child` for single content, `children` for flex/grid layouts
- Loading state (`isLoading: true`) disables all callbacks and activates `loading:` prefixed classes
- Disabled state (`disabled: true`) activates `disabled:` prefixed classes
- Custom states via `Set<String>? states` parameter — used with matching prefixes like `selected:`, `active:`
- Never hardcode colors or sizes — resolve through className or theme
- DartDoc: `/// **The Utility-First [Name]**` header, then `### Supported Features:` and `### Example Usage:` sections
