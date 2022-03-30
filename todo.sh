#!/bin/bash
#
# Manage todo items.

set -euo pipefail

TODO_FILE="${HOME}/.todo"

#######################################
# Print the program's help.
# Arguments:
#   None
#######################################
print_help() {
  cli_name="${0##*/}"
  cat <<EOF
Usage: ${cli_name} [command]

Commands:
  add       Add new todo items.
  done      Mark todo items as completed.
  list      Print all todo items.
  message   Print a formatted message of all items.
  *         Display this help.
EOF
}

#######################################
# Add todo items.
# Globals:
#   TODO_FILE
# Arguments:
#   Items to add, strings.
#######################################
add_items() {
  for arg in "$@"; do
    echo "[ ] ${arg}" >> "${TODO_FILE}"
  done
}

#######################################
# Mark todo items as completed.
# Globals:
#   TODO_FILE
# Arguments:
#   Items to mark as complete, indices.
#######################################
complete_items() {
  if [[ ! -f "${TODO_FILE}" ]]; then
    return
  fi

  # Change "[ ]" to "[x]" for each item indexed by one of the arguments.
  for i in "$@"; do
    sed -i "${i}s/^\[ \]/[x]/" "${TODO_FILE}"
  done
}

#######################################
# List all todo items.
# Globals:
#   TODO_FILE
# Arguments:
#   None
#######################################
list_items() {
  if [[ ! -f "${TODO_FILE}" ]]; then
    return
  fi

  i=1
  while read -r item; do
    printf "% 2d" "${i}"
    echo ". ${item}"
    i=$((i + 1))
  done < "${TODO_FILE}"
}

#######################################
# Print a message of compelted items.
# Globals:
#   TODO_FILE
# Arguments:
#   None
#######################################
print_message() {
  if [[ ! -f "${TODO_FILE}" ]]; then
    return
  fi

  # Add a decorative message header.
  echo "TODO: Edit this message."
  echo

  # Add each completed item as a bullet point. Items are indented with a single
  # space, and vertically separated by a newline.
  while read -r item; do
    if [[ "${item:0:4}" == "[x] " ]]; then
      echo " - ${item:4}"
      echo
    fi

  done < "${TODO_FILE}"
}

cmd_arg="${1:-}"
shift 1

case "${cmd_arg}" in
  add) add_items "$@" ;;
  done) complete_items "$@" ;;
  list) list_items "$@" ;;
  message) print_message "$@" ;;
  *) print_help ;;
esac
