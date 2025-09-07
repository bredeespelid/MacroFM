#!/usr/bin/env bash
set -euo pipefail

if [ ! -x /usr/local/bin/micromamba ]; then
  wget -qO /tmp/micromamba.tar.bz2 https://micro.mamba.pm/api/micromamba/linux-64/latest
  tar -xjf /tmp/micromamba.tar.bz2 -C /usr/local/bin --strip-components=1 bin/micromamba
fi

/usr/local/bin/micromamba create -y -n tfm311 python=3.11
# Kjerne via conda: sikrer at numpy/pandas finnes uten hjul-trøbbel
/usr/local/bin/micromamba install -y -n tfm311 pandas=2.1.4 numpy=1.26.4

# Resten via pip (inne i miljøet)
USR_REQ="$(pwd)/requirements_colab.txt"
/usr/local/bin/micromamba run -n tfm311 python -m pip -q install --upgrade pip
/usr/local/bin/micromamba run -n tfm311 pip install -r "$USR_REQ" --no-cache-dir

echo "✔ Env tfm311 OK"
