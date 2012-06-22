#! /bin/sh
# ${WORKSPACE}/IntegrationTests/runTests.sh mainnavigation build/Release-iphonesimulator/MoraLife.app ${WORKSPACE}

XCODE_PATH=`xcode-select -print-path`
TRACETEMPLATE="$XCODE_PATH/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate"
BASE_TEST_SUITE=$1
APP_LOCATION=$2
JENKINS_WORKSPACE=$3
DEVICE_ID=$4

cat $JENKINS_WORKSPACE/IntegrationTests/include/uiajsinclude.js $JENKINS_WORKSPACE/IntegrationTests/$BASE_TEST_SUITE.js > $JENKINS_WORKSPACE/IntegrationTests/testsuite.js

rm -rf $JENKINS_WORKSPACE/IntegrationTests/results
mkdir $JENKINS_WORKSPACE/IntegrationTests/results

if [ ! $# -gt 1 ]; then
	echo "You must specify the app location and the test file."
	echo "\t (optionally supply unique device ID of physical iOS device)"
	echo "\t eg. ./build.sh suite.js <xcodeproject directory>/build/Debug-iphonesimulator/myapp.app <device-udid>"
	exit -1
fi

# If running on device, only need name of app, full path not important
if [ ! "$DEVICE_ID" = "" ]; then
  RUN_ON_SPECIFIC_DEVICE_OPTION="-w $DEVICE_ID"
  APP_LOCATION=`basename $JENKINS_WORKSPACE/$APP_LOCATION`
fi

# Create junit reporting directory
if [ ! -d "test-reports" ]; then
  mkdir test-reports
fi

# Kick off the instruments build
instruments \
$RUN_ON_SPECIFIC_DEVICE_OPTION \
-t $TRACETEMPLATE \
$APP_LOCATION \
-e UIASCRIPT $JENKINS_WORKSPACE/IntegrationTests/testsuite.js \
-e UIARESULTSPATH /var/tmp | grep "<"  > test-reports/test-results.xml

# cleanup the tracefiles produced from instruments
rm -rf $JENKINS_WORKSPACE/*.trace
rm -rf $JENKINS_WORKSPACE/IntegrationTests/testsuite.js

cp "$JENKINS_WORKSPACE/IntegrationTests/results/Run 1/Automation Results.plist" $JENKINS_WORKSPAC}/test-reports/$BASE_TEST_SUITE.xml

# fail script if any failures have been generated
if [ `grep "<failure>" test-reports/test-results.xml | wc -l` -gt 0 ]; then
        echo 'Build Failed'
        exit -1
else
        echo 'Build Passed'
        exit 0
fi
