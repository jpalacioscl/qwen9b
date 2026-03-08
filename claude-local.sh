#!/usr/bin/env bash

usage() {
  echo "Uso: $0 --9b | --35b"
  echo "  --9b   Usa Qwen3.5-9B"
  echo "  --35b  Usa Qwen3.5-35B-A3B"
  exit 1
}

if [ $# -eq 0 ]; then
  usage
fi

case "$1" in
  --9b)  MODEL="qwen3.5-9b" ;;
  --35b) MODEL="qwen3.5-35b-a3b" ;;
  *)     usage ;;
esac

ANTHROPIC_BASE_URL=http://localhost:8080 ANTHROPIC_API_KEY=sk-no-key-required claude --model "$MODEL" --allow-dangerously-skip-permissions
