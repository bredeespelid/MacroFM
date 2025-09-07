# MacroFM (skeleton)
This is a minimal folder skeleton. Fill it with your own code and vendored PFN repo.

## Expected layout
- `scripts/` — place your shell scripts (setup, train, eval).
- `macrofm/data/` — your Python data utilities.
- `macrofm/configs/` — your configuration files.
- `vendor/timesfm_fin/` — **place a full vendored copy** of PFN's repo here (include `src/`, `configs/`, and `LICENSE`).
- `artifacts/` — your training/validation CSVs (`series_id,timestamp,value`).
- `work_h1/` — outputs (checkpoints, logs).
