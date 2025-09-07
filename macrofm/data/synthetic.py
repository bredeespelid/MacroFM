import numpy as np
import pandas as pd

def make_quarterly_synth(T: int = 80, seed: int = 7) -> pd.Series:
    idx = pd.period_range("2000Q1", periods=T, freq="Q").to_timestamp(how="end")
    rng = np.random.default_rng(seed)
    t = np.arange(T)
    y = 0.02*t + 0.15*np.sin(2*np.pi*t/8) + rng.normal(0, 0.03, T)
    return pd.Series(y, index=idx, name="log_nok_eur")
