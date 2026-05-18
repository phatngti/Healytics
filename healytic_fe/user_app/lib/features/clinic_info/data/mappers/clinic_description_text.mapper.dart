import 'dart:convert';

/// Converts clinic description payloads into display text.
///
/// The partner admin editor may persist Quill Delta JSON. The user app only
/// needs plain text for the clinic About section.
String? clinicDescriptionToPlainText(Object? raw) {
  if (raw == null) return null;

  final decoded = _decodePossibleJson(raw);
  final deltaText = _deltaToPlainText(decoded);
  if (deltaText != null) return deltaText;

  if (raw is String) return raw;
  return raw.toString();
}

Object? _decodePossibleJson(Object raw) {
  if (raw is! String) return raw;

  final trimmed = raw.trim();
  if (trimmed.isEmpty) return raw;
  if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) return raw;

  try {
    return jsonDecode(trimmed);
  } on FormatException {
    return raw;
  }
}

String? _deltaToPlainText(Object? raw) {
  final Object? opsRaw = raw is Map ? raw['ops'] : raw;
  if (opsRaw is! List) return null;

  var sawDeltaInsert = false;
  final buffer = StringBuffer();

  for (final opRaw in opsRaw) {
    if (opRaw is! Map || !opRaw.containsKey('insert')) continue;

    sawDeltaInsert = true;
    final insert = opRaw['insert'];
    if (insert is String) {
      buffer.write(insert);
    }
  }

  if (!sawDeltaInsert) return null;
  return _removeQuillTerminalNewline(buffer.toString());
}

String _removeQuillTerminalNewline(String value) {
  final normalized = value.replaceAll('\r\n', '\n');
  if (!normalized.endsWith('\n')) return normalized;
  return normalized.substring(0, normalized.length - 1);
}
