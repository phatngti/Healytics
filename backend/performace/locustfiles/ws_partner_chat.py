"""
WebSocket performance test — /partner-chat namespace.

Simulates a health partner interacting with the chat system.
The /partner-chat namespace extends /user-chat (same events, different auth).

Run:
    locust --tags ws,chat,partner -u 10 -r 2
"""

import gevent
from locust import tag, task

from common.auth import login_partner
from common.ws_base import HealyticsSocketIOUser
from common.ws_data_generators import (
    generate_send_message,
    generate_typing,
    generate_mark_read,
    generate_join_conversation,
)


@tag("ws", "chat", "partner")
class WsPartnerChatUser(HealyticsSocketIOUser):
    """
    Simulates a health partner user in the /partner-chat namespace.
    Same events as /user-chat but authenticates as a partner.
    """

    ws_namespace = "/partner-chat"
    ws_login_fn = staticmethod(login_partner)

    # ── Server event handlers ────────────────────────────────────────────────

    def _register_server_events(self):
        """Register handlers for all /partner-chat server→client events."""
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

    # ── Tasks (same as user-chat, weighted for partner behavior) ─────────────

    @task(5)
    def send_message(self):
        """Send a chat message with emit latency measurement."""
        payload = generate_send_message(sender_role="partner")
        self.ws_emit_measured("send_message", payload)

    @task(3)
    def typing_flow(self):
        """Simulate typing → pause → stop_typing."""
        payload = generate_typing(sender_role="partner")
        self.ws_emit_measured("typing", payload)
        gevent.sleep(1 + gevent.time.time() % 2)
        self.ws_emit_measured("stop_typing", payload)

    @task(2)
    def mark_read(self):
        """Mark messages in a conversation as read."""
        payload = generate_mark_read(sender_role="partner")
        self.ws_emit_measured("mark_read", payload)

    @task(1)
    def join_conversation(self):
        """Join a conversation room."""
        payload = generate_join_conversation()
        self.ws_emit_measured("join_conversation", payload)
