#!/bin/bash

# Install:
# sudo cp acl.sh /usr/local/bin/acl && source ~/.zshrc

# TODO: allow passing the abstracts forward through pipeing so I can run
#   acl <query> | chat summarize this
# TODO: filter by year, conference
# TODO: check if the backend servie is running, if not run it

if [ "$#" -eq 0 ]; then
  echo "Usage: acl <search query>"
  exit 1
fi

PROMPT="$*"
# PROMPT=$(echo "$*" | sed 's/ /%20/g') # TODO: Allow arbitrary strings

RESPONSE=$(curl -s \
    "https://acl-search.fly.dev/api/search" \
    --get \
    --data-urlencode "start_year=2020" \
    --data-urlencode "end_year=2024" \
    --data-urlencode "venue_type=main" \
    --data-urlencode "venue_type=short" \
    --data-urlencode "query=$PROMPT")


if [ -z "$RESPONSE" ]; then
  echo -e "\033[31mno results found\033[0m"
  exit 1
fi

# Parse response
# echo "$RESPONSE" | jq -r '.[]'
# RESPONSE=$(echo "$RESPONSE" | jq -r '.[].url')

# Print results
GREY='\033[0;30m'
PINK='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

all_results=$(echo "$RESPONSE" | jq -r '.[] | [.url, .venue_type, .year, .title, .abstract] | @tsv')

ml1=$(echo "$all_results" | awk -F'\t' '{ if (length($1) > max) max = length($1) } END { print max }')
ml2=$(echo "$all_results" | awk -F'\t' '{ if (length($2) > max) max = length($2) } END { print max }')
ml3=$(echo "$all_results" | awk -F'\t' '{ if (length($2) > max) max = length($2) } END { print max }')
ml4=$(echo "$all_results" | awk -F'\t' '{ if (length($4) > max) max = length($3) } END { print max }')

echo "$all_results" | while IFS=$'\t' read -r year venue_type url title abstract; do
    printf "${GREY}%-*s${RESET} ${PINK}%-*s${RESET} ${PINK}%-*s${RESET} ${BLUE}%s${RESET}\n" "$ml1" "$year" "$ml2" "$venue_type" "$ml3" "$url" "$title"
done