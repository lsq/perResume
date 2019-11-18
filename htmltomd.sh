#!/usr/bin/env bash


curl -s https://linuxhandbook.com/sed-reference-guide > sed-reference-guide.html
pandoc -f html -t markdown -o sed-reference-guide.md sed-reference-guide.html
