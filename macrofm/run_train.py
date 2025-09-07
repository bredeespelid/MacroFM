import os, subprocess, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT / "vendor" / "timesfm_fin"  # vendoret PFN-kode
WORK = ROOT / "work_h1"
DATA = ROOT / "artifacts"
CFG  = ROOT / "macrofm" / "configs" / "fine_tuning_h1.py"

def main():
    WORK.mkdir(exist_ok=True, parents=True)
    DATA.mkdir(exist_ok=True, parents=True)

    env = os.environ.copy()
    env["PYTHONPATH"] = f"{REPO.as_posix()}:" + env.get("PYTHONPATH","")

    cmd = [
        sys.executable, (REPO/"src"/"main.py").as_posix(),
        "--workdir", WORK.as_posix(),
        "--config",  CFG.as_posix(),
        "--dataset_path", DATA.as_posix()
    ]
    subprocess.run(cmd, check=True, cwd=REPO.as_posix(), env=env)

if __name__ == "__main__":
    main()
