# Data Pipeline Project Guidelines

## Correctness & Idempotency
1. Treat data transformation steps as pure functions: same inputs always yield same outputs; side effects are explicit and logged.
2. Every pipeline stage must be idempotent: re-running a completed stage produces the same result without duplication or data loss.
3. Use checkpointing: record the completion of each stage (in a database, lock file, or metadata table) so partial runs can resume from the last successful step.
4. Validate input data at ingestion with explicit schema checks (column names, types, value ranges); fail fast with a descriptive error rather than propagating bad data silently.

## Observability
5. Log the start and end of every stage with wall-clock timestamps and input/output record counts.
6. Emit structured log records (JSON) for downstream monitoring: `{"stage": "normalize", "input_rows": 100000, "output_rows": 99850, "dropped": 150, "duration_s": 3.2}`.
7. Track data quality metrics: null rates, out-of-range values, duplicate keys; surface these as warnings, not silent drops.
8. Record the provenance of output data: which input files, which pipeline version, and when the run completed.

## Error & Edge-Case Handling
9. Handle missing or malformed records with explicit skip/warn semantics: log the record ID and reason, never silently discard.
10. Quarantine records that fail validation into a dead-letter location (`data/quarantine/`) for manual inspection.
11. Distinguish recoverable errors (retry with backoff) from unrecoverable errors (halt the pipeline with a clear message).
12. Set and enforce memory and time budgets per stage; fail loudly if a stage exceeds its budget.

## Reproducibility
13. Pin tool and library versions; record environment metadata (tool versions, OS, hardware) alongside output data.
14. Store raw input data in an immutable location (`data/raw/`); never modify raw data in place.
15. Make random operations deterministic by seeding all random number generators with a documented, committed seed.

## Performance
16. Partition large datasets and process in parallel where stages are independent; document the partitioning strategy.
17. Profile memory usage for large-data stages; prefer streaming / chunked processing over loading entire datasets into memory.
18. Use columnar formats (Parquet, Arrow) for intermediate storage when downstream consumers support it; fall back to compressed TSV/CSV for interoperability.
