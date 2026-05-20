#!/usr/bin/env node

/**
 * Generate typed Dart Socket.IO client code from ws-contract.json.
 *
 * Generates three files:
 *   1. ws_events.dart       — Event name constants
 *   2. ws_models.dart       — Typed payload classes with fromJson / toJson
 *   3. ws_client.dart       — Typed Socket.IO wrapper per namespace
 *
 * Usage:
 *   node bin/generate-ws-client.js [--spec PATH] [--output DIR]
 *
 * Defaults:
 *   --spec   ../ws-contract.json  (relative to this script)
 *   --output ../user_app/lib/core/services/ws
 */

const fs = require('fs');
const path = require('path');

// ── CLI args ──────────────────────────────────────────────────

const args = process.argv.slice(2);
function getArg(name, defaultVal) {
  const idx = args.indexOf(name);
  return idx !== -1 && args[idx + 1] ? args[idx + 1] : defaultVal;
}

const SCRIPT_DIR = __dirname;
const BASE_DIR = path.resolve(SCRIPT_DIR, '..');
const specPath = path.resolve(BASE_DIR, getArg('--spec', 'ws-contract.json'));
const outputDir = path.resolve(
  BASE_DIR,
  getArg('--output', '../user_app/lib/core/services/ws'),
);
const namespacesArg = getArg('--namespaces', '');

// ── Helpers ───────────────────────────────────────────────────

const HEADER = `// =============================================================
// AUTO-GENERATED from ws-contract.json — DO NOT EDIT BY HAND.
//
// Re-generate with:
//   ./bin/generate-integration.sh ws
// =============================================================

// ignore_for_file: type=lint
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: unused_element

`;

/** event/path-like names → camelCase Dart identifier */
function snakeToCamel(s) {
  const parts = String(s).split(/[^a-zA-Z0-9]+/).filter(Boolean);
  if (parts.length === 0) return 'event';

  const normalizePart = (part) =>
    part === part.toUpperCase() ? part.toLowerCase() : part;
  const normalized = parts.map(normalizePart);
  const first = normalized[0].charAt(0).toLowerCase() + normalized[0].slice(1);
  const rest = normalized
    .slice(1)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1));
  const identifier = [first, ...rest].join('');
  return /^[0-9]/.test(identifier) ? `event${identifier}` : identifier;
}

/** Derive the Dart event-constants class name for a namespace.
 *  e.g. 'user-chat' → 'WsChatEvent',
 *       'notifications' → 'WsNotificationEvent',
 *       'chat-notifications' → 'WsChatNotificationsEvent' */
function eventClassName(nsName) {
  // Special-case: drop leading 'user-'/'partner-' prefix for chat namespaces
  // so both user-chat and partner-chat share WsChatEvent.
  const stripped = nsName.replace(/^(user|partner)-/, '');
  return `Ws${snakeToPascal(stripped)}Event`;
}

/** snake_case / kebab-case → PascalCase */
function snakeToPascal(s) {
  const camel = snakeToCamel(s);
  return camel.charAt(0).toUpperCase() + camel.slice(1);
}

/** camelCase → snake_case */
function camelToSnake(s) {
  return s.replace(/[A-Z]/g, (c) => '_' + c.toLowerCase());
}

