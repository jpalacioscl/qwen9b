#!/usr/bin/env bash
set -euo pipefail

# ── Configuracion ──────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOST="0.0.0.0"
PORT="8080"
# ───────────────────────────────────────────────────────────────

LLAMA_SERVER="$SCRIPT_DIR/llama.cpp/build/bin/llama-server"
export LD_LIBRARY_PATH="$SCRIPT_DIR/llama.cpp/build/bin:${LD_LIBRARY_PATH:-}"

if [ ! -f "$LLAMA_SERVER" ]; then
  echo "Error: llama-server no encontrado. Ejecuta ./setup.sh primero."
  exit 1
fi

usage() {
  echo "Uso: $0 --9b | --35b | --122b"
  echo "  --9b    Inicia con Qwen3.5-9B  (todas las capas en GPU)"
  echo "  --35b   Inicia con Qwen3.5-35B-A3B (expertos offload a RAM)"
  echo "  --122b  Inicia con Qwen3.5-122B-A10B (expertos offload a RAM)"
  exit 1
}

if [ $# -eq 0 ]; then
  usage
fi

case "$1" in
  --9b)
    MODEL="$SCRIPT_DIR/models/Qwen3.5-9B-Q4_K_M.gguf"
    CTX=32768
    GPU_LAYERS=99
    EXTRA_ARGS=()
    ;;
  --35b)
    MODEL="$SCRIPT_DIR/models/Qwen3.5-35B-A3B-Q3_K_M.gguf"
    CTX=225280
    GPU_LAYERS=99
    # Offload de todos los expertos MoE a RAM
    EXTRA_ARGS=(-ot "\.ffn_.*_exps\.weight=CPU")
    ;;
  --122b)
    MODEL="$SCRIPT_DIR/models/Q3_K_M/Qwen3.5-122B-A10B-Q3_K_M-00001-of-00003.gguf"
    CTX=8192
    GPU_LAYERS=20
    # Offload de todos los expertos MoE a RAM
    EXTRA_ARGS=(-ot "\.ffn_.*_exps\.weight=CPU")
    ;;
  *)
    usage
    ;;
esac

if [ ! -f "$MODEL" ]; then
  echo "Error: modelo no encontrado en $MODEL"
  echo "Ejecuta ./download.sh $1 primero."
  exit 1
fi

echo "Levantando servidor en http://$HOST:$PORT ..."
echo "Modelo: $(basename "$MODEL")"
"$LLAMA_SERVER" \
  --model "$MODEL" \
  --host "$HOST" \
  --port "$PORT" \
  --ctx-size "$CTX" \
  --n-gpu-layers "$GPU_LAYERS" \
  --jinja \
  --reasoning-format deepseek \
  "${EXTRA_ARGS[@]}"
