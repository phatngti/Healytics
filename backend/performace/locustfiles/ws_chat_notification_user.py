"""
WebSocket performance test — /chat-notifications namespace.

This is a listener-only user. The chat-notifications namespace has no
client→server events; it receives popup notifications for new chat messages.

Events monitored:
  - new_message_notification → WsNewMessageNotification

Run:
    locust --tags ws,chat-notifications -u 10 -r 2
"""

import gevent
from locust import tag, task

from common.auth import login_user
from common.ws_base import HealyticsSocketIOUser


@tag("ws", "chat-notifications")
class WsChatNotificationUser(HealyticsSocketIOUser):
    """
    Simulates a user connected to the /chat-notifications namespace.
    Passively listens for new_message_notification popup events.
    """

    ws_namespace = "/chat-notifications"
    ws_login_fn = staticmethod(login_user)

    # ── Server event handlers ────────────────────────────────────────────────

    def _register_server_events(self):
        """Register handler for /chat-notifications server→client events."""
        ns = self.ws_namespace

        @self.sio.on("new_message_notification", namespace=ns)
        def on_new_message_notification(data):
            self._on_server_event("new_message_notification", data)

    # ── Tasks ────────────────────────────────────────────────────────────────

    @task
    def listen(self):
        """
        No-op task — keeps the user alive and connected.
        Server events are captured by the registered handler above.
        """
        gevent.sleep(1)
