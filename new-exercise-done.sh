#!/usr/bin/bash
set -euo pipefail
git add .
git status
git commit -m "$(basename "$(pwd)")"
# git push
