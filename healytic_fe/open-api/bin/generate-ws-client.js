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
 *   --output ../user_app/ws/
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
  getArg('--output', '../user_app/ws'),
);
const namespacesArg = getArg('--namespaces', '');

// ── Helpers ───────────────────────────────────────────────────

const HEADER = `// =============================================================
// AUTO-GENERATED from ws-contract.json — DO NOT EDIT BY HAND.
//
// Re-generate with:
//   ./bin/generate-open-api.sh ws
// =============================================================

// ignore_for_file: lines_longer_than_80_chars

`;

/** snake_case / kebab-case → camelCase */
function snakeToCamel(s) {
  return s.replace(/[-_]([a-z])/g, (_, c) => c.toUpperCase());
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

/** Dart type for a contract property */
function dartType(prop) {
  if (prop.isEnum) return prop.type;
  switch (prop.type) {
    case 'DateTime':
      return 'DateTime';
    default:
      return prop.type;
  }
}

/** Nullable suffix */
function nullable(prop) {
  return prop.required ? '' : '?';
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
    if (!ns.clientToServer) {
      ns.clientToServer = { ...parent.clientToServer };
    }
    if (!ns.serverToClient) {
      ns.serverToClient = { ...parent.serverToClient };
    }
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

// ═════════════════════════════════════════════════════════════
// 1. ws_events.dart
// ═════════════════════════════════════════════════════════════

function generateEvents() {
  let out = HEADER;
  out += "/// WebSocket event constants matching the backend's ChatEvent enum.\n";
  out += '///\n';
  out += '/// Client → Server events are used with `socket.emit()`.\n';
  out += '/// Server → Client events are used with `socket.on()`.\n';
  out += 'abstract final class WsChatEvent {\n';
  out += '  WsChatEvent._();\n\n';

  out += '  // ── Client → Server ────────────────────────────────\n';
  for (const [event, meta] of clientToServer) {
    out += `\n  /// ${meta.description}\n`;
    out += `  static const ${snakeToCamel(event)} = '${event}';\n`;
  }

  out += '\n  // ── Server → Client ────────────────────────────────\n';
  for (const [event, meta] of serverToClient) {
    // Skip duplicates (e.g. 'typing' appears in both directions)
    if (clientToServer.has(event)) continue;
    out += `\n  /// ${meta.description}\n`;
    out += `  static const ${snakeToCamel(event)} = '${event}';\n`;
  }

  out += '}\n';
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

  // ── Enums ──────────────────────────────────────────────
  for (const [enumName, enumDef] of Object.entries(contract.enums || {})) {
    out += `/// ${enumDef.description}\n`;
    out += `enum ${enumName} {\n`;
    for (const val of enumDef.values) {
      out += `  ${val},\n`;
    }
    out += '}\n\n';

    // Helper: parse from string
    out += `${enumName} ${enumName.charAt(0).toLowerCase() + enumName.slice(1)}FromJson(dynamic value) {\n`;
    out += `  if (value == null) return ${enumName}.${enumDef.values[0]};\n`;
    out += `  final str = value.toString().toLowerCase();\n`;
    out += `  return ${enumName}.values.firstWhere(\n`;
    out += `    (e) => e.name == str,\n`;
    out += `    orElse: () => ${enumName}.${enumDef.values[0]},\n`;
    out += `  );\n`;
    out += '}\n\n';

    // Helper: to string
    out += `String ${enumName.charAt(0).toLowerCase() + enumName.slice(1)}ToJson(${enumName} value) => value.name;\n\n`;
  }

  // ── Models ─────────────────────────────────────────────
  for (const [modelName, modelDef] of Object.entries(contract.models || {})) {
    const props = Object.entries(modelDef.properties || {});
    const isClientPayload = modelDef.direction === 'clientToServer';
    const isServerEvent = modelDef.direction === 'serverToClient';

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
        const defaultVal = prop.isEnum
          ? `${prop.type}.${prop.default}`
          : `'${prop.default}'`;
        out += `    this.${propName} = ${defaultVal},\n`;
      } else {
        out += `    this.${propName},\n`;
      }
    }
    out += '  });\n\n';

    // fromJson (for server → client models and ack models)
    if (isServerEvent || modelName.includes('Ack')) {
      out += `  /// Deserialize from a Socket.IO JSON map.\n`;
      out += `  factory ${modelName}.fromJson(Map<String, dynamic> json) {\n`;
      out += `    return ${modelName}(\n`;
      for (const [propName, prop] of props) {
        if (prop.isEnum) {
          const fnName = `${prop.type.charAt(0).toLowerCase() + prop.type.slice(1)}FromJson`;
          out += `      ${propName}: ${fnName}(json['${propName}']),\n`;
        } else if (prop.type === 'DateTime') {
          if (prop.required) {
            out += `      ${propName}: DateTime.parse(json['${propName}'] as String),\n`;
          } else {
            out += `      ${propName}: json['${propName}'] != null\n`;
            out += `          ? DateTime.parse(json['${propName}'] as String)\n`;
            out += `          : null,\n`;
          }
        } else {
          out += `      ${propName}: json['${propName}'] as ${dartType(prop)}${nullable(prop)},\n`;
        }
      }
      out += '    );\n';
      out += '  }\n\n';
    }

    // toJson (for client → server models)
    if (isClientPayload) {
      out += `  /// Serialize to a JSON map for Socket.IO emit.\n`;
      out += `  Map<String, dynamic> toJson() {\n`;
      out += `    return <String, dynamic>{\n`;
      for (const [propName, prop] of props) {
        if (prop.required) {
          if (prop.isEnum) {
            const fnName = `${prop.type.charAt(0).toLowerCase() + prop.type.slice(1)}ToJson`;
            out += `      '${propName}': ${fnName}(${propName}),\n`;
          } else {
            out += `      '${propName}': ${propName},\n`;
          }
        } else {
          if (prop.isEnum) {
            const fnName = `${prop.type.charAt(0).toLowerCase() + prop.type.slice(1)}ToJson`;
            out += `      if (${propName} != null) '${propName}': ${fnName}(${propName}!),\n`;
          } else {
            out += `      if (${propName} != null) '${propName}': ${propName},\n`;
          }
        }
      }
      out += '    };\n';
      out += '  }\n\n';
    }

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
    out += '/// socket.onNewMessage.listen((msg) => print(msg));\n';
    out += '/// socket.sendMessage(WsSendMessagePayload(...));\n';
    out += '/// ' + '```' + '\n';
    out += `class ${className} implements WsNamespaceSocket {\n`;
    out += `  static final _log = Logger('${loggerName}');\n\n`;
    out += `  io.Socket? _socket;\n\n`;

    // ── Stream controllers ──────────────────────────────
    const serverEvents = Object.entries(source.serverToClient || {});

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
    out += `      _log.severe('Connection error: \$err');\n`;
    out += `      _updateStatus(WsConnectionStatus.error);\n`;
    out += `    });\n\n`;
    out += `    _socket!.onError((err) {\n`;
    out += `      _log.severe('Socket error: \$err');\n`;
    out += `    });\n\n`;

    // Server → Client event listeners
    out += `    // ── Server → Client event listeners ─────────────\n\n`;
    for (const [event, meta] of serverEvents) {
      const camel = snakeToCamel(event);
      const payloadType = meta.payload;
      out += `    _socket!.on(WsChatEvent.${camel}, (data) {\n`;
      out += `      try {\n`;
      out += `        final map = data as Map<String, dynamic>;\n`;
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
          out += `      WsChatEvent.${camel},\n`;
          out += `      {'conversationId': conversationId},\n`;
          out += `      ack: (response) {\n`;
          out += `        if (onAck != null && response is Map) {\n`;
          out += `          onAck(${ackType}.fromJson(\n`;
          out += `            Map<String, dynamic>.from(response),\n`;
          out += `          ));\n`;
          out += `        }\n`;
          out += `      },\n`;
          out += `    );\n`;
          out += `  }\n\n`;
        } else {
          out += `  void ${camel}(String conversationId) {\n`;
          out += `    _socket?.emit(WsChatEvent.${camel}, {\n`;
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
          out += `      WsChatEvent.${camel},\n`;
          out += `      payload.toJson(),\n`;
          out += `      ack: (response) {\n`;
          out += `        if (onAck != null && response is Map) {\n`;
          out += `          onAck(${ackType}.fromJson(\n`;
          out += `            Map<String, dynamic>.from(response),\n`;
          out += `          ));\n`;
          out += `        }\n`;
          out += `      },\n`;
          out += `    );\n`;
          out += `  }\n\n`;
        } else {
          out += `  void ${camel}(${payloadType} payload) {\n`;
          out += `    _socket?.emit(WsChatEvent.${camel}, payload.toJson());\n`;
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
const modelCount = Object.keys(contract.models || {}).length;
const enumCount = Object.keys(contract.enums || {}).length;
const nsCount = Object.keys(contract.namespaces).length;

console.log('');
console.log('📦  Generation complete!');
console.log(`   ${allEvents.size} events, ${modelCount} models, ${enumCount} enums, ${nsCount} namespaces`);
console.log(`   Output: ${outputDir}`);
console.log('');
