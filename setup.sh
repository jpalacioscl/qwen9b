#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV="$SCRIPT_DIR/.venv"

# ── Entorno virtual (para hf cli y chat.py) ───────────────────
echo "Creando entorno virtual en $VENV ..."
python3 -m venv "$VENV"
source "$VENV/bin/activate"
pip install --quiet huggingface_hub[cli] openai

# ── Compilar llama.cpp desde source ───────────────────────────
echo "Clonando y compilando llama.cpp ..."
cd "$SCRIPT_DIR"
if [ ! -d "llama.cpp" ]; then
  git clone https://github.com/ggml-org/llama.cpp
fi
rm -rf llama.cpp/build
cmake llama.cpp -B llama.cpp/build \
  -DGGML_CUDA=ON \
  -DCUDAToolkit_ROOT=/usr/local/cuda
cmake --build llama.cpp/build --config Release -j

echo ""
echo "Listo. Activa el entorno con: source $VENV/bin/activate"
