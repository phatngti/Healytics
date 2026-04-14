"""
Base class for Healytics Socket.IO performance testing.

Extends Locust's built-in SocketIOUser to provide:
  - JWT authentication via HTTP login before WS connect
  - Namespace-aware connection with auth token
  - Server→Client event handlers that log metrics to Locust
  - Graceful lifecycle management (connect / disconnect)

Usage:
    class MyWsUser(HealyticsSocketIOUser):
        ws_namespace = "/user-chat"
        ws_login_fn = staticmethod(login_user)

        @task
        def do_something(self):
            self.ws_emit("send_message", {...})
"""

from __future__ import annotations

import time
import logging

import gevent
from locust import task, between
from locust.contrib.socketio import SocketIOUser

from common.config import BASE_URL, MIN_WAIT, MAX_WAIT

logger = logging.getLogger(__name__)


class HealyticsSocketIOUser(SocketIOUser):
    """
    Abstract base for all Healytics WS users.

    Subclasses MUST set:
      - ws_namespace:  str   – Socket.IO namespace, e.g. "/user-chat"
      - ws_login_fn:   callable(client) -> (access_token, refresh_token)
    """

    abstract = True

    # ── Override in subclass ──────────────────────────────────────────────────
    ws_namespace: str = "/"
    ws_login_fn = None  # e.g. staticmethod(login_user)

    # ── SocketIOUser options ─────────────────────────────────────────────────
    options = {
        "reconnection": False,     # Locust manages user lifecycle
        "logger": False,
        "engineio_logger": False,
    }

    wait_time = between(MIN_WAIT, MAX_WAIT)

    # ── Lifecycle ────────────────────────────────────────────────────────────

    def on_start(self):
        """Authenticate via HTTP, then connect to the Socket.IO namespace."""
        self._access_token = None
        self._connected = False

        # 1. HTTP login to obtain JWT
        if self.ws_login_fn is None:
            raise NotImplementedError("Subclass must set ws_login_fn")

        token = self._http_login()
        if not token:
            logger.error("[%s] Login failed — skipping WS connect", self.__class__.__name__)
            return

        self._access_token = token

        # 2. Register server→client event handlers BEFORE connect
        self._register_server_events()

        # 3. Connect to the namespace with JWT auth
        try:
            ws_url = BASE_URL.replace("http://", "ws://").replace("https://", "wss://")
            self.sio.connect(
                ws_url,
                namespaces=[self.ws_namespace],
                auth={"token": self._access_token},
                wait_timeout=10,
            )
            self._connected = True
            logger.info("[%s] Connected to %s", self.__class__.__name__, self.ws_namespace)
        except Exception as e:
            logger.error("[%s] WS connect failed: %s", self.__class__.__name__, e)

    def on_stop(self):
        """Gracefully disconnect the Socket.IO client."""
        if self._connected:
            try:
                self.sio.disconnect()
            except Exception:
                pass
            self._connected = False

    # ── HTTP Login (reuses Locust's internal HTTP client) ────────────────────

    def _http_login(self) -> str | None:
        """
        Perform HTTP login using the configured login function.
        Since SocketIOUser doesn't have an HTTP client, we use requests directly.
        """
        import requests

        if self.ws_login_fn is None:
            return None

        # Use a simple requests session for the login call
        login_map = {
            "login_user": ("/auth/user/login", "common.config", "USER_EMAIL", "USER_PASSWORD"),
            "login_partner": ("/auth/partner/login", "common.config", "PARTNER_EMAIL", "PARTNER_PASSWORD"),
            "login_admin": ("/auth/admin/login", "common.config", "ADMIN_EMAIL", "ADMIN_PASSWORD"),
        }

        fn_name = self.ws_login_fn.__name__
        if fn_name not in login_map:
            logger.error("Unknown login function: %s", fn_name)
            return None

        path, module, email_var, pass_var = login_map[fn_name]
        from common import config
        email = getattr(config, email_var)
        password = getattr(config, pass_var)

        try:
            resp = requests.post(
                f"{BASE_URL}{path}",
                json={"email": email, "password": password},
                timeout=10,
            )
            if resp.status_code in (200, 201):
                data = resp.json()
                return data.get("access_token")
            else:
                logger.error("Login failed (%s): HTTP %s", path, resp.status_code)
                return None
        except Exception as e:
            logger.error("Login request error: %s", e)
            return None

    # ── Server→Client event registration ─────────────────────────────────────

    def _register_server_events(self):
        """
        Register handlers for all known server→client events.
        Subclasses can override to add namespace-specific handlers.
        """
        pass  # Subclasses override this

    def _on_server_event(self, event_name: str, data):
        """
        Generic handler for server→client events.
        Logs the event as a received WS message in Locust metrics.
        """
        self.environment.events.request.fire(
            request_type="WSR",
            name=f"{self.ws_namespace}:{event_name}",
            response_time=0,
            response_length=len(str(data)) if data else 0,
            exception=None,
            context={},
        )

    # ── Emit helpers ─────────────────────────────────────────────────────────

    def ws_emit(self, event: str, data: dict | None = None):
        """
        Fire-and-forget emit. Metrics are logged automatically by SocketIOClient.
        """
        if not self._connected:
            return
        try:
            self.sio.emit(event, data, namespace=self.ws_namespace)
        except Exception as e:
            logger.warning("[%s] Emit '%s' failed: %s", self.__class__.__name__, event, e)

    def ws_call(self, event: str, data: dict | None = None, timeout: int = 5):
        """
        Emit with acknowledgement — measures round-trip time via sio.call().
        Returns the server response or None on failure.
        """
        if not self._connected:
            return None
        try:
            return self.sio.call(event, data, namespace=self.ws_namespace, timeout=timeout)
        except Exception as e:
            logger.warning("[%s] Call '%s' failed: %s", self.__class__.__name__, event, e)
            return None

    def ws_emit_measured(self, event: str, data: dict | None = None):
        """
        Emit and manually measure the time until completion.
        Useful for events that don't have a Socket.IO ack but
        where we want to capture the emit latency.
        """
        if not self._connected:
            return
        start = time.perf_counter()
        exception = None
        try:
            self.sio.emit(event, data, namespace=self.ws_namespace)
        except Exception as e:
            exception = e
        elapsed_ms = (time.perf_counter() - start) * 1000

        self.environment.events.request.fire(
            request_type="WSE",
            name=f"{self.ws_namespace}:{event}",
            response_time=elapsed_ms,
            response_length=len(str(data)) if data else 0,
            exception=exception,
            context={},
        )
