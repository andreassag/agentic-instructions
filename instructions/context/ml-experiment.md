# ML Experiment Project Guidelines

## Reproducibility
1. Set all random seeds at the entry point of every script and document which libraries require seeding (`random`, `numpy`, `torch`, `tf`, `jax`).
2. Pin all dependency versions in a lock file (`uv.lock`, `renv.lock`, `conda-lock.yml`); include the CUDA/cuDNN version in environment metadata.
3. Record hardware context alongside results: CPU/GPU model, RAM, driver version. Include in experiment logs or a `environment.json` artifact.
4. Use deterministic operations where possible (`torch.backends.cudnn.deterministic = True`); document when non-determinism is accepted and why.

## Data Discipline
5. Never modify raw data in place; all transformations produce new, versioned derived datasets.
6. Compute and log train/validation/test split sizes and class distributions at the start of every training run.
7. Apply all preprocessing and augmentation via a reproducible, versioned pipeline — never ad-hoc in a notebook.
8. Prevent data leakage: fit scalers, encoders, and imputers only on the training split; apply to val/test without refit.

## Experiment Tracking
9. Log every experiment to an experiment tracker (MLflow, Weights & Biases, or equivalent): hyperparameters, metrics (train and val), dataset version, code commit hash, and runtime.
10. Never overwrite a completed experiment run; create a new run for every configuration change.
11. Log metrics at each epoch/step, not just at the end; this allows early-stopping analysis and learning curve comparison.
12. Store the final model artifact with the run that produced it; include the training config and data split as artifact metadata.

## Model Checkpointing
13. Save checkpoints at regular intervals and on validation metric improvement; retain at least the last `k` checkpoints plus the best.
14. Name checkpoint files with the run ID and step: `run_abc123_epoch_10_val_f1_0.87.ckpt`.
15. Include a `model_card.md` with every released model: intended use, training data, evaluation metrics, known limitations, and how to reproduce.

## Evaluation
16. Evaluate on a held-out test set only once, at the very end, after all hyperparameter decisions are finalized; never tune on the test set.
17. Report confidence intervals or standard deviation over multiple seeds for any metric presented as a comparison.
18. Include baseline comparisons (random, majority class, simple heuristic) alongside model metrics.
