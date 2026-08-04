# Service Project Guidelines

## Lifecycle & Startup
1. Implement graceful shutdown: on `SIGTERM`/`SIGINT`, stop accepting new requests, finish in-flight requests (with a timeout), flush buffers, and exit cleanly. Log each phase.
2. During startup, validate all required configuration before binding to the network; fail fast with a clear message if a required env var or dependency is unavailable.
3. Implement a readiness probe (e.g., `GET /ready`) that returns 200 only when the service is fully initialised and ready to serve traffic. Implement a liveness probe (`GET /health` or `GET /live`) that returns 200 as long as the process is alive.

## Configuration
4. All configuration is provided via environment variables; never hardcode environment-specific values (URLs, credentials, timeouts).
5. Document every environment variable in the README with its name, default, and whether it is required.
6. Validate and parse configuration at startup using a typed config struct (not raw `os.Getenv` scattered through the code).

## Observability
7. Emit structured JSON logs with consistent fields: `timestamp`, `level`, `service`, `trace_id`, `message`, and any request-scoped metadata.
8. Log at `INFO` for normal operations, `WARN` for recoverable anomalies, `ERROR` for failures that require attention, `DEBUG` for diagnostic detail (disabled in production).
9. Expose Prometheus-compatible metrics at `/metrics`: request count, error count, request latency histogram, and queue depth (if applicable).
10. Propagate trace context (W3C `traceparent` header or OpenTelemetry SDK) for distributed tracing support.

## Resilience
11. Set timeouts on all outbound calls (HTTP clients, database queries, cache lookups); never make an unbounded call.
12. Use circuit breakers for calls to external dependencies; degrade gracefully when a dependency is unavailable.
13. Implement retry with exponential backoff and jitter for transient failures; document the retry policy in code.
14. Back-pressure: if the service cannot keep up with inbound load, return `503 Service Unavailable` with a `Retry-After` header rather than queuing requests indefinitely.

## Signal Handling
15. Handle `SIGUSR1` or a `/_reload` admin endpoint to trigger configuration reload without restart where feasible.
16. On receiving `SIGTERM`, log the signal, set the readiness probe to fail (to drain from load balancers), wait for `DRAIN_TIMEOUT` seconds, then shut down.
