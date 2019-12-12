#!/usr/bin/env bash
set -e
drfile="geckodriver-linux.tar.gz"
wget -c -o $drfile https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz
tar xf $drfile && sudo cp geckodriver /usr/bin
geckodriver &
# [1] 16010
# % 1491834109194   geckodriver     INFO    Listening on 127.0.0.1:4444
curl -d '{"capabilities": {"alwaysMatch": {"acceptInsecureCerts": true}}}' http://localhost:4444/session
# {"sessionId":"d4605710-5a4e-4d64-a52a-778bb0c31e00","value":{"XULappId":"{ec8030f7-c20a-464f-9b0e-13a3a9e97384}","acceptSslCerts":false,"appBuildId":"20160913030425","browserName":"firefox","browserVersion":"51.0a1","command_id":1,"platform":"LINUX","platformName":"linux","platformVersion":"4.9.0-1-amd64","processId":17474,"proxy":{},"raisesAccessibilityExceptions":false,"rotatable":false,"specificationLevel":0,"takesElementScreenshot":true,"takesScreenshot":true,"version":"51.0a1"}}
# curl -d '{"url": "https://mozilla.org"}' http://localhost:4444/session/d4605710-5a4e-4d64-a52a-778bb0c31e00/url
{}
# % curl http://localhost:4444/session/d4605710-5a4e-4d64-a52a-778bb0c31e00/url
# {"value":"https://www.mozilla.org/en-US/"
# % curl -X DELETE http://localhost:4444/session/d4605710-5a4e-4d64-a52a-778bb0c31e00
# {}
