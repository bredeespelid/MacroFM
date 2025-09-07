#!/usr/bin/env bash
set -euo pipefail
if [ ! -x /usr/local/bin/micromamba ]; then
  wget -qO /tmp/micromamba.tar.bz2 https://micro.mamba.pm/api/micromamba/linux-64/latest
  tar -xjf /tmp/micromamba.tar.bz2 -C /usr/local/bin --strip-components=1 bin/micromamba
fi
/usr/local/bin/micromamba create -y -n tfm311 python=3.11
/usr/local/bin/micromamba run -n tfm311 python -m pip -q install --upgrade pip
/usr/local/bin/micromamba run -n tfm311 python -m pip -q install -r requirements_colab.txt
echo "✔ Env tfm311 OK"
