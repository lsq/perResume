#!/usr/bin/env bash

html_f="shell.html"
markdown_f="shell.md"
#curl -s https://linuxhandbook.com/sed-reference-guide > sed-reference-guide.html
pandoc -f html -t markdown -o $markdown_f $html_f
#pandoc -t html -f markdown -o sed-reference-guide1.html sed-reference-guide.md 
[ -f "$markdown_f" ] && mv $markdown_f  $APPVEYOR_BUILD_FOLDER/$APPVEYOR_JOB_ID/
#[ -f sed-reference-guide1.html ] && mv  sed-reference-guide1.html $APPVEYOR_BUILD_FOLDER/$APPVEYOR_JOB_ID/
