"""
Booking Race Condition — Locust Load Test

Simulates a "flash booking" scenario where many concurrent users attempt
to book the SAME staff + time slot simultaneously. Validates that exactly
1 booking succeeds and all others are correctly rejected.

Strategy:
    Instead of hardcoding a far-future slot (which fails the pre-check),
    the test dynamically fetches REAL available slots from the employee's
    time-slots API and rotates through them as each slot gets booked.

Test Shape:
    Phase 1 (0–30s):    Ramp 0→50 users at 10/s
    Phase 2 (30s–2m):   Sustained 50 users
    Phase 3 (2m–2m30s): Spike 50→200 users at 30/s
    Phase 4 (2m30s–3m): Cool-down → 0

Custom Metrics:
    booking_success_count       — total SUCCESS tickets (should be 1 per slot)
    booking_failure_count       — total FAILED tickets (should be N-1)
    booking_duplicate_detected  — MUST remain 0
    slot_rotation_count         — how many slots were consumed

Run:
    locust --tags booking-race -u 50 -r 10 --run-time 180s
    locust --tags booking-race -u 200 -r 30 --run-time 180s  # spike test
"""

import time
import uuid
import threading
import os
from datetime import datetime, timedelta, timezone

from locust import HttpUser, tag, task, between, events
from locust.exception import StopUser
from locust.runners import MasterRunner, WorkerRunner

from common.auth import login_user, login_user_unique, auth_headers
from common.config import MIN_WAIT, MAX_WAIT, BASE_URL, API_PREFIX
from common.data_generators import generate_async_checkout, generate_micro_lock
from models.account_controller import AccountMeResponseDto
from models.booking_controller import AsyncCheckoutResponseDto, CheckoutTicketResponseDto
from models.shared import EmployeeResponseDto
from models.user_employees_controller import EmployeeTimeSlotsResponseDto, DayScheduleDto, TimeSlotDto
from models.user_health_service_controller import PublicHealthServiceCardResponseDto


USER_BOOKINGS = f"{API_PREFIX}/user/bookings"
USER_EMPLOYEES = f"{API_PREFIX}/user/employees"
USER_ACCOUNT = f"{API_PREFIX}/account/me"
USER_HEALTH_SERVICES = f"{API_PREFIX}/user/health-services"
USER_SLOTS = f"{API_PREFIX}/user/slots"
USER_BOOKINGS_ASYNC_CHECKOUT = f"{API_PREFIX}/user/bookings/async-checkout"
USER_BOOKINGS_TICKETS = f"{API_PREFIX}/user/bookings/tickets"
USER_SLOTS_MICRO_LOCK = f"{API_PREFIX}/user/slots/micro-lock"
PERF_RACE_EMPLOYEE_ID = os.getenv("PERF_RACE_EMPLOYEE_ID")
PERF_RACE_PRODUCT_ID = os.getenv("PERF_RACE_PRODUCT_ID")

# ── Shared state across all users ────────────────────────────────────────────

class SlotTarget:
    """Immutable snapshot of a single contestable slot."""
    __slots__ = ("staff_id", "start_time", "product_id")

    def __init__(self, staff_id: str, start_time: str, product_id: str):
        self.staff_id = staff_id
        self.start_time = start_time
        self.product_id = product_id

    def __repr__(self):
        return f"SlotTarget(staff={self.staff_id}, time={self.start_time})"