/** Escape a string for a single-quoted Dart literal */
function escapeDartString(value) {
  return String(value).replace(/\\/g, '\\\\').replace(/'/g, "\\'");
}

function isNullable(prop) {
  return prop.required === false || prop.nullable === true;
}

function isMapLikeType(type) {
  return [
    'Map',
    'Map<String, dynamic>',
    'Map<String,dynamic>',
    'Map<String, Object?>',
    'Map<String,Object?>',
    'Record<string, any>',
    'Record<String, dynamic>',
    'Record<String,dynamic>',
    'object',
  ].includes(type);
}

function isDynamicType(type) {
  return type === 'dynamic' || type === 'Object';
}

function isListType(type) {
  return /^List<.+>$/.test(type) || type === 'List';
}

function getListItemType(type) {
  const match = /^List<(.+)>$/.exec(type);
  return match ? match[1].trim() : 'dynamic';
}

function normalizeType(type) {
  if (isMapLikeType(type)) return 'Map<String, dynamic>';
  if (isListType(type)) {
    return `List<${normalizeType(getListItemType(type))}>`;
  }
  return type;
}

/** Dart type for a contract property */
function dartType(prop) {
  if (prop.isEnum) return prop.type;
  return normalizeType(prop.type);
}

/** Nullable suffix */
function nullable(prop) {
  return isNullable(prop) ? '?' : '';
}

function enumHelperName(enumName, suffix) {
  return `${enumName.charAt(0).toLowerCase() + enumName.slice(1)}${suffix}`;
}

function dartDefaultValue(prop) {
  if (prop.default === undefined) return null;
  if (prop.isEnum) {
    return `${prop.type}.${snakeToCamel(prop.default)}`;
  }
  if (prop.type === 'String') {
    return `'${escapeDartString(prop.default)}'`;
  }
  if (['bool', 'num', 'int', 'double'].includes(prop.type)) {
    return String(prop.default);
  }
  return `'${escapeDartString(prop.default)}'`;
}

// ── Load contract ─────────────────────────────────────────────

if (!fs.existsSync(specPath)) {
  console.error(`Contract file not found: ${specPath}`);
  process.exit(1);
}

const contract = JSON.parse(fs.readFileSync(specPath, 'utf8'));

// ── Resolve `extends` before filtering ─────────────────────
// Inline parent events into child namespaces so they remain
// self-contained after filtering.
for (const [, ns] of Object.entries(contract.namespaces)) {
  if (ns.extends && contract.namespaces[ns.extends]) {
    const parent = contract.namespaces[ns.extends];
    ns.clientToServer = {
      ...(parent.clientToServer || {}),
      ...(ns.clientToServer || {}),
    };
    ns.serverToClient = {
      ...(parent.serverToClient || {}),
      ...(ns.serverToClient || {}),
    };
    delete ns.extends;
  }
}

// ── Optional namespace filter ──────────────────────────────
if (namespacesArg) {
  const allowed = new Set(
    namespacesArg.split(',').map((s) => s.trim()),
  );
  for (const ns of Object.keys(contract.namespaces)) {
    if (!allowed.has(ns)) delete contract.namespaces[ns];
  }
}

fs.mkdirSync(outputDir, { recursive: true });

console.log(`\n🔌  WebSocket Client Generator`);
console.log(`   Spec:   ${specPath}`);
console.log(`   Output: ${outputDir}`);
if (namespacesArg) {
  console.log(`   Filter: ${namespacesArg}`);
}
console.log('');

// ── Collect all unique events across namespaces ───────────────

function collectEvents(contract) {
  const clientToServer = new Map(); // eventName → { description, payload, ack? }
  const serverToClient = new Map();

  for (const [nsName, ns] of Object.entries(contract.namespaces)) {
    const source = ns.extends
      ? contract.namespaces[ns.extends]
      : ns;

    for (const [event, meta] of Object.entries(source.clientToServer || {})) {
      if (!clientToServer.has(event)) clientToServer.set(event, meta);
    }
    for (const [event, meta] of Object.entries(source.serverToClient || {})) {
      if (!serverToClient.has(event)) serverToClient.set(event, meta);
    }
  }

  return { clientToServer, serverToClient };
}

const { clientToServer, serverToClient } = collectEvents(contract);

function isModelType(type) {
  return !!contract.models?.[normalizeType(type)];
}

function isEnumType(type) {
  return !!contract.enums?.[normalizeType(type)];
}

function collectReferencedTypes(contract) {
  const referencedModels = new Set();
  const referencedEnums = new Set();

  function visitType(type) {
    const normalized = normalizeType(type);

    if (isListType(normalized)) {
      visitType(getListItemType(normalized));
      return;
    }

    if (contract.enums?.[normalized]) {
      referencedEnums.add(normalized);
      return;
    }

    if (contract.models?.[normalized]) {
      visitModel(normalized);
    }
  }

  function visitModel(modelName) {
    if (referencedModels.has(modelName)) return;
    const model = contract.models?.[modelName];
    if (!model) return;

    referencedModels.add(modelName);
    for (const prop of Object.values(model.properties || {})) {
      if (prop.isEnum) {
        referencedEnums.add(prop.type);
        continue;
      }
      visitType(prop.type);
    }
  }

  for (const ns of Object.values(contract.namespaces)) {
    for (const meta of Object.values(ns.clientToServer || {})) {
      visitType(meta.payload);
      if (meta.ack) visitType(meta.ack);
    }
    for (const meta of Object.values(ns.serverToClient || {})) {
      visitType(meta.payload);
      if (meta.ack) visitType(meta.ack);
    }
  }

  return { referencedModels, referencedEnums };
}

const { referencedModels, referencedEnums } = collectReferencedTypes(contract);

function fromJsonItemExpression(type, valueExpr, context) {
  const normalized = normalizeType(type);

  if (isEnumType(normalized)) {
    return `${enumHelperName(normalized, 'FromJson')}(${valueExpr})`;
  }
  if (normalized === 'DateTime') {
    return `_requireDateTime(${valueExpr}, '${context}')`;
  }
  if (normalized === 'int') {
    return `(${valueExpr} as num).toInt()`;
  }
  if (normalized === 'double') {
    return `(${valueExpr} as num).toDouble()`;
  }
  if (['String', 'bool', 'num'].includes(normalized)) {
    return `${valueExpr} as ${normalized}`;
  }
  if (isDynamicType(normalized)) {
    return valueExpr;
  }
  if (isMapLikeType(normalized)) {
    return `_requireJsonMap(${valueExpr}, '${context}')`;
  }
  if (isListType(normalized)) {
    const itemType = normalizeType(getListItemType(normalized));
    const itemExpr = fromJsonItemExpression(itemType, 'item', `${context}[]`);
    return `_requireJsonList<${itemType}>(${valueExpr}, '${context}', (item) => ${itemExpr})`;
  }
  if (isModelType(normalized)) {
    return `${normalized}.fromJson(_requireJsonMap(${valueExpr}, '${context}'))`;
  }
  return `${valueExpr} as ${normalized}`;
}

function fromJsonExpression(prop, valueExpr, context) {
  const normalized = dartType(prop);

  if (isNullable(prop)) {
    if (normalized === 'DateTime') {
      return `_dateTimeOrNull(${valueExpr}, '${context}')`;
    }
    if (normalized === 'int') {
      return `${valueExpr} != null ? (${valueExpr} as num).toInt() : null`;
    }
    if (normalized === 'double') {
      return `${valueExpr} != null ? (${valueExpr} as num).toDouble() : null`;
    }
    if (isEnumType(normalized)) {
      return `${valueExpr} != null ? ${enumHelperName(normalized, 'FromJson')}(${valueExpr}) : null`;
    }
    if (isMapLikeType(normalized)) {
      return `_jsonMapOrNull(${valueExpr}, '${context}')`;
    }
    if (isListType(normalized)) {
      const itemType = normalizeType(getListItemType(normalized));
      const itemExpr = fromJsonItemExpression(itemType, 'item', `${context}[]`);
      return `_jsonListOrNull<${itemType}>(${valueExpr}, '${context}', (item) => ${itemExpr})`;
    }
    if (isModelType(normalized)) {
      return `${valueExpr} != null ? ${normalized}.fromJson(_requireJsonMap(${valueExpr}, '${context}')) : null`;
    }
    return `${valueExpr} as ${normalized}?`;
  }

  return fromJsonItemExpression(normalized, valueExpr, context);
}

function toJsonItemExpression(type, valueExpr) {
  const normalized = normalizeType(type);

  if (isEnumType(normalized)) {
    return `${enumHelperName(normalized, 'ToJson')}(${valueExpr})`;
  }
  if (normalized === 'DateTime') {
    return `${valueExpr}.toUtc().toIso8601String()`;
  }
  if (isListType(normalized)) {
    const itemType = normalizeType(getListItemType(normalized));
    const itemExpr = toJsonItemExpression(itemType, 'item');
    return `${valueExpr}.map((item) => ${itemExpr}).toList(growable: false)`;
  }
  if (isModelType(normalized)) {
    return `${valueExpr}.toJson()`;
  }
  return valueExpr;
}

function toJsonExpression(prop, valueExpr) {
  return toJsonItemExpression(dartType(prop), valueExpr);
}

// ═════════════════════════════════════════════════════════════
// 1. ws_events.dart
// ═════════════════════════════════════════════════════════════

function generateEvents() {
  let out = HEADER;

  // Deduplicate: namespaces that share the same event class
  // (e.g. user-chat and partner-chat both map to WsChatEvent)
  // are merged so we only emit one class.
  const classBuckets = new Map(); // className → { c2s, s2c }

  for (const [nsName, ns] of Object.entries(contract.namespaces)) {
    const source = ns.extends
      ? contract.namespaces[ns.extends]
      : ns;
    const clsName = eventClassName(nsName);

    if (!classBuckets.has(clsName)) {
      classBuckets.set(clsName, {
        c2s: new Map(),
        s2c: new Map(),
      });
    }
    const bucket = classBuckets.get(clsName);
    for (const [ev, meta] of Object.entries(source.clientToServer || {})) {
      if (!bucket.c2s.has(ev)) bucket.c2s.set(ev, meta);
    }
    for (const [ev, meta] of Object.entries(source.serverToClient || {})) {
      if (!bucket.s2c.has(ev)) bucket.s2c.set(ev, meta);
    }
  }

  for (const [clsName, { c2s, s2c }] of classBuckets) {
    out += `/// WebSocket event constants for the ${clsName} namespace(s).\n`;
    out += '///\n';
    out += '/// Client → Server events are used with `socket.emit()`.\n';
    out += '/// Server → Client events are used with `socket.on()`.\n';
    out += `abstract final class ${clsName} {\n`;
    out += `  ${clsName}._();\n\n`;

    if (c2s.size > 0) {
      out += '  // ── Client → Server ────────────────────────────────\n';
      for (const [event, meta] of c2s) {
        out += `\n  /// ${meta.description}\n`;
        out += `  static const ${snakeToCamel(event)} = '${event}';\n`;
      }
      out += '\n';
    }

    out += '  // ── Server → Client ────────────────────────────────\n';
    for (const [event, meta] of s2c) {
      // Skip duplicates that already appeared in c2s
      if (c2s.has(event)) continue;
      out += `\n  /// ${meta.description}\n`;
      out += `  static const ${snakeToCamel(event)} = '${event}';\n`;
    }

    out += '}\n\n';
  }

  return out;
}

const eventsCode = generateEvents();
fs.writeFileSync(path.join(outputDir, 'ws_events.dart'), eventsCode);
console.log('  ✓ ws_events.dart');

// ═════════════════════════════════════════════════════════════
// 2. ws_models.dart
// ═════════════════════════════════════════════════════════════

function generateModels() {
  let out = HEADER;

  out += 'Map<String, dynamic> _requireJsonMap(dynamic value, String context) {\n';
  out += '  if (value is Map<String, dynamic>) return value;\n';
  out += '  if (value is Map) {\n';
  out += '    return Map<String, dynamic>.from(value);\n';
  out += '  }\n';
  out += "  throw FormatException('Expected JSON object for \$context, got \${value.runtimeType}');\n";
  out += '}\n\n';

  out += 'Map<String, dynamic>? _jsonMapOrNull(dynamic value, String context) {\n';
  out += '  if (value == null) return null;\n';
  out += '  return _requireJsonMap(value, context);\n';
  out += '}\n\n';

  out += 'DateTime _requireDateTime(dynamic value, String context) {\n';
  out += '  if (value is DateTime) return value;\n';
  out += '  if (value is String) return DateTime.parse(value);\n';
  out += "  throw FormatException('Expected DateTime string for \$context, got \${value.runtimeType}');\n";
  out += '}\n\n';

  out += 'DateTime? _dateTimeOrNull(dynamic value, String context) {\n';
  out += '  if (value == null) return null;\n';
  out += '  return _requireDateTime(value, context);\n';
  out += '}\n\n';

  out += 'List<T> _requireJsonList<T>(\n';
  out += '  dynamic value,\n';
  out += '  String context,\n';
  out += '  T Function(dynamic item) convert,\n';
  out += ') {\n';
  out += '  if (value is! List) {\n';
  out += "    throw FormatException('Expected JSON list for \$context, got \${value.runtimeType}');\n";
  out += '  }\n';
  out += '  return value.map(convert).toList(growable: false);\n';
  out += '}\n\n';

  out += 'List<T>? _jsonListOrNull<T>(\n';
  out += '  dynamic value,\n';
  out += '  String context,\n';
  out += '  T Function(dynamic item) convert,\n';
  out += ') {\n';
  out += '  if (value == null) return null;\n';
  out += '  return _requireJsonList(value, context, convert);\n';
  out += '}\n\n';

  // ── Enums ──────────────────────────────────────────────
  for (const [enumName, enumDef] of Object.entries(contract.enums || {})) {
    if (!referencedEnums.has(enumName)) continue;

    out += `/// ${enumDef.description}\n`;
    out += `enum ${enumName} {\n`;
    for (const val of enumDef.values) {
      out += `  ${snakeToCamel(val)},\n`;
    }
    out += '}\n\n';

    // Helper: parse from string
    out += `${enumName} ${enumHelperName(enumName, 'FromJson')}(dynamic value) {\n`;
    out += `  if (value == null) return ${enumName}.${snakeToCamel(enumDef.values[0])};\n`;
    out += `  final str = value.toString();\n`;
    out += `  switch (str) {\n`;
    for (const val of enumDef.values) {
      out += `    case '${val}':\n`;
      out += `      return ${enumName}.${snakeToCamel(val)};\n`;
    }
    out += `    default:\n`;
    out += `      return ${enumName}.${snakeToCamel(enumDef.values[0])};\n`;
    out += `  }\n`;
    out += '}\n\n';

    // Helper: to string
    out += `String ${enumHelperName(enumName, 'ToJson')}(${enumName} value) {\n`;
    out += `  switch (value) {\n`;
    for (const val of enumDef.values) {
      out += `    case ${enumName}.${snakeToCamel(val)}:\n`;
      out += `      return '${val}';\n`;
    }
    out += `  }\n`;
    out += `}\n\n`;
  }

  // ── Models ─────────────────────────────────────────────
  for (const [modelName, modelDef] of Object.entries(contract.models || {})) {
    if (!referencedModels.has(modelName)) continue;

    const props = Object.entries(modelDef.properties || {});

    out += `/// ${modelDef.description}\n`;
    out += `class ${modelName} {\n`;

    // Fields
    for (const [propName, prop] of props) {
      out += `  /// ${prop.description}\n`;
      out += `  final ${dartType(prop)}${nullable(prop)} ${propName};\n\n`;
    }

    // Constructor
    out += `  const ${modelName}({\n`;
    for (const [propName, prop] of props) {
      if (prop.required) {
        out += `    required this.${propName},\n`;
      } else if (prop.default !== undefined) {
        const defaultVal = dartDefaultValue(prop);
        out += `    this.${propName} = ${defaultVal},\n`;
      } else {
        out += `    this.${propName},\n`;
      }
    }
    out += '  });\n\n';

    out += `  /// Deserialize from a Socket.IO JSON map.\n`;
    out += `  factory ${modelName}.fromJson(Map<String, dynamic> json) {\n`;
    out += `    return ${modelName}(\n`;
    for (const [propName, prop] of props) {
      out += `      ${propName}: ${fromJsonExpression(prop, `json['${propName}']`, `${modelName}.${propName}`)},\n`;
    }
    out += '    );\n';
    out += '  }\n\n';

    out += `  /// Serialize to a JSON map.\n`;
    out += `  Map<String, dynamic> toJson() {\n`;
    out += `    return <String, dynamic>{\n`;
    for (const [propName, prop] of props) {
      if (isNullable(prop)) {
        out += `      if (${propName} != null) '${propName}': ${toJsonExpression(prop, `${propName}!`)},\n`;
      } else {
        out += `      '${propName}': ${toJsonExpression(prop, propName)},\n`;
      }
    }
    out += '    };\n';
    out += '  }\n\n';

    // toString
    out += `  @override\n`;
    out += `  String toString() {\n`;
    const toStringFields = props
      .map(([name]) => `${name}: $${name}`)
      .join(', ');
    out += `    return '${modelName}(${toStringFields})';\n`;
    out += '  }\n';

    out += '}\n\n';
  }

  return out;
}

const modelsCode = generateModels();
fs.writeFileSync(path.join(outputDir, 'ws_models.dart'), modelsCode);
console.log('  ✓ ws_models.dart');

// ═════════════════════════════════════════════════════════════
// 3. ws_client.dart  (one typed wrapper per namespace)
// ═════════════════════════════════════════════════════════════

function generateClients() {
  let out = HEADER;
  out += "import 'dart:async';\n\n";
  out += "import 'package:logging/logging.dart';\n";
  out += "import 'package:socket_io_client/socket_io_client.dart' as io;\n\n";
  out += "import 'ws_events.dart';\n";
  out += "import 'ws_models.dart';\n";
  out += "\n";
  out += "export 'ws_events.dart';\n";
  out += "export 'ws_models.dart';\n\n";

  out += 'Map<String, dynamic> _requireEventMap(dynamic value, String context) {\n';
  out += '  if (value is Map<String, dynamic>) return value;\n';
  out += '  if (value is Map) {\n';
  out += '    return Map<String, dynamic>.from(value);\n';
  out += '  }\n';
  out += "  throw FormatException('Expected JSON object for \$context, got \${value.runtimeType}');\n";
  out += '}\n\n';

  // ── Socket.IO logger silencer ────────────────────────
  out += '/// Suppresses verbose internal loggers from\n';
  out += '/// `socket_io_client` (Manager, engine, parser)\n';
  out += '/// so ping/pong, packet-encoding, and JWT dumps\n';
  out += '/// never flood the console.\n';
  out += 'bool _socketIoLoggersSilenced = false;\n';
  out += 'void _silenceSocketIoLoggers() {\n';
  out += '  if (_socketIoLoggersSilenced) return;\n';
  out += '  _socketIoLoggersSilenced = true;\n';
  out += '  hierarchicalLoggingEnabled = true;\n';
  out += "  for (final name in [\n";
  out += "    'socket_io_client:Manager',\n";
  out += "    'socket_io_client:engine.Socket',\n";
  out += "    'socket_io:parser.Encoder',\n";
  out += "    'socket_io:parser.Decoder',\n";
  out += '  ]) {\n';
  out += '    Logger(name).level = Level.WARNING;\n';
  out += '  }\n';
  out += '}\n\n';

  // ── WsServerConfig typedef ───────────────────────────
  out += '/// Server config for a WebSocket namespace.\n';
  out += '///\n';
  out += '/// [url]  — base server URL\n';
  out += '///          (e.g. `https://healytics.me`)\n';
  out += '/// [path] — Socket.IO transport path\n';
  out += '///          (e.g. `/user-chat/socket.io/`)\n';
  out += 'typedef WsServerConfig = ({String url, String path});\n\n';

  // ── Connection status enum ────────────────────────────
  out += '/// WebSocket connection lifecycle states.\n';
  out += 'enum WsConnectionStatus {\n';
  out += '  disconnected,\n';
  out += '  connecting,\n';
  out += '  connected,\n';
  out += '  reconnecting,\n';
  out += '  error,\n';
  out += '}\n\n';

  // ── WsNamespaceSocket interface ───────────────────────
  out += '/// Common interface for all generated namespace\n';
  out += '/// socket clients.\n';
  out += '///\n';
  out += '/// Allows [WsService] to manage sockets without\n';
  out += '/// `dynamic` or per-type branching.\n';
  out += 'abstract interface class WsNamespaceSocket {\n';
  out += '  /// Current connection status.\n';
  out += '  WsConnectionStatus get status;\n\n';
  out += '  /// Stream of connection state changes.\n';
  out += '  Stream<WsConnectionStatus> get onConnectionChange;\n\n';
  out += '  /// Connect to the WebSocket server.\n';
  out += '  ///\n';
  out += '  /// [server] provides the URL and Socket.IO\n';
  out += '  /// transport path.\n';
  out += '  /// [token] is the JWT access token.\n';
  out += '  void connect({\n';
  out += '    required WsServerConfig server,\n';
  out += '    required String token,\n';
  out += '  });\n\n';
  out += '  /// Disconnect from the WebSocket server.\n';
  out += '  void disconnect();\n\n';
  out += '  /// Clean up all resources permanently.\n';
  out += '  void dispose();\n';
  out += '}\n\n';

  // ── Generate one class per namespace ──────────────────
  for (const [nsName, ns] of Object.entries(contract.namespaces)) {
    const source = ns.extends ? contract.namespaces[ns.extends] : ns;
    const className = snakeToPascal(nsName) + 'Socket';
    const loggerName = className;
    const serverEvents = Object.entries(source.serverToClient || {});
    const clientEvents = Object.entries(source.clientToServer || {});

    out += `/// Typed Socket.IO client for the \`/${nsName}\` namespace.\n`;
    out += `///\n`;
    out += `/// ${ns.description}\n`;
    out += `///\n`;
    out += `/// **Auth:** ${ns.auth.type.toUpperCase()} — roles: ${ns.auth.roles.join(', ')}\n`;
    out += `///\n`;
    out += '/// Usage:\n';
    out += '/// ' + '```' + 'dart\n';
    out += '/// final socket = ' + className + '();\n';
    out += '/// socket.connect(\n';
    out += `///   server: (url: gateway, path: '/${nsName}/socket.io/'),\n`;
    out += '///   token: token,\n';
    out += '/// );\n';
    if (serverEvents[0]) {
      out += `/// socket.on${snakeToPascal(serverEvents[0][0])}.listen((event) => print(event));\n`;
    }
    if (clientEvents[0]) {
      const methodName = snakeToCamel(clientEvents[0][0]);
      const payloadType = clientEvents[0][1].payload;
      const payloadDef = contract.models[payloadType];
      const propEntries = Object.entries(payloadDef?.properties || {});
      const isSimple =
        propEntries.length === 1 && propEntries[0][0] === 'conversationId';
      if (isSimple) {
        out += `/// socket.${methodName}('conversation-id');\n`;
      } else {
        out += `/// socket.${methodName}(${payloadType}(...));\n`;
      }
    }
    out += '/// ' + '```' + '\n';
    out += `class ${className} implements WsNamespaceSocket {\n`;
    out += `  static final _log = Logger('${loggerName}');\n\n`;
    out += `  io.Socket? _socket;\n\n`;

    // ── Stream controllers ──────────────────────────────
    for (const [event, meta] of serverEvents) {
      const camel = snakeToCamel(event);
      const payloadType = meta.payload;
      out += `  final _${camel}Controller =\n`;
      out += `      StreamController<${payloadType}>.broadcast();\n`;
    }
    out += `  final _connectionController =\n`;
    out += `      StreamController<WsConnectionStatus>.broadcast();\n\n`;

    // ── Public streams ──────────────────────────────────
    for (const [event, meta] of serverEvents) {
      const camel = snakeToCamel(event);
      const pascal = snakeToPascal(event);
      const payloadType = meta.payload;
      out += `  /// ${meta.description}\n`;
      out += `  Stream<${payloadType}> get on${pascal} =>\n`;
      out += `      _${camel}Controller.stream;\n\n`;
    }
    out += `  /// Stream of connection state changes.\n`;
    out += `  @override\n`;
    out += `  Stream<WsConnectionStatus> get onConnectionChange =>\n`;
    out += `      _connectionController.stream;\n\n`;

    // ── Status ──────────────────────────────────────────
    out += `  /// Current connection status.\n`;
    out += `  WsConnectionStatus _status = WsConnectionStatus.disconnected;\n`;
    out += `  @override\n`;
    out += `  WsConnectionStatus get status => _status;\n\n`;

    // ── connect() ───────────────────────────────────────
    out += `  /// Connect to the \`/${nsName}\` WebSocket namespace.\n`;
    out += `  ///\n`;
    out += `  /// [server] provides the base URL and Socket.IO\n`;
    out += `  /// transport path.\n`;
    out += `  /// [token] is the JWT access token.\n`;
    out += `  @override\n`;
    out += `  void connect({\n`;
    out += `    required WsServerConfig server,\n`;
    out += `    required String token,\n`;
    out += `  }) {\n`;
    out += `    _silenceSocketIoLoggers();\n\n`;
    out += `    if (_socket != null) {\n`;
    out += `      _log.info('Already connected, disconnecting first');\n`;
    out += `      disconnect();\n`;
    out += `    }\n\n`;
    out += `    _updateStatus(WsConnectionStatus.connecting);\n\n`;
    out += `    _socket = io.io(\n`;
    out += `      server.url,\n`;
    out += `      io.OptionBuilder()\n`;
    out += `          .setTransports(['websocket'])\n`;
    out += `          .disableAutoConnect()\n`;
    out += `          .enableReconnection()\n`;
    out += `          .setReconnectionAttempts(5)\n`;
    out += `          .setReconnectionDelay(1000)\n`;
    out += `          .setReconnectionDelayMax(10000)\n`;
    out += `          .setTimeout(10000)\n`;
    out += `          .setPath(server.path)\n`;
    out += `          .setAuth({'token': token})\n`;
    out += `          .build(),\n`;
    out += `    );\n\n`;

    // Lifecycle handlers
    out += `    _socket!.onConnect((_) {\n`;
    out += `      _log.info('Connected to /${nsName}');\n`;
    out += `      _updateStatus(WsConnectionStatus.connected);\n`;
    out += `    });\n\n`;
    out += `    _socket!.onDisconnect((_) {\n`;
    out += `      _log.info('Disconnected from /${nsName}');\n`;
    out += `      _updateStatus(WsConnectionStatus.disconnected);\n`;
    out += `    });\n\n`;
    out += `    _socket!.on('reconnecting', (_) {\n`;
    out += `      _log.info('Reconnecting to /${nsName}');\n`;
    out += `      _updateStatus(WsConnectionStatus.reconnecting);\n`;
    out += `    });\n\n`;
    out += `    _socket!.onConnectError((err) {\n`;
    out += `      _log.warning('Connection error: \$err');\n`;
    out += `      _updateStatus(WsConnectionStatus.error);\n`;
    out += `    });\n\n`;
    out += `    _socket!.onError((err) {\n`;
    out += `      _log.warning('Socket error: \$err');\n`;
    out += `    });\n\n`;

    // Server → Client event listeners
    out += `    // ── Server → Client event listeners ─────────────\n\n`;
    for (const [event, meta] of serverEvents) {
      const camel = snakeToCamel(event);
      const payloadType = meta.payload;
      out += `    _socket!.on(${eventClassName(nsName)}.${camel}, (data) {\n`;
      out += `      try {\n`;
      out += `        final map = _requireEventMap(data, '${nsName}.${event}');\n`;
      out += `        _${camel}Controller.add(${payloadType}.fromJson(map));\n`;
      out += `      } catch (e, st) {\n`;
      out += `        _log.severe('Error parsing ${event}', e, st);\n`;
      out += `      }\n`;
      out += `    });\n\n`;
    }

    out += `    _socket!.connect();\n`;
    out += `  }\n\n`;

    // ── Client → Server emitters ────────────────────────
    out += `  // ── Client → Server emitters ──────────────────────\n\n`;

    for (const [event, meta] of Object.entries(source.clientToServer || {})) {
      const camel = snakeToCamel(event);
      const payloadType = meta.payload;
      const payloadDef = contract.models[payloadType];
      const hasAck = !!meta.ack;
      const ackType = meta.ack;

      // Decide parameter style: if the payload has only conversationId, use a simple String param
      const propEntries = Object.entries(payloadDef.properties || {});
      const isSimple =
        propEntries.length === 1 && propEntries[0][0] === 'conversationId';

      out += `  /// ${meta.description}\n`;

      if (isSimple) {
        // Simple variant: just pass conversationId
        if (hasAck) {
          out += `  void ${camel}(\n`;
          out += `    String conversationId, {\n`;
          out += `    void Function(${ackType})? onAck,\n`;
          out += `  }) {\n`;
          out += `    _socket?.emitWithAck(\n`;
          out += `      ${eventClassName(nsName)}.${camel},\n`;
          out += `      {'conversationId': conversationId},\n`;
          out += `      ack: (response) {\n`;
          out += `        if (onAck != null && response is Map<dynamic, dynamic>) {\n`;
          out += `          onAck(${ackType}.fromJson(\n`;
          out += `            Map<String, dynamic>.from(response),\n`;
          out += `          ));\n`;
          out += `        }\n`;
          out += `      },\n`;
          out += `    );\n`;
          out += `  }\n\n`;
        } else {
          out += `  void ${camel}(String conversationId) {\n`;
          out += `    _socket?.emit(${eventClassName(nsName)}.${camel}, {\n`;
          out += `      'conversationId': conversationId,\n`;
          out += `    });\n`;
          out += `  }\n\n`;
        }
      } else {
        // Full payload variant
        if (hasAck) {
          out += `  void ${camel}(\n`;
          out += `    ${payloadType} payload, {\n`;
          out += `    void Function(${ackType})? onAck,\n`;
          out += `  }) {\n`;
          out += `    _socket?.emitWithAck(\n`;
          out += `      ${eventClassName(nsName)}.${camel},\n`;
          out += `      payload.toJson(),\n`;
          out += `      ack: (response) {\n`;
          out += `        if (onAck != null && response is Map<dynamic, dynamic>) {\n`;
          out += `          onAck(${ackType}.fromJson(\n`;
          out += `            Map<String, dynamic>.from(response),\n`;
          out += `          ));\n`;
          out += `        }\n`;
          out += `      },\n`;
          out += `    );\n`;
          out += `  }\n\n`;
        } else {
          out += `  void ${camel}(${payloadType} payload) {\n`;
          out += `    _socket?.emit(${eventClassName(nsName)}.${camel}, payload.toJson());\n`;
          out += `  }\n\n`;
        }
      }
    }

    // ── disconnect / dispose ────────────────────────────
    out += `  /// Disconnect from the WebSocket server.\n`;
    out += `  @override\n`;
    out += `  void disconnect() {\n`;
    out += `    _socket?.disconnect();\n`;
    out += `    _socket?.dispose();\n`;
    out += `    _socket = null;\n`;
    out += `    _updateStatus(WsConnectionStatus.disconnected);\n`;
    out += `  }\n\n`;

    out += `  /// Clean up all resources. Call when the service\n`;
    out += `  /// is permanently disposed.\n`;
    out += `  @override\n`;
    out += `  void dispose() {\n`;
    out += `    disconnect();\n`;
    for (const [event] of serverEvents) {
      out += `    _${snakeToCamel(event)}Controller.close();\n`;
    }
    out += `    _connectionController.close();\n`;
    out += `  }\n\n`;

    out += `  void _updateStatus(WsConnectionStatus newStatus) {\n`;
    out += `    _status = newStatus;\n`;
    out += `    _connectionController.add(newStatus);\n`;
    out += `  }\n`;

    out += '}\n\n';
  }

  return out;
}

const clientsCode = generateClients();
fs.writeFileSync(path.join(outputDir, 'ws_client.dart'), clientsCode);
console.log('  ✓ ws_client.dart');

// ═════════════════════════════════════════════════════════════
// Summary
// ═════════════════════════════════════════════════════════════

const allEvents = new Set([
  ...clientToServer.keys(),
  ...serverToClient.keys(),
]);
const modelCount = referencedModels.size;
const enumCount = referencedEnums.size;
const nsCount = Object.keys(contract.namespaces).length;

console.log('');
console.log('📦  Generation complete!');
console.log(`   ${allEvents.size} events, ${modelCount} models, ${enumCount} enums, ${nsCount} namespaces`);
console.log(`   Output: ${outputDir}`);
console.log('');
