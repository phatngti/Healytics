"""
WebSocket performance test — /notifications namespace.

This is a listener-only user. The notifications namespace has no client→server
events; the server pushes events to connected users.

Events monitored:
  - new_notification     → WsNewNotificationEvent
  - unread_count         → WsUnreadCountEvent
  - broadcast_sent       → WsBroadcastSentEvent

Run:
    locust --tags ws,notifications -u 10 -r 2
"""

import gevent
from locust import tag, task

from common.auth import login_user
from common.ws_base import HealyticsSocketIOUser


@tag("ws", "notifications")
class WsNotificationUser(HealyticsSocketIOUser):
    """
    Simulates a user connected to the /notifications namespace.
    Passively listens for server-pushed notification events.
    """

    ws_namespace = "/notifications"
    ws_login_fn = staticmethod(login_user)

    # ── Server event handlers ────────────────────────────────────────────────

    def _register_server_events(self):
        """Register handlers for all /notifications server→client events."""
        ns = self.ws_namespace

        @self.sio.on("new_notification", namespace=ns)
        def on_new_notification(data):
            self._on_server_event("new_notification", data)

        @self.sio.on("unread_count", namespace=ns)
        def on_unread_count(data):
            self._on_server_event("unread_count", data)

        @self.sio.on("broadcast_sent", namespace=ns)
        def on_broadcast_sent(data):
            self._on_server_event("broadcast_sent", data)

    # ── Tasks ────────────────────────────────────────────────────────────────

    @task
    def listen(self):
        """
        No-op task — keeps the user alive and connected.
        Server events are captured by the registered handlers above.
        We just yield control to let gevent process incoming events.
        """
        gevent.sleep(1)
