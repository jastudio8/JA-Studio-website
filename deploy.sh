#!/bin/bash
# Deploy JAS folder to a new private GitHub repo.
# Uses the gh CLI binary you already downloaded to ~/Downloads/
# Run from this folder:   bash deploy.sh

set -e

cd "$(dirname "$0")"

REPO_NAME="JA-Studio-website"
GH="$HOME/Downloads/gh_2.92.0_macOS_amd64/bin/gh"

echo "==> Checking for gh binary at: $GH"
if [ ! -x "$GH" ]; then
  echo "ERROR: gh binary not found or not executable at $GH"
  echo "Looking for any gh binary in Downloads..."
  find "$HOME/Downloads" -maxdepth 4 -name gh -type f 2>/dev/null
  exit 1
fi
echo "Found: $("$GH" --version | head -1)"

echo "==> Cleaning any partial .git/ from a previous attempt"
rm -rf .git

echo "==> Checking GitHub auth"
if ! "$GH" auth status >/dev/null 2>&1; then
  echo "Not logged in. Starting 'gh auth login' (choose: GitHub.com -> HTTPS -> Yes -> Login with browser)..."
  "$GH" auth login
fi
echo "Auth OK."

echo "==> Initializing git repo"
git init -b main
git config user.email "hello@jessandersonstudio.com"
git config user.name "Jess Anderson"

echo "==> Staging files (ES Park Trial/ excluded via .gitignore)"
git add .
git status --short

echo "==> Creating initial commit"
git commit -m "Initial commit"

echo "==> Creating private repo '$REPO_NAME' and pushing"
"$GH" repo create "$REPO_NAME" --private --source=. --remote=origin --push

echo ""
echo "==> Done! Repo URL:"
"$GH" repo view --json url -q .url
