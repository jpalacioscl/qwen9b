#!/usr/bin/env python3
"""Chat interactivo con el modelo local via API compatible con OpenAI."""

import json
import urllib.request
from pathlib import Path

SERVER = "http://localhost:8080"
PROMPT_FILE = Path(__file__).parent / "prompt.txt"


def load_system_prompt():
    if PROMPT_FILE.exists():
        return PROMPT_FILE.read_text().strip()
    return "Eres un asistente util."


def chat_completion(messages):
    data = json.dumps({
        "messages": messages,
        "temperature": 0.7,
        "max_tokens": 2048,
        "stream": False,
    }).encode()

    req = urllib.request.Request(
        f"{SERVER}/v1/chat/completions",
        data=data,
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req) as resp:
        body = json.loads(resp.read())
    return body["choices"][0]["message"]["content"]


def main():
    system_prompt = load_system_prompt()
    messages = [{"role": "system", "content": system_prompt}]

    print("Chat con Qwen3.5-9B  (escribe 'salir' para terminar)\n")

    while True:
        try:
            user_input = input("Tu: ").strip()
        except (KeyboardInterrupt, EOFError):
            print("\nAdios!")
            break

        if not user_input:
            continue
        if user_input.lower() in ("salir", "exit", "quit"):
            print("Adios!")
            break

        messages.append({"role": "user", "content": user_input})

        try:
            reply = chat_completion(messages)
        except Exception as e:
            print(f"Error: {e}")
            messages.pop()
            continue

        messages.append({"role": "assistant", "content": reply})
        print(f"IA: {reply}\n")


if __name__ == "__main__":
    main()
