#!/usr/bin/env bash

usage() {
  echo "Uso: $0 --9b | --27b | --35b | --122b | --omni"
  echo "  --9b    Usa Qwen3.5-9B"
  echo "  --27b   Usa Qwen3.5-27B"
  echo "  --35b   Usa Qwen3.5-35B-A3B"
  echo "  --122b  Usa Qwen3.5-122B-A10B"
  echo "  --omni  Usa OmniCoder-9B"
  exit 1
}

if [ $# -eq 0 ]; then
  usage
fi

case "$1" in
  --9b)   MODEL="qwen3.5-9b" ;;
  --27b)  MODEL="qwen3.5-27b" ;;
  --35b)  MODEL="qwen3.5-35b-a3b" ;;
  --122b) MODEL="qwen3.5-122b-a10b" ;;
  --omni) MODEL="omnicoder-9b" ;;
  *)      usage ;;
esac

ANTHROPIC_BASE_URL=http://localhost:8080 ANTHROPIC_API_KEY=sk-no-key-required claude --model "$MODEL" --allow-dangerously-skip-permissions
