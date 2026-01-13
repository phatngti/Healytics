part of 'form_field_builders.dart';

class _AppQuillEditorField extends StatelessWidget {
  final String name;
  final String label;
  final String? initialValue;
  final bool readOnly;
  final double height;
  final TextStyle? labelStyle;
  final bool enabled;

  const _AppQuillEditorField({
    required this.name,
    required this.label,
    this.initialValue,
    this.readOnly = false,
    this.height = 250,
    this.labelStyle,
    this.enabled = true,
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
              initialContent = decoded.cast<Map<String, Object>>();
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
                Text(
                  label,
                  style:
                      labelStyle ??
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 6),
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
                      fontSize: 12,
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
