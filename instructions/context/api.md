# API Project Guidelines

## Design & Versioning
1. Design API-first: write or update the OpenAPI (or Protobuf/gRPC) specification before writing implementation code.
2. Version all APIs from day one: prefix REST routes with `/v1/`; use package versioning for gRPC (`package myapi.v1`).
3. Never make breaking changes to an existing version (removing fields, changing types, altering semantics); introduce a new version instead.
4. Deprecate endpoints explicitly: add a `Deprecation` response header and document the sunset date in the spec.

## REST Conventions
5. Use HTTP verbs semantically: `GET` (read, no side effects), `POST` (create/action), `PUT` (full replace), `PATCH` (partial update), `DELETE` (remove).
6. Use nouns for resource names, plural (`/users`, `/orders`), and nest only one level deep (`/users/{id}/orders`).
7. Return standard HTTP status codes: `200 OK`, `201 Created`, `204 No Content`, `400 Bad Request`, `401 Unauthorized`, `403 Forbidden`, `404 Not Found`, `409 Conflict`, `422 Unprocessable Entity`, `500 Internal Server Error`.
8. Return a consistent error envelope for all error responses:
   ```json
   { "error": { "code": "VALIDATION_ERROR", "message": "…", "details": [] } }
   ```

## Request & Response
9. Accept and return `application/json` by default; negotiate content type via `Accept` headers.
10. Use `snake_case` for JSON field names; use ISO 8601 (`2025-01-15T10:00:00Z`) for all timestamps.
11. Paginate all list endpoints: prefer cursor-based pagination over offset-based for large datasets; return `next_cursor` and `total` in the response envelope.
12. Validate all incoming payloads at the API boundary before they reach business logic; return `400`/`422` with field-level detail on validation failure.

## Authentication & Authorization
13. Use `Authorization: Bearer <token>` (JWT or opaque token) for authentication; never pass tokens in query parameters.
14. Apply authorization checks at the service/handler layer, not in the database query — never rely on filtered queries as the sole access control.
15. Return `401 Unauthorized` when credentials are missing or invalid; `403 Forbidden` when the user is authenticated but lacks permission.

## Performance & Reliability
16. Set and document rate limits; return `429 Too Many Requests` with a `Retry-After` header when limits are exceeded.
17. Use idempotency keys (`Idempotency-Key` header) for non-idempotent operations (payments, resource creation) to allow safe client retries.
18. Implement request timeouts; never expose an unbounded endpoint that can tie up resources indefinitely.
19. Emit structured access logs for every request: method, path, status code, latency, user/tenant ID.
