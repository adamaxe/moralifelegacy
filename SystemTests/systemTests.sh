#! /bin/sh

#Setup script order
#User can opt to just do one or more of the scripts
if [ $# -gt 0 ]; then
    scripts=("$@")

else
    scripts=( "introcompletion" "helpscreendismissals" "mainnavigation" "consciencenavigation" "referenceverify" "choicemoraldisplay" "choicemoralcancel" "choicemoralentry" "choicemoralverify" "choiceimmoraldisplay" "choiceimmoralcancel" "choiceimmoralentry" "choiceimmoralverify" "reportpienavigation")

    #Wipe the simulator
    rm -Rf ~/Library/Application\ Support/iPhone\ Simulator

fi

#Determine if script is being run from workstation or CI box
if [ "$JENKINS_SYSTEM_TESTS" = "YES" ]; then
#if [ -z "$JENKINS_SYSTEM_TESTS"]; then

    #Iterate through every script
    for i in "${scripts[@]}"
    do

    #Remove previous trace files and reports
    rm -Rf *.trace
    rm -rf ${WORKSPACE}/SystemTests/results
    mkdir ${WORKSPACE}/SystemTests/results

    #Launch Instruments, use UIAutomation template, point to currently-built app, run js test script, send output to results dir
    instruments -t /Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate ${WORKSPACE}/build/Release-iphonesimulator/MoraLife.app -e UIASCRIPT ${WORKSPACE}/SystemTests/$i.js -e UIARESULTSPATH ${WORKSPACE}/SystemTests/results

    #Copy the OCUnit results xml to reports
    cp "${WORKSPACE}/SystemTests/results/Run 1/Automation Results.plist" ${WORKSPACE}/test-reports/$i.xml

    done

    exit 0

else

    #Setup a place for the results to be copied to
    RESULTS_DIRECTORY=~/Downloads/results
    rm -Rf $RESULTS_DIRECTORY
    mkdir $RESULTS_DIRECTORY

    XCODEBUILD_BUILD_DIR=`xcodebuild -showBuildSettings |grep [^_]BUILD_DIR | awk '{print $3}'`
    XCODEBUILD_WRAPPER_NAME=`xcodebuild -showBuildSettings |grep WRAPPER_NAME | awk '{print $3}'`

    #Iterate through every script
    for i in "${scripts[@]}"
    do

    instruments -D $RESULTS_DIRECTORY/$i-trace.trace -t /Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate $XCODEBUILD_BUILD_DIR/Release-iphonesimulator/$XCODEBUILD_WRAPPER_NAME -e UIASCRIPT ./SystemTests/$i.js -e UIARESULTSPATH $RESULTS_DIRECTORY

    done

    rm -Rf $RESULTS_DIRECTORY
    exit 0
fi