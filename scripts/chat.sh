#!/bin/bash

# Install:
# sudo cp chat.sh /usr/local/bin/chat && source ~/.zshrc

# TODO: allow increasing max tokens as a parameter
# TODO: get current terminal for context (history | tail -n 2)
# TODO: change context if this is a bash/zsh terminal
# TODO: Add "help" command

MODEL="gpt-4o-mini" # "gpt-3.5-turbo"

if [ -t 0 ]; then
    # No piped input, use command-line arguments
    PROMPT="$*"
else
    # Piped input, prepend command-line arguments
    PROMPT="$(cat -) $*"
fi

PROMPT=$(echo "$PROMPT" | tr '\n' ' ')
PROMPT=$(echo "$PROMPT" | sed 's/\x1b\[[0-9;]*m//g')

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
        {"role": "system", "content": "You are a zsh assistant on a macos system. If applicable, output a unix command wrapped in ```. Only propose one command at a time."},
        {"role": "user", "content": "'"$PROMPT"'"}
    ],
    "max_tokens": 200
  }')

# Check if the API returned an error
ERROR=$(echo "$RESPONSE" | jq -r '.error.message')
if [ "$ERROR" != "null" ]; then
    echo "$RESPONSE"
    echo -e "\033[31m$ERROR\033[0m"
    exit 1
fi

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
