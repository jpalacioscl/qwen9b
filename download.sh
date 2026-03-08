#!/usr/bin/env bash
set -euo pipefail

# ── Configuracion ──────────────────────────────────────────────
REPO="unsloth/Qwen3.5-9B-GGUF"
FILE="Qwen3.5-9B-Q4_K_M.gguf"
DEST="./models"
# ───────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/.venv/bin/activate"

mkdir -p "$DEST"

echo "Descargando $FILE desde $REPO ..."
hf download "$REPO" "$FILE" \
  --local-dir "$DEST"

echo "Modelo guardado en $DEST/$FILE"
