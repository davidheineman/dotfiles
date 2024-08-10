#!/bin/bash

MODEL="gpt-4o-mini" # "gpt-3.5-turbo"
PROMPT="$*"

if [ -z "$OPENAI_API_KEY" ]; then
  echo "Error: OPENAI_API_KEY is not set in the environment."
  echo "Please set it using 'export OPENAI_API_KEY=your_api_key' and try again."
  exit 1
fi

if [ "$#" -eq 0 ]; then
  echo "Usage: chat <message>"
  exit 1
fi

RESPONSE=$(curl -s https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "model": "'"$MODEL"'",
    "messages": [
        {"role": "system", "content": "You are a zsh assistant. If applicable, output a unix command wrapped in ```. Only propose one command at a time."},
        {"role": "user", "content": "'"$PROMPT"'"}
    ],
    "max_tokens": 200
  }')

# Parse response
RESPONSE=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')

echo -e "\033[34m$RESPONSE\033[0m"

# Run the extracted command if it exists
COMMAND=$(echo "$RESPONSE" | sed -n '/^```/,/^```/p' | sed '1d;$d')

if [ ! -z "$COMMAND" ]; then
  echo -en "\033[95m$COMMAND\033[0m (Y/n) "
  read CONFIRMATION
  if [[ "$CONFIRMATION" =~ ^[Yy]$ ]] || [ -z "$CONFIRMATION" ]; then
    eval "$COMMAND"
  fi
fi

# TODO: allow increasing max tokens as a parameter
# TODO: get current terminal for context (history | tail -n 2)
# TODO: Add "help" command

# {
#   "id": "chatcmpl-9umI7PPrncItKOmBNGIQBpN0YmzXT",
#   "object": "chat.completion",
#   "created": 1723319027,
#   "model": "gpt-3.5-turbo-0125",
#   "choices": [
#     {
#       "index": 0,
#       "message": {
#         "role": "assistant",
#         "content": "Hello! How can I assist you today?",
#         "refusal": null
#       },
#       "logprobs": null,
#       "finish_reason": "stop"
#     }
#   ],
#   "usage": {
#     "prompt_tokens": 8,
#     "completion_tokens": 9,
#     "total_tokens": 17
#   },
#   "system_fingerprint": null
# }

# Install:
# brew install jq
# sudo cp chat.sh /usr/local/bin/chat && source ~/.zshrc