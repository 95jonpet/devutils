#!/bin/bash
#
# Print a somewhat funny meme.

set -euo pipefail

# Print a fortune using a random cowsay cow.
cow="$(find /usr/share/cowsay/cows -maxdepth 1 -name "*.cow" | shuf -n1)"
fortune | cowsay -f "${cow}" | lolcat --seed 0 --spread 1.0
