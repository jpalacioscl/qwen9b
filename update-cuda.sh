#!/usr/bin/env bash
set -euo pipefail

# ── Actualizar CUDA Toolkit a 13.1 en Ubuntu 24.04 x86_64 ────
# Fuente: https://developer.nvidia.com/cuda-downloads

echo "=== Eliminando CUDA viejo ==="
sudo apt-get remove --purge -y 'cuda*' 'nvidia-cuda-toolkit*' || true
sudo apt-get autoremove -y

echo ""
echo "=== Agregando repositorio NVIDIA CUDA 13.1 ==="
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
rm -f cuda-keyring_1.1-1_all.deb
sudo apt-get update

echo ""
echo "=== Instalando CUDA Toolkit 13 ==="
sudo apt-get install -y cuda-toolkit

echo ""
echo "=== Configurando PATH ==="
CUDA_PATH='export PATH=/usr/local/cuda/bin:$PATH'
CUDA_LD='export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH'

if ! grep -q '/usr/local/cuda/bin' ~/.bashrc; then
  echo "$CUDA_PATH" >> ~/.bashrc
  echo "$CUDA_LD" >> ~/.bashrc
  echo "Agregado CUDA al PATH en ~/.bashrc"
fi

export PATH=/usr/local/cuda/bin:$PATH

echo ""
echo "=== Verificando instalacion ==="
nvcc --version

echo ""
echo "Listo. Cierra y abre la terminal, o ejecuta: source ~/.bashrc"
