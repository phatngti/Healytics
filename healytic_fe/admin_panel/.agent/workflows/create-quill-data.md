---
description: create Quill Delta JSON content for rich-text editor fields
---

# /create-quill-data — Build Quill Delta Content

Creates valid Quill Delta JSON for `FormFieldBuilders.buildQuillEditor` fields,
autofill constants, or mock data sources.

## Usage

```
/create-quill-data <target>
```

Example: `/create-quill-data ProductAddAutofill.description`

---

## Steps

1. Read the `quill-data` skill:
   `.agent/skills/quill-data/SKILL.md`

2. Identify the **target location** — one of:
   - Autofill constant (`*_autofill.dart`)
   - Mock data source (`*_mock_data.dart` or inline mock)
   - API payload builder

3. Determine the **content requirements**:
   - What text / headings / lists / embeds are needed?
   - Is this a short description or a full article?
   - Does it need images or links?

4. Build the **Delta ops array** using patterns from the skill:
   ```dart
   [
     {'insert': 'Title'},
     {'insert': '\n', 'attributes': {'header': 1}},
     {'insert': 'Body text.\n'},
   ]
   ```

5. **Encode for the target**:
   - **FormBuilder field** (autofill / form `initialValue`):
     Use a `jsonEncode`-compatible string constant:
     ```dart
     static const description =
         '[{"insert":"Title"},{"insert":"\\n","attributes":{"header":1}}'
         ',{"insert":"Body text.\\n"}]';
     ```
   - **Widget constructor** (`FlutterQuillEditor.initialContent`):
     Use `List<Map<String, Object>>` directly.

6. Insert the content into the target file.

7. **Verify** the content renders correctly:
   - For autofill: navigate to the form with `?autofill=true`
   - For mock data: trigger the mock data source path
   - Confirm formatting (headers, bold, lists) appears in the editor
