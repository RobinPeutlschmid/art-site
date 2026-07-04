#!/bin/bash
set -e

echo "Syncing portfolio from Obsidian..."
rsync -av --delete \
  "/mnt/e/Dokumenty/PersonalProjects/Obsidian/Robin/Portfolio/" \
  "/home/robinp/code/art-site/content/portfolio/" \
  --exclude="_Templates/" \
  --exclude=".obsidian/" \
  --exclude="_index.md"

echo "Staging changes..."
cd /home/robinp/code/art-site
git add content/portfolio/

if git diff --cached --quiet; then
  echo "No changes to commit."
else
  echo "Committing..."
  git commit -m "Portfolio update: $(date '+%Y-%m-%d %H:%M')"
  echo "Pushing..."
  git push
  echo "Done — site will deploy in ~1 minute."
fi
