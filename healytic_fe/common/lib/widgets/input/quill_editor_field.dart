part of 'form_field_builders.dart';

/// Internal rich-text editor form field used by [FormFieldBuilders.buildQuillEditor].
///
/// Wraps a [FlutterQuillEditor] in a [FormBuilderField] so that Delta-JSON
/// content is stored as a JSON string in the form. Supports initial content
/// deserialization from JSON or plain-text fallback.
class _AppQuillEditorField extends StatelessWidget {
  /// Form field key used by [FormBuilder].
  final String name;

  /// Label text displayed above the editor.
  final String label;

  /// Initial JSON-encoded Delta content string.
  final String? initialValue;

  /// Whether the editor is read-only.
  final bool readOnly;

  /// Height of the editor container in logical pixels.
  final double height;

  /// Custom style for the label text.
  final TextStyle? labelStyle;

  /// Whether the field is enabled (reduces opacity when disabled).
  final bool enabled;

  /// Whether the field is required (shows asterisk).
  final bool isRequired;

  /// Creates an [_AppQuillEditorField].
  const _AppQuillEditorField({
    required this.name,
    required this.label,
    this.initialValue,
    this.readOnly = false,
    this.height = 250,
    this.labelStyle,
    this.enabled = true,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: name,
      initialValue: initialValue,
      enabled: enabled,
      builder: (field) {
        List<Map<String, Object>>? initialContent;
        if (field.value != null && field.value!.isNotEmpty) {
          try {
            final decoded = jsonDecode(field.value!);
            if (decoded is List) {
              initialContent = decoded
                  .map((e) => Map<String, Object>.from(e as Map))
                  .toList();
            }
          } catch (e) {
            // Fallback for plain text
            initialContent = [
              {'insert': '${field.value}\n'},
            ];
          }
        }

        final isReadOnly = readOnly || !field.widget.enabled;

        return Opacity(
          opacity: field.widget.enabled ? 1.0 : 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label.isNotEmpty) ...[
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: label,
                        style:
                            labelStyle ??
                            Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      if (isRequired)
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                AppDimens.verticalExtraSmall,
              ],
              FlutterQuillEditor(
                initialContent: initialContent,
                readOnly: isReadOnly,
                onChanged: (value) {
                  if (!isReadOnly) {
                    field.didChange(jsonEncode(value));
                  }
                },
                height: height,
                width: double.infinity,
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    field.errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: AppDimens.fontSizeSmall,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
