#!/bin/bash
set -e

echo "Syncing journal from Obsidian..."
rsync -av --delete \
  "/mnt/e/Dokumenty/PersonalProjects/Obsidian/Robin/Art Journal/" \
  "/home/robinp/code/art-site/content/journal/" \
  --exclude="_Templates/" \
  --exclude=".obsidian/"

echo "Staging changes..."
cd /home/robinp/code/art-site
git add content/journal/

if git diff --cached --quiet; then
  echo "No changes to commit."
else
  echo "Committing..."
  git commit -m "Journal update: $(date '+%Y-%m-%d %H:%M')"
  echo "Pushing..."
  git push
  echo "Done — site will deploy in ~1 minute."
fi
