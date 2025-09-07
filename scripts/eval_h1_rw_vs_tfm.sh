#!/usr/bin/env bash
set -euo pipefail

# Sørg for at vendoret PFN-repo er på Python-path
export PYTHONPATH="$(pwd)/vendor/timesfm_fin:${PYTHONPATH:-}"

/usr/local/bin/micromamba run -n tfm311 python - <<'PY'
import os, sys
from pathlib import Path
# Sikkerhet: legg til vendoret path dersom miljøvariabel ikke fanges
repo_path = Path("vendor/timesfm_fin").resolve()
if str(repo_path) not in sys.path:
    sys.path.insert(0, str(repo_path))

import numpy as np, pandas as pd
from timesfm_fin.infer import load_model, forecast

# Syntetisk serie (samme konstruksjon som i trening)
idx = pd.period_range("2000Q1", periods=80, freq="Q").to_timestamp(how="end")
t = np.arange(80)
y = 0.02*t + 0.15*np.sin(2*np.pi*t/8) + np.random.default_rng(7).normal(0,0.03,80)
s = pd.Series(y, index=idx, name="log_nok_eur")

# Finn checkpoint
ckpts = sorted(Path("work_h1").rglob("*.ckpt"))
if not ckpts:
    raise SystemExit("Ingen checkpoints i work_h1/. Kjør scripts/train_h1_synth.sh først.")
ckpt = str(ckpts[-1])

# 1Q-prognose fra finetunet modell
model = load_model(ckpt)
CONTEXT_Q = 32
ctx = s.to_numpy()[-CONTEXT_Q:]
tfm_yhat = float(forecast(model, context=ctx, horizon=1)[0])

# Random Walk baseline
rw_yhat  = float(ctx[-1])

future_date = (s.index[-1] + pd.offsets.QuarterEnd(1))
df = pd.DataFrame({
    "last_obs":[ctx[-1]],
    "tfm_finetuned_h1":[tfm_yhat],
    "rw_forecast":[rw_yhat],
    "diff_tfm_minus_rw":[tfm_yhat - rw_yhat],
}, index=[future_date])

print(df)
PY
