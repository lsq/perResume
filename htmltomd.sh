#!/usr/bin/env bash


curl -s https://linuxhandbook.com/sed-reference-guide > sed-reference-guide.html
pandoc -f html -t markdown -o sed-reference-guide.md sed-reference-guide.html
pandoc -t html -f markdown -o sed-reference-guide1.html sed-reference-guide.md 
[ -f sed-reference-guide.md ] && mv  sed-reference-guide.md $APPVEYOR_BUILD_FOLDER/$APPVEYOR_JOB_ID/
[ -f sed-reference-guide1.html ] && mv  sed-reference-guide1.html $APPVEYOR_BUILD_FOLDER/$APPVEYOR_JOB_ID/
