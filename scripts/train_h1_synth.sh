#!/usr/bin/env bash
set -euo pipefail

# 1) Lag syntetisk datasett i long-format (train/val)
/usr/local/bin/micromamba run -n tfm311 python - <<'PY'
from pathlib import Path
import pandas as pd
import numpy as np

def make_quarterly_synth(T: int = 80, seed: int = 7):
    idx = pd.period_range("2000Q1", periods=T, freq="Q").to_timestamp(how="end")
    rng = np.random.default_rng(seed)
    t = np.arange(T)
    y = 0.02*t + 0.15*np.sin(2*np.pi*t/8) + rng.normal(0, 0.03, T)
    return pd.Series(y, index=idx, name="log_nok_eur")

ROOT = Path(".")
ART = ROOT / "artifacts"; ART.mkdir(exist_ok=True)
s = make_quarterly_synth(80)
train = s.loc[: "2018-12-31"]; val = s.loc["2019-03-31":]

pd.DataFrame({"series_id":"NOK_EUR","timestamp":train.index,"value":train.values}).to_csv(ART/"train_long.csv", index=False)
pd.DataFrame({"series_id":"NOK_EUR","timestamp":val.index,"value":val.values}).to_csv(ART/"val_long.csv", index=False)
print("Wrote", ART/"train_long.csv", ART/"val_long.csv")
PY

# 2) Kjør finetuning via din vendorede PFN-kopi (setter PYTHONPATH i run_train.py)
/usr/local/bin/micromamba run -n tfm311 python macrofm/run_train.py
