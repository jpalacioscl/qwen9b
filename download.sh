#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/.venv/bin/activate"

DEST="./models"
mkdir -p "$DEST"

usage() {
  echo "Uso: $0 --9b | --27b | --35b | --122b"
  echo "  --9b    Descarga Qwen3.5-9B  (Q4_K_M)"
  echo "  --27b   Descarga Qwen3.5-27B (Q4_K_M, ~16 GB)"
  echo "  --35b   Descarga Qwen3.5-35B-A3B (Q4_K_M)"
  echo "  --122b  Descarga Qwen3.5-122B-A10B (Q3_K_M, ~56 GB)"
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
  --27b)
    REPO="unsloth/Qwen3.5-27B-GGUF"
    FILE="Qwen3.5-27B-Q4_K_M.gguf"
    ;;
  --35b)
    REPO="unsloth/Qwen3.5-35B-A3B-GGUF"
    FILE="Qwen3.5-35B-A3B-Q3_K_M.gguf"
    ;;
  --122b)
    REPO="unsloth/Qwen3.5-122B-A10B-GGUF"
    FILE="Q3_K_M"
    SPLIT=true
    ;;
  *)
    usage
    ;;
esac

if [ "${SPLIT:-false}" = true ]; then
  echo "Descargando directorio $FILE desde $REPO (~56 GB, 3 archivos) ..."
  hf download "$REPO" \
    --include "$FILE/*" \
    --local-dir "$DEST"
  echo "Modelo guardado en $DEST/$FILE/"
else
  echo "Descargando $FILE desde $REPO ..."
  hf download "$REPO" "$FILE" \
    --local-dir "$DEST"
  echo "Modelo guardado en $DEST/$FILE"
fi
