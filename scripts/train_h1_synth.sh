#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

# Sjekk at filene finnes
test -f artifacts/train_long.csv || { echo "Mangler artifacts/train_long.csv"; exit 1; }
test -f artifacts/val_long.csv   || { echo "Mangler artifacts/val_long.csv"; exit 1; }
/usr/local/bin/micromamba run -n tfm311 python macrofm/run_train.py
