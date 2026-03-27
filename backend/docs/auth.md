# Authentication Module (Enterprise Architecture)

## 1. Module Overview
The **Authentication Module** acts as the security gateway for the platform. It implements a robust **JWT (JSON Web Token)** strategy with separate flows for End Users (Mobile App) and Administrative Staff (Dashboard), ensuring strict access control boundaries.

### Key Capabilities
*   **Dual Authentication Flows**: Explicitly separated endpoints for `User` vs `Admin`/`Partner`.
*   **Token Rotation**: Implements short-lived Access Tokens and long-lived Refresh Tokens.
*   **Session Security**: Refresh tokens are hashed in the database to prevent theft.
*   **Role-Based Access Control (RBAC)**: Fine-grained guards (`RolesGuard`) to enforce permission policies.

---

## 2. Architecture & Patterns

### Component Layers
1.  **Transport Layer (`AuthController`)**:
    *   **Responsibility**: Endpoint routing, HTTP status codes, Swagger documentation.
    *   **Pattern**: Facade that delegates to `AuthService`.
2.  **Domain Layer (`AuthService`)**:
    *   **Responsibility**: Credential validation, Token generation (signing), Registration orchestration.
3.  **Security Layer (`Guards` & `Strategies`)**:
    *   **`LocalStrategy`**: Validates Email/Password credentials.
    *   **`JwtStrategy`**: Validates Access Token signature and expiration.
    *   **`RolesGuard`**: Checks `user.role` against `@Roles()` decorator requirements.

---

## 3. Workflows

### 3.1 User Registration Flow
1.  **Request**: `POST /auth/user/register` with Email, Password, Profile.
2.  **Validation**: Check if email exists.
3.  **Creation**: Create `Account` (Internal Service).
4.  **Token Generation**: Generate Access + Refresh pair.
5.  **Persistence**: Hash Refresh Token and save to `Account` record.
6.  **Response**: Return tokens.

### 3.2 Token Refresh Flow
1.  **Request**: `POST /auth/refresh` with `refresh_token`.
2.  **Verification**: Verify signature of token.
3.  **Lookup**: Find user by `sub` (Subject/ID).
4.  **Security Check**: Compare hash of provided token against DB hash. **Critical Security Step**.
5.  **Rotation**: Generate NEW Access + Refresh pair.
6.  **Update**: Update DB with new Refresh Token hash.

---

## 4. API Interface

### Endpoints Summary

#### User Authentication (Mobile)
*   **POST** `/auth/user/register`: Register new user account (Role: `USER`).
*   **POST** `/auth/user/login`: Login for end-users. Rejects admin accounts.

#### Admin Authentication (Dashboard)
*   **POST** `/auth/admin/login`: Login for `ADMIN`, `HEALTH_PARTNER`, `EMPLOYEE`. Rejects standard users.

#### Common Operations
*   **POST** `/auth/refresh`: Rotate tokens.
*   **POST** `/auth/logout`: Revoke current session (clears refresh hash).

#### Deprecated Endpoints (Legacy)
> [!WARNING]
> These endpoints are maintained for backward compatibility and will be removed in v2.0.
*   `POST /auth/register`
*   `POST /auth/login`

### Token Specifications
*   **Access Token**:
    *   **Lifespan**: Short (Configurable, default 1 hour).
    *   **Payload**: `sub` (UUID), `email`, `role`.
*   **Refresh Token**:
    *   **Lifespan**: Long (Configurable, default 7 days).
    *   **Storage**: Hashed (Bcrypt).

---

## 5. Security Matrix

| Feature | Implementation | Benefit |
|:--------|:---------------|:--------|
| **Transport** | HTTPS Required (Prod) | Prevents Middle-in-the-middle attacks. |
| **Password** | Bcrypt (Salt 10) | Resistant to rainbow table attacks. |
| **Tokens** | JWT (RS256/HS256) | Stateless authentication. |
| **Refresh** | Hashed in DB | Compromised DB does not compromise active sessions. |
| **Isolation** | User/Admin Split | Prevents privilege escalation attacks. |

### Configuration Variables
*   `JWT_SECRET`: Signing key.
*   `JWT_EXPIRES_IN`: Access token duration (e.g., '3600s').
*   `JWT_REFRESH_EXPIRES_IN`: Refresh token duration (e.g., '7d').
