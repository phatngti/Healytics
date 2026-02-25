---
name: quill-data
description: Expert knowledge for creating Quill Delta JSON data for FlutterQuillEditor widgets. Use when building autofill content, mock data, or API payloads that target rich-text Quill editor fields.
---

# Quill Delta Data

## When to Use
- Populating `FormFieldBuilders.buildQuillEditor` fields in autofill constants.
- Creating mock data for description/content fields that use Quill.
- Building or parsing API payloads containing rich-text Delta content.
- Debugging Quill editor rendering issues caused by malformed Delta JSON.

## Delta Format Overview

A Quill Delta is a JSON array of **operation objects** (`ops`). For document
content, every op is an `insert`:

```json
[
  { "insert": "Hello " },
  { "insert": "World", "attributes": { "bold": true } },
  { "insert": "\n" }
]
```

### Rules
1. **Must end with `\n`** — every valid Delta document ends with a newline.
2. **Line formatting** lives on the `\n` character (headers, lists, alignment).
3. **Embeds** use an object as the `insert` value (e.g. `{ "image": "url" }`).
4. **Embeds have length 1** — each embed is exactly one character slot.
5. **Attributes are optional** — omit for unformatted text.

---

## Dart Representation

### As widget constructor argument (`List<Map<String, Object>>`)
```dart
final content = <Map<String, Object>>[
  {'insert': 'Hello World\n'},
];
FlutterQuillEditor(initialContent: content);
```

### As FormBuilder field value (`String` — JSON-encoded)
```dart
import 'dart:convert';

// FormBuilder stores Quill content as a JSON string.
final jsonString = jsonEncode([
  {'insert': 'Hello World\n'},
]);
// → '[{"insert":"Hello World\\n"}]'
```

### In autofill constants
```dart
abstract final class MyAutofill {
  /// Quill Delta JSON for the description field.
  static const description =
      '[{"insert":"Product overview\\n","attributes":{"header":1}}'
      ',{"insert":"A luxurious treatment.\\n"}]';
}
```

---

## Common Patterns

### Plain Text
```dart
[{'insert': 'Simple plain text paragraph.\n'}]
```

### Bold / Italic / Underline
```dart
[
  {'insert': 'Bold', 'attributes': {'bold': true}},
  {'insert': ' and '},
  {'insert': 'italic', 'attributes': {'italic': true}},
  {'insert': ' text.\n'},
]
```

### Headers (H1, H2, H3)
```dart
[
  {'insert': 'Main Title'},
  {'insert': '\n', 'attributes': {'header': 1}},
  {'insert': 'Subtitle'},
  {'insert': '\n', 'attributes': {'header': 2}},
  {'insert': 'Body text follows.\n'},
]
```

### Bullet List
```dart
[
  {'insert': 'First item'},
  {'insert': '\n', 'attributes': {'list': 'bullet'}},
  {'insert': 'Second item'},
  {'insert': '\n', 'attributes': {'list': 'bullet'}},
]
```

### Ordered List
```dart
[
  {'insert': 'Step one'},
  {'insert': '\n', 'attributes': {'list': 'ordered'}},
  {'insert': 'Step two'},
  {'insert': '\n', 'attributes': {'list': 'ordered'}},
]
```

### Link
```dart
[
  {'insert': 'Visit our site', 'attributes': {'link': 'https://example.com'}},
  {'insert': '\n'},
]
```

### Image Embed
```dart
[
  {'insert': {'image': 'https://example.com/photo.jpg'}},
  {'insert': '\n'},
]
```

### Mixed Rich Content (realistic example)
```dart
[
  {'insert': 'Signature Rejuvenating Facial'},
  {'insert': '\n', 'attributes': {'header': 1}},
  {'insert': 'A luxurious 90-minute facial treatment using '
             'premium botanical extracts.\n'},
  {'insert': 'Key Benefits'},
  {'insert': '\n', 'attributes': {'header': 2}},
  {'insert': 'Deep hydration and nourishment'},
  {'insert': '\n', 'attributes': {'list': 'bullet'}},
  {'insert': 'Brightens and evens skin tone'},
  {'insert': '\n', 'attributes': {'list': 'bullet'}},
  {'insert': 'Reduces fine lines and wrinkles'},
  {'insert': '\n', 'attributes': {'list': 'bullet'}},
  {'insert': '\nIdeal for all skin types. '},
  {'insert': 'Book now', 'attributes': {
    'bold': true,
    'link': 'https://healytics.dev/book',
  }},
  {'insert': ' to experience the difference.\n'},
]
```

---

## Available Inline Attributes

| Attribute     | Type      | Example                         |
|---------------|-----------|---------------------------------|
| `bold`        | `bool`    | `{'bold': true}`                |
| `italic`      | `bool`    | `{'italic': true}`              |
| `underline`   | `bool`    | `{'underline': true}`           |
| `strike`      | `bool`    | `{'strike': true}`              |
| `link`        | `String`  | `{'link': 'https://...'}`       |
| `color`       | `String`  | `{'color': '#ff0000'}`          |
| `background`  | `String`  | `{'background': '#ffff00'}`     |
| `font`        | `String`  | `{'font': 'monospace'}`         |
| `size`        | `String`  | `{'size': 'large'}`             |
| `script`      | `String`  | `{'script': 'super'}` or `'sub'`|
| `code`        | `bool`    | `{'code': true}`                |

## Available Line Attributes (on `\n` only)

| Attribute       | Type      | Values                          |
|-----------------|-----------|---------------------------------|
| `header`        | `int`     | `1`, `2`, `3`                   |
| `list`          | `String`  | `'bullet'`, `'ordered'`, `'checked'`, `'unchecked'` |
| `blockquote`    | `bool`    | `true`                          |
| `code-block`    | `bool`    | `true`                          |
| `indent`        | `int`     | `1`, `2`, `3`, …                |
| `align`         | `String`  | `'center'`, `'right'`, `'justify'` |
| `direction`     | `String`  | `'rtl'`                         |

---

## Integration with `_AppQuillEditorField`

The form field wrapper ([quill_editor_field.dart](file:///Volumes/WD850X/Users/workspace/datn/Healytics/healytic_fe/common/lib/widgets/input/quill_editor_field.dart)) handles two input formats:

1. **Valid JSON array** — parsed via `jsonDecode` → `List<Map<String, Object>>`
2. **Plain text fallback** — wrapped as `[{'insert': '$value\n'}]`

For rich autofill content, **always provide valid Delta JSON** (option 1) to
preserve formatting. Plain text fallback strips all formatting.

### How the field stores data
- On change → `jsonEncode(delta.toJson())` → stored as `String` in FormBuilder.
- On read → `jsonDecode(stringValue)` → `List<Map<String, Object>>` → `Document.fromJson()`.

---

## Validation Checklist

- [ ] Delta array is non-empty
- [ ] Last op contains `\n` at the end of its insert value
- [ ] Line attributes (`header`, `list`, etc.) are only on `\n` inserts
- [ ] Embed inserts are objects, not strings
- [ ] JSON string is properly escaped (double-quote within strings)
- [ ] For FormBuilder: value is `jsonEncode(ops)`, not the raw list
