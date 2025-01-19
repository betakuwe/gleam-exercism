#!/usr/bin/bash
set -euo pipefail
git add .
git status
COMMIT_MSG="$(basename "$(pwd)")"
echo "Commit with message: $COMMIT_MSG"
read -rp "Proceed?(y/n)" PROCEED
if [[ $PROCEED = "y" ]]; then
	git commit -m "$COMMIT_MSG"
	git push
fi