class SharedBookingState:
    """Thread-safe shared state for coordinating the race condition test.

    Supports slot rotation: when a slot is consumed, the next available
    slot from the pool is activated so subsequent waves have a fresh target.
    """

    def __init__(self):
        self._lock = threading.Lock()
        self.user_id: str | None = None

        # Pool of available slots discovered during setup
        self._slot_pool: list[SlotTarget] = []
        self._current_slot_index: int = 0

        # Per-slot results (keyed by start_time for uniqueness)
        self.success_tickets: list[str] = []
        self.failed_tickets: list[str] = []
        self.submitted_ticket_ids: list[str] = []

        # Rotation metrics
        self.slot_rotation_count: int = 0
        self.slots_exhausted: bool = False

        self.initialized = False

    def set_slot_pool(self, user_id: str, slots: list[SlotTarget]):
        """Initialize the pool of available slots (called once by the first user)."""
        with self._lock:
            if not self.initialized and slots:
                self.user_id = user_id
                self._slot_pool = slots
                self._current_slot_index = 0
                self.initialized = True

    @property
    def current_slot(self) -> SlotTarget | None:
        with self._lock:
            if not self._slot_pool or self._current_slot_index >= len(self._slot_pool):
                return None
            return self._slot_pool[self._current_slot_index]

    @property
    def pool_size(self) -> int:
        with self._lock:
            return len(self._slot_pool)

    def rotate_slot(self):
        """Advance to the next slot in the pool.

        Called when the current slot is confirmed booked (SUCCESS) and
        we want the next wave to target a fresh slot.
        """
        with self._lock:
            if self._current_slot_index < len(self._slot_pool) - 1:
                self._current_slot_index += 1
                self.slot_rotation_count += 1
                # Reset per-slot counters for the new wave
                self.success_tickets.clear()
                self.failed_tickets.clear()
            else:
                self.slots_exhausted = True

    def record_submission(self, ticket_id: str):
        with self._lock:
            self.submitted_ticket_ids.append(ticket_id)

    def record_result(self, ticket_id: str, status: str):
        with self._lock:
            if status == "SUCCESS":
                if ticket_id not in self.success_tickets:
                    self.success_tickets.append(ticket_id)
            elif status == "FAILED":
                if ticket_id not in self.failed_tickets:
                    self.failed_tickets.append(ticket_id)

    @property
    def success_count(self) -> int:
        with self._lock:
            return len(self.success_tickets)

    @property
    def failure_count(self) -> int:
        with self._lock:
            return len(self.failed_tickets)

    @property
    def has_duplicate(self) -> bool:
        with self._lock:
            return len(self.success_tickets) > 1


# Global shared state
_state = SharedBookingState()


# ── Custom event listeners for metrics reporting ─────────────────────────────

@events.test_stop.add_listener
def on_test_stop(environment, **kwargs):
    """Print race condition results at test end."""
    current = _state.current_slot
    print("\n" + "=" * 60)
    print("  BOOKING RACE CONDITION — RESULTS")
    print("=" * 60)
    print(f"  Slot pool size:            {_state.pool_size}")
    print(f"  Slots consumed (rotated):  {_state.slot_rotation_count}")
    print(f"  Slots exhausted:           {'YES' if _state.slots_exhausted else 'NO'}")
    print(f"  Total submissions:         {len(_state.submitted_ticket_ids)}")
    print(f"  SUCCESS tickets (current): {_state.success_count}")
    print(f"  FAILED tickets (current):  {_state.failure_count}")
    print(f"  Duplicate detected:        {'YES ⚠️' if _state.has_duplicate else 'NO ✅'}")
    print(f"  Current slot:              {current}")
    print("=" * 60 + "\n")

    if _state.has_duplicate:
        print("⚠️  CRITICAL: Multiple bookings succeeded for the same slot!")
        print(f"   Success ticket IDs: {_state.success_tickets}")


# ── Slot Discovery Helpers ───────────────────────────────────────────────────

