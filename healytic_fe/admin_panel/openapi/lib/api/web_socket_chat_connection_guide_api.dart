//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class WebSocketChatConnectionGuideApi {
  WebSocketChatConnectionGuideApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// 📥 error — Error notification
  ///
  ///  ## Event: `error` **Direction:** Server → Client **When:** A `send_message` or other operation fails  ### Payload  ```javascript socket.on('error', (data) => {   // data = { message: 'You are not a participant of this conversation' }   showError(data.message); }); ```     
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> wsChatDocsControllerGetErrorDocsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/chat/ws-docs/events/error';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 📥 error — Error notification
  ///
  ///  ## Event: `error` **Direction:** Server → Client **When:** A `send_message` or other operation fails  ### Payload  ```javascript socket.on('error', (data) => {   // data = { message: 'You are not a participant of this conversation' }   showError(data.message); }); ```     
  Future<WsErrorEventDto?> wsChatDocsControllerGetErrorDocs() async {
    final response = await wsChatDocsControllerGetErrorDocsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WsErrorEventDto',) as WsErrorEventDto;
    
    }
    return null;
  }

  /// 📤 join_conversation — Join a conversation room
  ///
  ///  ## Event: `join_conversation` **Direction:** Client → Server  ### Usage  ```javascript // Call this after creating a new conversation via REST API socket.emit('join_conversation', { conversationId: '<uuid>' }); ```  ### Notes - On connect, the server auto-joins the socket to ALL existing conversation rooms - Use this event only for conversations created AFTER the socket connected - No server response — this is a fire-and-forget operation     
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> wsChatDocsControllerGetJoinConversationDocsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/chat/ws-docs/events/join-conversation';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 📤 join_conversation — Join a conversation room
  ///
  ///  ## Event: `join_conversation` **Direction:** Client → Server  ### Usage  ```javascript // Call this after creating a new conversation via REST API socket.emit('join_conversation', { conversationId: '<uuid>' }); ```  ### Notes - On connect, the server auto-joins the socket to ALL existing conversation rooms - Use this event only for conversations created AFTER the socket connected - No server response — this is a fire-and-forget operation     
  Future<WsJoinConversationPayloadDto?> wsChatDocsControllerGetJoinConversationDocs() async {
    final response = await wsChatDocsControllerGetJoinConversationDocsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WsJoinConversationPayloadDto',) as WsJoinConversationPayloadDto;
    
    }
    return null;
  }

  /// 📤 mark_read — Mark messages as read
  ///
  ///  ## Event: `mark_read` **Direction:** Client → Server → Other participant  ### Usage  ```javascript socket.emit('mark_read', { conversationId: '<uuid>' }); ```  ### Side Effects - Viewer's `unreadCount` is reset to 0 in the database - `messages_read` event is broadcast to the other participant  ### Received Event (other participant)  ```javascript socket.on('messages_read', (data) => {   // data = { conversationId, readerId, readAt }   updateReadReceipts(data.conversationId); }); ```     
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> wsChatDocsControllerGetMarkReadDocsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/chat/ws-docs/events/mark-read';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 📤 mark_read — Mark messages as read
  ///
  ///  ## Event: `mark_read` **Direction:** Client → Server → Other participant  ### Usage  ```javascript socket.emit('mark_read', { conversationId: '<uuid>' }); ```  ### Side Effects - Viewer's `unreadCount` is reset to 0 in the database - `messages_read` event is broadcast to the other participant  ### Received Event (other participant)  ```javascript socket.on('messages_read', (data) => {   // data = { conversationId, readerId, readAt }   updateReadReceipts(data.conversationId); }); ```     
  Future<WsMarkReadPayloadDto?> wsChatDocsControllerGetMarkReadDocs() async {
    final response = await wsChatDocsControllerGetMarkReadDocsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WsMarkReadPayloadDto',) as WsMarkReadPayloadDto;
    
    }
    return null;
  }

  /// 📥 message_sent — ACK for your sent message
  ///
  ///  ## Event: `message_sent` **Direction:** Server → Sender (ACK) **When:** Your `send_message` was processed successfully  ### Payload  ```javascript // Returned as the ACK response from emit socket.emit('send_message', payload, (response) => {   // response = { event: 'message_sent', data: { id, clientMessageId } }   markMessageAsDelivered(response.data.clientMessageId, response.data.id); }); ```  ### Notes - Use `clientMessageId` to match the ACK to your local pending message - Replace the local temp ID with the server-generated `id`     
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> wsChatDocsControllerGetMessageSentDocsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/chat/ws-docs/events/message-sent';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 📥 message_sent — ACK for your sent message
  ///
  ///  ## Event: `message_sent` **Direction:** Server → Sender (ACK) **When:** Your `send_message` was processed successfully  ### Payload  ```javascript // Returned as the ACK response from emit socket.emit('send_message', payload, (response) => {   // response = { event: 'message_sent', data: { id, clientMessageId } }   markMessageAsDelivered(response.data.clientMessageId, response.data.id); }); ```  ### Notes - Use `clientMessageId` to match the ACK to your local pending message - Replace the local temp ID with the server-generated `id`     
  Future<WsMessageSentAckDto?> wsChatDocsControllerGetMessageSentDocs() async {
    final response = await wsChatDocsControllerGetMessageSentDocsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WsMessageSentAckDto',) as WsMessageSentAckDto;
    
    }
    return null;
  }

  /// 📥 messages_read — Read receipt from other participant
  ///
  ///  ## Event: `messages_read` **Direction:** Server → Client **When:** The other participant calls `mark_read`  ### Payload  ```javascript socket.on('messages_read', (data) => {   // data = { conversationId, readerId, readAt }   showReadTicks(data.conversationId, data.readAt); }); ```     
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> wsChatDocsControllerGetMessagesReadDocsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/chat/ws-docs/events/messages-read';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 📥 messages_read — Read receipt from other participant
  ///
  ///  ## Event: `messages_read` **Direction:** Server → Client **When:** The other participant calls `mark_read`  ### Payload  ```javascript socket.on('messages_read', (data) => {   // data = { conversationId, readerId, readAt }   showReadTicks(data.conversationId, data.readAt); }); ```     
  Future<WsMessagesReadEventDto?> wsChatDocsControllerGetMessagesReadDocs() async {
    final response = await wsChatDocsControllerGetMessagesReadDocsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WsMessagesReadEventDto',) as WsMessagesReadEventDto;
    
    }
    return null;
  }

  /// 📥 new_message — Receive a new message
  ///
  ///  ## Event: `new_message` **Direction:** Server → Client **When:** Another participant sends a message in a conversation you're in  ### Payload  ```javascript socket.on('new_message', (data) => {   // data = {   //   id: '660e8400-...',   //   conversationId: '550e8400-...',   //   senderId: '770e8400-...',   //   senderName: 'Dr. Nguyen Van A',   //   senderAvatar: 'https://s3.example.com/...',   //   content: 'Hello!',   //   messageType: 'text',   //   clientMessageId: 'client-123',   //   createdAt: '2026-03-31T00:00:00.000Z'   // }   appendMessage(data); }); ```     
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> wsChatDocsControllerGetNewMessageDocsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/chat/ws-docs/events/new-message';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 📥 new_message — Receive a new message
  ///
  ///  ## Event: `new_message` **Direction:** Server → Client **When:** Another participant sends a message in a conversation you're in  ### Payload  ```javascript socket.on('new_message', (data) => {   // data = {   //   id: '660e8400-...',   //   conversationId: '550e8400-...',   //   senderId: '770e8400-...',   //   senderName: 'Dr. Nguyen Van A',   //   senderAvatar: 'https://s3.example.com/...',   //   content: 'Hello!',   //   messageType: 'text',   //   clientMessageId: 'client-123',   //   createdAt: '2026-03-31T00:00:00.000Z'   // }   appendMessage(data); }); ```     
  Future<WsNewMessageEventDto?> wsChatDocsControllerGetNewMessageDocs() async {
    final response = await wsChatDocsControllerGetNewMessageDocsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WsNewMessageEventDto',) as WsNewMessageEventDto;
    
    }
    return null;
  }

  /// 🟢 Partner Chat Gateway — ws://<host>:8080/partner-chat
  ///
  ///  ## WebSocket Connection (Health Partner side)  **Namespace:** `/partner-chat` **Allowed Roles:** `health_partner`, `employee` **Transport:** Socket.IO v4  ### How to Connect  ```javascript import { io } from 'socket.io-client';  const socket = io('ws://localhost:8080/partner-chat', {   auth: { token: '<JWT_ACCESS_TOKEN>' },   transports: ['websocket'], });  socket.on('connect', () => console.log('Connected!')); socket.on('connect_error', (err) => console.error(err.message)); ```  ### Flutter (socket_io_client) Example  ```dart import 'package:socket_io_client/socket_io_client.dart' as IO;  final socket = IO.io('http://localhost:8080/partner-chat',    IO.OptionBuilder()     .setTransports(['websocket'])     .setAuth({'token': accessToken})     .build(), );  socket.onConnect((_) => print('Connected to partner-chat')); socket.on('new_message', (data) => print('Message: $data')); ```  ### Connection Lifecycle  1. Client connects with JWT in `auth.token` 2. Server validates JWT → verifies role is `health_partner` or `employee` 3. Server auto-joins the socket to all existing conversation rooms 4. Client is ready to send/receive messages     
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> wsChatDocsControllerGetPartnerGatewayInfoWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/chat/ws-docs/partner-gateway';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 🟢 Partner Chat Gateway — ws://<host>:8080/partner-chat
  ///
  ///  ## WebSocket Connection (Health Partner side)  **Namespace:** `/partner-chat` **Allowed Roles:** `health_partner`, `employee` **Transport:** Socket.IO v4  ### How to Connect  ```javascript import { io } from 'socket.io-client';  const socket = io('ws://localhost:8080/partner-chat', {   auth: { token: '<JWT_ACCESS_TOKEN>' },   transports: ['websocket'], });  socket.on('connect', () => console.log('Connected!')); socket.on('connect_error', (err) => console.error(err.message)); ```  ### Flutter (socket_io_client) Example  ```dart import 'package:socket_io_client/socket_io_client.dart' as IO;  final socket = IO.io('http://localhost:8080/partner-chat',    IO.OptionBuilder()     .setTransports(['websocket'])     .setAuth({'token': accessToken})     .build(), );  socket.onConnect((_) => print('Connected to partner-chat')); socket.on('new_message', (data) => print('Message: $data')); ```  ### Connection Lifecycle  1. Client connects with JWT in `auth.token` 2. Server validates JWT → verifies role is `health_partner` or `employee` 3. Server auto-joins the socket to all existing conversation rooms 4. Client is ready to send/receive messages     
  Future<WsConnectionInfoDto?> wsChatDocsControllerGetPartnerGatewayInfo() async {
    final response = await wsChatDocsControllerGetPartnerGatewayInfoWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WsConnectionInfoDto',) as WsConnectionInfoDto;
    
    }
    return null;
  }

  /// 📤 send_message — Send a chat message
  ///
  ///  ## Event: `send_message` **Direction:** Client → Server **Response:** Server returns `{ event: \"message_sent\", data: { id, clientMessageId } }`  ### Usage  ```javascript socket.emit('send_message', {   conversationId: '550e8400-e29b-41d4-a716-446655440000',   content: 'Hello, I have a question!',   messageType: 'text',           // optional, default: 'text'   clientMessageId: 'client-123', // optional, for idempotent delivery }, (response) => {   // ACK callback   console.log('Sent:', response.data.id); }); ```  ### Flutter Example  ```dart socket.emitWithAck('send_message', {   'conversationId': conversationId,   'content': messageText,   'clientMessageId': uuid.v4(), // local UUID for dedup }).then((ack) {   print('Message ID: ${ack['data']['id']}'); }); ```  ### Side Effects - Message is persisted to database - Conversation `lastMessageText` and `lastMessageAt` are updated - Other participant's `unreadCount` is incremented - `new_message` event is broadcast to all sockets in the conversation room - If `clientMessageId` was already used, the existing message is returned (idempotent)  ### Errors - `Conversation not found` — invalid conversationId - `You are not a participant of this conversation` — access denied     
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> wsChatDocsControllerGetSendMessageDocsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/chat/ws-docs/events/send-message';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 📤 send_message — Send a chat message
  ///
  ///  ## Event: `send_message` **Direction:** Client → Server **Response:** Server returns `{ event: \"message_sent\", data: { id, clientMessageId } }`  ### Usage  ```javascript socket.emit('send_message', {   conversationId: '550e8400-e29b-41d4-a716-446655440000',   content: 'Hello, I have a question!',   messageType: 'text',           // optional, default: 'text'   clientMessageId: 'client-123', // optional, for idempotent delivery }, (response) => {   // ACK callback   console.log('Sent:', response.data.id); }); ```  ### Flutter Example  ```dart socket.emitWithAck('send_message', {   'conversationId': conversationId,   'content': messageText,   'clientMessageId': uuid.v4(), // local UUID for dedup }).then((ack) {   print('Message ID: ${ack['data']['id']}'); }); ```  ### Side Effects - Message is persisted to database - Conversation `lastMessageText` and `lastMessageAt` are updated - Other participant's `unreadCount` is incremented - `new_message` event is broadcast to all sockets in the conversation room - If `clientMessageId` was already used, the existing message is returned (idempotent)  ### Errors - `Conversation not found` — invalid conversationId - `You are not a participant of this conversation` — access denied     
  Future<WsSendMessagePayloadDto?> wsChatDocsControllerGetSendMessageDocs() async {
    final response = await wsChatDocsControllerGetSendMessageDocsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WsSendMessagePayloadDto',) as WsSendMessagePayloadDto;
    
    }
    return null;
  }

  /// 📤 typing / stop_typing — Typing indicators
  ///
  ///  ## Event: `typing` and `stop_typing` **Direction:** Client → Server → Other participants  ### Usage  ```javascript // When user starts typing socket.emit('typing', { conversationId: '<uuid>' });  // When user stops typing (after 3s of inactivity) socket.emit('stop_typing', { conversationId: '<uuid>' }); ```  ### Received Event (other participant)  ```javascript socket.on('typing', (data) => {   // data = { conversationId, userId, userName }   showTypingIndicator(data.userName); });  socket.on('stop_typing', (data) => {   // data = { conversationId, userId }   hideTypingIndicator(); }); ```  ### Notes - Typing events are NOT persisted — they are fire-and-forget - Events are broadcast to the other participant on BOTH gateways - Client should debounce and auto-send `stop_typing` after ~3s of no keystrokes     
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> wsChatDocsControllerGetTypingDocsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/chat/ws-docs/events/typing';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 📤 typing / stop_typing — Typing indicators
  ///
  ///  ## Event: `typing` and `stop_typing` **Direction:** Client → Server → Other participants  ### Usage  ```javascript // When user starts typing socket.emit('typing', { conversationId: '<uuid>' });  // When user stops typing (after 3s of inactivity) socket.emit('stop_typing', { conversationId: '<uuid>' }); ```  ### Received Event (other participant)  ```javascript socket.on('typing', (data) => {   // data = { conversationId, userId, userName }   showTypingIndicator(data.userName); });  socket.on('stop_typing', (data) => {   // data = { conversationId, userId }   hideTypingIndicator(); }); ```  ### Notes - Typing events are NOT persisted — they are fire-and-forget - Events are broadcast to the other participant on BOTH gateways - Client should debounce and auto-send `stop_typing` after ~3s of no keystrokes     
  Future<WsTypingPayloadDto?> wsChatDocsControllerGetTypingDocs() async {
    final response = await wsChatDocsControllerGetTypingDocsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WsTypingPayloadDto',) as WsTypingPayloadDto;
    
    }
    return null;
  }

  /// 🟢 User Chat Gateway — ws://<host>:8080/user-chat
  ///
  ///  ## WebSocket Connection (User / Patient side)  **Namespace:** `/user-chat` **Allowed Roles:** `user` **Transport:** Socket.IO v4  ### How to Connect  ```javascript import { io } from 'socket.io-client';  const socket = io('ws://localhost:8080/user-chat', {   auth: { token: '<JWT_ACCESS_TOKEN>' },   transports: ['websocket'], });  socket.on('connect', () => console.log('Connected!')); socket.on('connect_error', (err) => console.error(err.message)); // Possible errors: AUTH_REQUIRED, INVALID_TOKEN, USER_NOT_FOUND, INSUFFICIENT_ROLE ```  ### Flutter (socket_io_client) Example  ```dart import 'package:socket_io_client/socket_io_client.dart' as IO;  final socket = IO.io('http://localhost:8080/user-chat',    IO.OptionBuilder()     .setTransports(['websocket'])     .setAuth({'token': accessToken})     .build(), );  socket.onConnect((_) => print('Connected to user-chat')); socket.on('new_message', (data) => print('Message: $data')); ```  ### Connection Lifecycle  1. Client connects with JWT in `auth.token` 2. Server validates JWT → verifies role is `user` 3. Server auto-joins the socket to all existing conversation rooms 4. Client is ready to send/receive messages  ### Authentication Errors (on connect)  | Error Code | Meaning | |------------|---------| | `AUTH_REQUIRED` | No token provided in `auth.token` or `Authorization` header | | `INVALID_TOKEN` | JWT is expired, malformed, or has wrong signature | | `USER_NOT_FOUND` | Token is valid but account no longer exists | | `INSUFFICIENT_ROLE` | Account role is not `user` (e.g. partner trying to connect here) |     
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> wsChatDocsControllerGetUserGatewayInfoWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/chat/ws-docs/user-gateway';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// 🟢 User Chat Gateway — ws://<host>:8080/user-chat
  ///
  ///  ## WebSocket Connection (User / Patient side)  **Namespace:** `/user-chat` **Allowed Roles:** `user` **Transport:** Socket.IO v4  ### How to Connect  ```javascript import { io } from 'socket.io-client';  const socket = io('ws://localhost:8080/user-chat', {   auth: { token: '<JWT_ACCESS_TOKEN>' },   transports: ['websocket'], });  socket.on('connect', () => console.log('Connected!')); socket.on('connect_error', (err) => console.error(err.message)); // Possible errors: AUTH_REQUIRED, INVALID_TOKEN, USER_NOT_FOUND, INSUFFICIENT_ROLE ```  ### Flutter (socket_io_client) Example  ```dart import 'package:socket_io_client/socket_io_client.dart' as IO;  final socket = IO.io('http://localhost:8080/user-chat',    IO.OptionBuilder()     .setTransports(['websocket'])     .setAuth({'token': accessToken})     .build(), );  socket.onConnect((_) => print('Connected to user-chat')); socket.on('new_message', (data) => print('Message: $data')); ```  ### Connection Lifecycle  1. Client connects with JWT in `auth.token` 2. Server validates JWT → verifies role is `user` 3. Server auto-joins the socket to all existing conversation rooms 4. Client is ready to send/receive messages  ### Authentication Errors (on connect)  | Error Code | Meaning | |------------|---------| | `AUTH_REQUIRED` | No token provided in `auth.token` or `Authorization` header | | `INVALID_TOKEN` | JWT is expired, malformed, or has wrong signature | | `USER_NOT_FOUND` | Token is valid but account no longer exists | | `INSUFFICIENT_ROLE` | Account role is not `user` (e.g. partner trying to connect here) |     
  Future<WsConnectionInfoDto?> wsChatDocsControllerGetUserGatewayInfo() async {
    final response = await wsChatDocsControllerGetUserGatewayInfoWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WsConnectionInfoDto',) as WsConnectionInfoDto;
    
    }
    return null;
  }
}
