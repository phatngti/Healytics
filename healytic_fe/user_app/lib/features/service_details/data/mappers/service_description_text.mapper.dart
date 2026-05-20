import 'dart:convert';

/// Converts service description payloads into readable display text.
///
/// The partner/admin editor can persist rich text as Quill Delta JSON. Service
/// details currently render plain text, so preserve paragraphs and basic lists
/// while stripping editor metadata.
String serviceDescriptionToPlainText(Object? raw) {
  if (raw == null) return '';

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
  final lines = <String>[];
  final currentLine = StringBuffer();

  void flushLine(Object? attributesRaw) {
    final text = currentLine.toString();
    currentLine.clear();

    if (_isBulletList(attributesRaw) && text.trim().isNotEmpty) {
      lines.add('- $text');
    } else {
      lines.add(text);
    }
  }

  for (final opRaw in opsRaw) {
    if (opRaw is! Map || !opRaw.containsKey('insert')) continue;

    final insert = opRaw['insert'];
    if (insert is! String) continue;

    sawDeltaInsert = true;
    final normalized = insert.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    final parts = normalized.split('\n');

    for (var i = 0; i < parts.length; i++) {
      currentLine.write(parts[i]);
      if (i < parts.length - 1) {
        flushLine(opRaw['attributes']);
      }
    }
  }

  if (!sawDeltaInsert) return null;
  if (currentLine.isNotEmpty) {
    lines.add(currentLine.toString());
  }

  while (lines.isNotEmpty && lines.last.isEmpty) {
    lines.removeLast();
  }

  return lines.join('\n');
}

bool _isBulletList(Object? attributesRaw) {
  if (attributesRaw is Map<String, dynamic>) {
    return attributesRaw['list'] == 'bullet';
  }
  if (attributesRaw is Map) {
    return attributesRaw['list'] == 'bullet';
  }
  return false;
}
