"""
WebSocket performance test — /user-chat namespace.

Simulates a patient interacting with the chat system:
  - Sending messages (with ack measurement)
  - Typing / stop-typing indicators
  - Marking messages as read
  - Joining conversations

Events emitted (client→server):
  - send_message          → WsSendMessagePayload (ack: WsMessageSentAck)
  - typing                → WsTypingPayload
  - stop_typing           → WsTypingPayload
  - mark_read             → WsMarkReadPayload
  - join_conversation     → WsJoinConversationPayload

Events monitored (server→client):
  - new_message           → WsNewMessageEvent
  - message_sent          → WsMessageSentAck
  - messages_read         → WsMessagesReadEvent
  - typing                → WsTypingEvent
  - stop_typing           → WsStopTypingEvent
  - error                 → WsErrorEvent

Run:
    locust --tags ws,chat -u 20 -r 5
"""

import gevent
from locust import tag, task

from common.auth import login_user
from common.ws_base import HealyticsSocketIOUser
from common.ws_data_generators import (
    generate_send_message,
    generate_typing,
    generate_mark_read,
    generate_join_conversation,
)


@tag("ws", "chat")
class WsUserChatUser(HealyticsSocketIOUser):
    """
    Simulates a patient user in the /user-chat namespace.
    Performs realistic chat interactions with weighted task distribution.
    """

    ws_namespace = "/user-chat"
    ws_login_fn = staticmethod(login_user)

    # ── Server event handlers ────────────────────────────────────────────────

    def _register_server_events(self):
        """Register handlers for all /user-chat server→client events."""
        ns = self.ws_namespace

        @self.sio.on("new_message", namespace=ns)
        def on_new_message(data):
            self._on_server_event("new_message", data)

        @self.sio.on("message_sent", namespace=ns)
        def on_message_sent(data):
            self._on_server_event("message_sent", data)

        @self.sio.on("messages_read", namespace=ns)
        def on_messages_read(data):
            self._on_server_event("messages_read", data)

        @self.sio.on("typing", namespace=ns)
        def on_typing(data):
            self._on_server_event("typing", data)

        @self.sio.on("stop_typing", namespace=ns)
        def on_stop_typing(data):
            self._on_server_event("stop_typing", data)

        @self.sio.on("error", namespace=ns)
        def on_error(data):
            self._on_server_event("error", data)

    # ── Tasks (weighted to simulate realistic behavior) ──────────────────────

    @task(5)
    def send_message(self):
        """
        Send a chat message and measure the round-trip time.
        Uses sio.call() which waits for the server acknowledgement (WsMessageSentAck).
        """
        payload = generate_send_message()
        self.ws_call("send_message", payload)

    @task(3)
    def typing_flow(self):
        """
        Simulate a typing → pause → stop_typing flow.
        This is fire-and-forget (no server ack expected).
        """
        payload = generate_typing()
        self.ws_emit_measured("typing", payload)

        # Simulate typing duration
        gevent.sleep(1 + gevent.time.time() % 2)

        self.ws_emit_measured("stop_typing", payload)

    @task(2)
    def mark_read(self):
        """Mark messages in a conversation as read."""
        payload = generate_mark_read()
        self.ws_emit_measured("mark_read", payload)

    @task(1)
    def join_conversation(self):
        """Join a conversation room."""
        payload = generate_join_conversation()
        self.ws_emit_measured("join_conversation", payload)
