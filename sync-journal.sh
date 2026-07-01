#!/bin/bash
rsync -av --delete \
  "/mnt/e/Dokumenty/PersonalProjects/Obsidian/Robin/Art Journal/" \
  "/home/robinp/code/art-site/content/journal/" \
  --exclude="_Templates/" \
  --exclude=".obsidian/"
