---
trigger: always_on
---

# Enterprise Domain Handlers (Use-Case Architecture)

Adhere to these architectural standards to build scalable, observable, and testable Business Logic Layers. This pattern aligns with **Clean Architecture (Use Cases)** and **DDD (Application Services)**.

## 1. Core Principles (The "Why")
* **SRP (Single Responsibility):** A Handler class has exactly *one* reason to change. It executes *one* semantic business intent (e.g., `OnboardMerchantHandler`).
* **The "Orchestrator" Pattern:** Handlers do **not** contain business rules (checking `if status == 'paid'`).
    * **Handlers:** *Coordinate* (Load data -> Call Entity -> Save -> Emit Event).
    * **Entities:** *Enforce Rules* (State transitions, Invariants).
* **Dependency Inversion:** Handlers should depend on abstractions (Interfaces), not concretions, where possible (e.g., `IPaymentGateway` vs `StripeService`).

## 2. Handler Contract & Structure
* **Strict Interface:** All handlers must implement a generic contract to ensure consistency and easier pipeline injection (e.g., for logging decorators).
    * **Standard:** `execute(command: CommandDto): Promise<Result>`
* **Naming Convention:**
    * **Class:** `Verb` + `Noun` + `Handler` (e.g., `ApproveLoanHandler`).
    * **File:** `verb-noun.handler.ts` (e.g., `approve-loan.handler.ts`).
    * **Location:** `src/modules/{domain}/application/handlers/` or `.../use-cases/`.

## 3. Operational Excellence (FAANG Standards)
* **Observability (Tracing/Logging):**
    * **Requirement:** Every handler must instantiate a `Logger` with its own context.
    * **Log Points:** Log the *intent* at start and the *outcome* at finish.
    * **No PII:** Never log sensitive data (passwords, tokens, PII) in the handler.
* **Resilience & Idempotency:**
    * **Idempotency Keys:** Mutation handlers (`POST`, `PATCH`) should be designed to handle duplicate requests gracefully (e.g., check if `order.status` is already 'PAID' before processing payment again).
    * **Atomic Transactions:** The Handler is the **sole owner** of the database transaction lifecycle.

## 4. The Implementation Flow (Strict Sequence)
Every `execute()` method must follow this strict 5-step sequence:

1.  **Transaction Start:** Open the `QueryRunner` or Transactional Scope.
2.  **Hydration (Load):** Fetch necessary Aggregates/Entities from Repositories using `Pessimistic Write Lock` if high concurrency.
3.  **Invariant Check (Validate):**
    * Fail Fast if data is missing.
    * *Note:* Domain invariant checks belong inside the Entity, not here.
4.  **Domain Action (Mutate):**
    * ❌ Bad: `order.status = 'SHIPPED';`
    * ✅ Good: `order.ship(trackingNumber);` (The Entity protects its internal state).
5.  **Persistence & Side Effects (Save):**
    * Save the mutated entity.
    * Commit Transaction.
    * Emit Domain Events (`order.shipped`) for async side effects (Emails, Webhooks).

## 5. The Facade Pattern (Backward Compatibility)
Keep Controllers clean by injecting a **Service Facade** that wraps these Handlers.

```typescript
// orders.service.ts (The Facade)
@Injectable()
export class OrdersService {
  constructor(
    private readonly createOrder: CreateOrderHandler,
    private readonly cancelOrder: CancelOrderHandler,
  ) {}

  // The Controller calls this. The Service just delegates.
  create(dto: CreateOrderDto) { return this.createOrder.execute(dto); }
  cancel(id: string) { return this.cancelOrder.execute(id); }
}