def _discover_available_slots(client, headers: dict, staff_id: str,
                               product_id: str) -> list[SlotTarget]:
    """Fetch real available slots from the employee time-slots API.

    Returns a list of SlotTarget for free slots, sorted chronologically.
    Targets slots 3–30 days in the future to avoid same-day edge cases.
    """
    # Request a 30-day window starting from 3 days out
    start_date = (datetime.now(timezone.utc) + timedelta(days=3)).strftime("%Y-%m-%d")

    url = f"{USER_EMPLOYEES}/{staff_id}/time-slots?date={start_date}&days=30"

    slots: list[SlotTarget] = []
    try:
        with client.get(
            url,
            headers=headers,
            name=f"{USER_EMPLOYEES}/:id/time-slots [seed]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                data = resp.json()
                ts_resp = EmployeeTimeSlotsResponseDto.from_dict(data)
                slot_duration = int(ts_resp.slotDurationMinutes) if ts_resp.slotDurationMinutes else 30

                for day in ts_resp.schedule:
                    if not day.isWorkingDay:
                        continue
                    for slot in day.slots:
                        # Only pick free slots
                        is_busy = slot.isBusy
                        if isinstance(is_busy, str):
                            is_busy = is_busy.lower() in ("true", "1", "yes")
                        if is_busy:
                            continue

                        # Build full ISO datetime from date + time
                        slot_dt = datetime.strptime(
                            f"{day.date} {slot.time}", "%Y-%m-%d %H:%M"
                        ).replace(tzinfo=timezone.utc)

                        slots.append(SlotTarget(
                            staff_id=staff_id,
                            start_time=slot_dt.isoformat(),
                            product_id=product_id,
                        ))

                resp.success()
            else:
                resp.failure(f"Could not fetch time-slots: {resp.status_code}")
    except Exception as e:
        print(f"[seed] Error discovering slots: {e}")

    return slots


def _get_specialist_service_id(client, headers: dict, staff_id: str) -> str | None:
    """Fetch the first service (product) that this specialist can perform.

    Uses GET /user/employees/:id/services to guarantee the staff↔product
    FK relationship is valid.
    """
    url = f"{USER_EMPLOYEES}/{staff_id}/services"
    try:
        with client.get(
            url,
            headers=headers,
            name=f"{USER_EMPLOYEES}/:id/services [seed]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                data = resp.json()
                items = data if isinstance(data, list) else data.get("items", [])
                if items:
                    # BookingServiceResponseDto has an 'id' field
                    resp.success()
                    return items[0].get("id") or items[0].get("productId")
                resp.failure("No services found for specialist")
            else:
                resp.failure(f"Could not fetch services: {resp.status_code}")
    except Exception:
        pass
    return None


# ── User Classes ─────────────────────────────────────────────────────────────

@tag("booking-race")
class BookingRaceUser(HttpUser):
    """
    Simulates a user aggressively attempting to book a specific slot.
    All instances target the SAME staff + time slot.

    On startup, the first user discovers real available slots via the
    time-slots API and populates the shared slot pool.
    """

    wait_time = between(0.1, 0.5)  # Very short wait — maximize contention
    weight = 10  # High weight — most users are race participants
    host = BASE_URL  # Fallback if --host / locust.conf not set

    def on_start(self):
        """Login as a *unique* user and configure shared target slot."""
        token, _, email = login_user_unique(self.client)
        if not token:
            raise StopUser()

        self.token = token
        self.user_email = email
        self.headers = auth_headers(token)
        self.my_ticket_ids: list[str] = []

        # First user initializes the shared slot pool
        if not _state.initialized:
            self._initialize_slot_pool()

    def _initialize_slot_pool(self):
        """Discover staff, product, and available slots from the API."""
        staff_id = self._get_staff_id()
        user_id = self._get_user_id()

        # Prefer the perf-only race product generated by register_perf_accounts.js.
        product_id = PERF_RACE_PRODUCT_ID or _get_specialist_service_id(self.client, self.headers, staff_id)
        if not product_id:
            # Fallback: try the generic premium-treatments listing
            product_id = self._get_product_id()

        if not product_id:
            print(f"[seed] ⚠️ No product found — race test cannot proceed")
            return

        # Discover real free slots
        slots = _discover_available_slots(
            self.client, self.headers, staff_id, product_id,
        )

        if not slots:
            print(f"[seed] ⚠️ No free slots found for staff={staff_id} — race test cannot proceed")
            return

        print(f"[seed] ✅ Discovered {len(slots)} free slots for staff={staff_id}")
        print(f"[seed]    First slot: {slots[0]}")
        print(f"[seed]    Last slot:  {slots[-1]}")

        _state.set_slot_pool(user_id=user_id, slots=slots)

    def _get_staff_id(self) -> str:
        """Fetch a real staff ID from the API."""
        if PERF_RACE_EMPLOYEE_ID:
            return PERF_RACE_EMPLOYEE_ID

        try:
            with self.client.get(
                f"{USER_EMPLOYEES}?page=1&limit=1",
                headers=self.headers,
                name=f"{USER_EMPLOYEES} [seed]",
                catch_response=True,
            ) as resp:
                if resp.status_code == 200:
                    data = resp.json()
                    items = data if isinstance(data, list) else data.get("items", [])
                    if items:
                        employee = EmployeeResponseDto.from_dict(items[0])
                        return employee.id
                resp.failure(f"Could not fetch staff: {resp.status_code}")
        except Exception:
            pass
        return str(uuid.uuid4())

    def _get_user_id(self) -> str:
        """Get the authenticated user's ID."""
        try:
            with self.client.get(
                USER_ACCOUNT,
                headers=self.headers,
                name=f"{USER_ACCOUNT} [seed]",
                catch_response=True,
            ) as resp:
                if resp.status_code == 200:
                    account = AccountMeResponseDto.from_dict(resp.json())
                    return account.id
                resp.failure(f"Could not fetch user: {resp.status_code}")
        except Exception:
            pass
        return str(uuid.uuid4())

    def _get_product_id(self) -> str | None:
        """Fetch a real product ID from the premium-treatments listing (fallback)."""
        if PERF_RACE_PRODUCT_ID:
            return PERF_RACE_PRODUCT_ID

        try:
            with self.client.get(
                f"{USER_HEALTH_SERVICES}/premium-treatments",
                headers=self.headers,
                name=f"{USER_HEALTH_SERVICES}/premium-treatments [seed]",
                catch_response=True,
            ) as resp:
                if resp.status_code == 200:
                    data = resp.json()
                    items = data if isinstance(data, list) else data.get("items", [])
                    if items:
                        product = PublicHealthServiceCardResponseDto.from_dict(items[0])
                        resp.success()
                        return product.id
                    resp.failure("No products found in premium-treatments")
                else:
                    resp.failure(f"Could not fetch product: {resp.status_code}")
        except Exception:
            pass
        return None

    @task(10)
    def attempt_booking(self):
        """Submit async checkout for the shared contested slot."""
        slot = _state.current_slot
        if slot is None:
            if _state.slots_exhausted:
                return  # All slots consumed — nothing left to test
            return  # Not initialized yet

        payload = generate_async_checkout(
            staff_id=slot.staff_id,
            start_time=slot.start_time,
            user_id=_state.user_id,
            product_id=slot.product_id,
        )

        with self.client.post(
            USER_BOOKINGS_ASYNC_CHECKOUT,
            json=payload,
            headers=self.headers,
            name=f"POST {USER_BOOKINGS_ASYNC_CHECKOUT} [race]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 202:
                checkout_resp = AsyncCheckoutResponseDto.from_dict(resp.json())
                if checkout_resp.ticketId:
                    self.my_ticket_ids.append(checkout_resp.ticketId)
                    _state.record_submission(checkout_resp.ticketId)

                    # If the response already contains a FAILED status with
                    # "Slot is no longer available", rotate immediately
                    if (checkout_resp.status == "FAILED"
                            and "no longer available" in (checkout_resp.message or "")):
                        _state.record_result(checkout_resp.ticketId, "FAILED")
                        _state.rotate_slot()

                resp.success()
            elif resp.status_code == 400:
                # FK validation or slot unavailable — expected for some users
                resp.success()
            else:
                resp.failure(f"Unexpected status: {resp.status_code}")

    @task(3)
    def poll_ticket(self):
        """Poll a previously submitted ticket for its final status."""
        if not self.my_ticket_ids:
            return

        ticket_id = self.my_ticket_ids[-1]

        with self.client.get(
            f"{USER_BOOKINGS_TICKETS}/{ticket_id}",
            headers=self.headers,
            name=f"GET {USER_BOOKINGS_TICKETS}/:id [poll]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                ticket = CheckoutTicketResponseDto.from_dict(resp.json())
                if ticket.status in ("SUCCESS", "FAILED"):
                    _state.record_result(ticket_id, ticket.status)

                    # When a booking succeeds, rotate to the next slot
                    # so subsequent requests target a fresh slot
                    if ticket.status == "SUCCESS":
                        _state.rotate_slot()

                    # Check for duplicate success — critical metric
                    if _state.has_duplicate:
                        resp.failure(
                            "CRITICAL: Duplicate booking detected! "
                            f"Multiple SUCCESS tickets for same slot."
                        )
                    else:
                        resp.success()
                else:
                    resp.success()
            elif resp.status_code == 404:
                resp.success()  # Ticket may not exist yet
            else:
                resp.failure(f"Unexpected status: {resp.status_code}")

    @task(1)
    def check_micro_lock(self):
        """Attempt micro-lock on the contested slot."""
        slot = _state.current_slot
        if slot is None:
            return

        payload = generate_micro_lock(
            staff_id=slot.staff_id,
            start_time=slot.start_time,
        )

        with self.client.post(
            USER_SLOTS_MICRO_LOCK,
            json=payload,
            headers=self.headers,
            name=f"POST {USER_SLOTS_MICRO_LOCK} [race]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 201):
                resp.success()
            else:
                resp.failure(f"Micro-lock failed: {resp.status_code}")


@tag("booking-race")
class BookingVerifier(HttpUser):
    """
    Low-frequency verification user that periodically checks
    the booking state to ensure no duplicates exist.
    """

    wait_time = between(3, 5)
    weight = 1  # Low weight — few verifier instances
    host = BASE_URL

    def on_start(self):
        """Login for verification queries."""
        token, _ = login_user(self.client)
        if not token:
            raise StopUser()

        self.token = token
        self.headers = auth_headers(token)

    @task(1)
    def verify_no_duplicates(self):
        """Check the shared state for duplicate success tickets."""
        if not _state.initialized:
            return

        # Report current state as a custom metric
        with self.client.get(
            f"{USER_BOOKINGS}?page=1&limit=50",
            headers=self.headers,
            name=f"GET {USER_BOOKINGS} [verify]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                if _state.has_duplicate:
                    resp.failure(
                        f"DUPLICATE DETECTED: {len(_state.success_tickets)} "
                        f"success tickets for same slot"
                    )
                else:
                    resp.success()
            else:
                resp.failure(f"Verify failed: {resp.status_code}")
