#!/usr/bin/env bash
set -euo pipefail
OUT="$HOME/.config/nvim/scripts/verify-db.log"
: > "$OUT"
TS="$(date --iso-8601=seconds 2>/dev/null || date '+%Y-%m-%dT%H:%M:%S')"
echo "verify-db run at $TS" >> "$OUT"

NVIM_INIT="$HOME/.config/nvim/init.lua"
echo "Using init: $NVIM_INIT" >> "$OUT"

# 1) headless start to check for immediate Lua errors (safe)
echo "=== headless nvim startup check ===" >> "$OUT"
if command -v nvim >/dev/null 2>&1; then
  nvim --headless -u "$NVIM_INIT" -c 'echo "nvim_startup_ok"' -c 'qa!' >> "$OUT" 2>&1 || echo "nvim startup returned non-zero — check logs" >> "$OUT"
else
  echo "nvim not found in PATH" >> "$OUT"
fi

# 2) check whether psql and mongosh are on PATH
echo "=== executables ===" >> "$OUT"
for exe in psql mongosh node pnpm; do
  if command -v "$exe" >/dev/null 2>&1; then
    echo "$exe: found at $(command -v $exe)" >> "$OUT"
  else
    echo "$exe: NOT FOUND" >> "$OUT"
  fi
done

# 3) check for mason packages folder presence (js debug etc.)
MASON_PACKAGES="$(python - "$HOME" <<'PY'
import os,sys
home=sys.argv[1]
stdpath=os.path.join(home,'.local','share','nvim')
mason=os.path.join(stdpath,'mason','packages')
print(mason)
PY
)"
echo "mason packages path: $MASON_PACKAGES" >> "$OUT"
if [ -d "$MASON_PACKAGES" ]; then
  echo "mason packages: $(ls -1 "$MASON_PACKAGES" 2>/dev/null | sed -n '1,50p')" >> "$OUT"
else
  echo "mason packages directory not present" >> "$OUT"
fi

# 4) Check that our lua/db module can be required inside nvim headless
echo "=== lua.module require check ===" >> "$OUT"
if command -v nvim >/dev/null 2>&1; then
  nvim --headless -u "$NVIM_INIT" -c 'lua local ok, mod = pcall(require,"db"); if ok then print("db_module_ok") else print("db_module_error", mod) end' -c qa! >> "$OUT" 2>&1 || echo "failed requiring module" >> "$OUT"
else
  echo "nvim not available to test require('db')" >> "$OUT"
fi

echo "verify-db finished" >> "$OUT"