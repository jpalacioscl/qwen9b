#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/.venv/bin/activate"

DEST="./models"
mkdir -p "$DEST"

usage() {
  echo "Uso: $0 --9b | --35b"
  echo "  --9b   Descarga Qwen3.5-9B  (Q4_K_M)"
  echo "  --35b  Descarga Qwen3.5-35B-A3B (Q4_K_M)"
  exit 1
}

if [ $# -eq 0 ]; then
  usage
fi

case "$1" in
  --9b)
    REPO="unsloth/Qwen3.5-9B-GGUF"
    FILE="Qwen3.5-9B-Q4_K_M.gguf"
    ;;
  --35b)
    REPO="unsloth/Qwen3.5-35B-A3B-GGUF"
    FILE="Qwen3.5-35B-A3B-Q4_K_M.gguf"
    ;;
  *)
    usage
    ;;
esac

echo "Descargando $FILE desde $REPO ..."
hf download "$REPO" "$FILE" \
  --local-dir "$DEST"

echo "Modelo guardado en $DEST/$FILE"
