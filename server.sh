#!/usr/bin/env bash
set -euo pipefail

# ── Configuracion ──────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MODEL="$SCRIPT_DIR/models/Qwen3.5-9B-Q4_K_M.gguf"
HOST="0.0.0.0"
PORT="8080"
CTX=32768
GPU_LAYERS=99   # poner 0 si no tienes GPU
# ───────────────────────────────────────────────────────────────

LLAMA_SERVER="$SCRIPT_DIR/llama.cpp/build/bin/llama-server"

if [ ! -f "$LLAMA_SERVER" ]; then
  echo "Error: llama-server no encontrado. Ejecuta ./setup.sh primero."
  exit 1
fi

echo "Levantando servidor en http://$HOST:$PORT ..."
"$LLAMA_SERVER" \
  --model "$MODEL" \
  --host "$HOST" \
  --port "$PORT" \
  --ctx-size "$CTX" \
  --n-gpu-layers "$GPU_LAYERS"
