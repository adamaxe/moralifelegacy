#! /bin/sh

#Setup script order
scripts=( "introcompletion" "helpscreendismissals" "mainnavigation" "consciencenavigation" "referenceverify" "choicemoraldisplay" "choicemoralcancel" "choicemoralentry" "choicemoralverify" "choiceimmoraldisplay" "choiceimmoralcancel" "choiceimmoralentry" "choiceimmoralverify" "reportpienavigation")


#Determine if script is being run from workstation or CI box
if [ -z "$JENKINS_SYSTEM_TESTS" ]; then

    #Setup a place for the results to be copied to
    RESULTS_DIRECTORY=~/Downloads/results
    mkdir $RESULTS_DIRECTORY

    #Iterate through every script
    for i in "${scripts[@]}"
    do

#instruments -t /Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate $BUILT_PRODUCTS_DIR/$WRAPPER_NAME -e UIASCRIPT $SRCROOT/SystemTests/$i.js -e UIARESULTSPATH $RESULTS_DIRECTORY
    instruments -t /Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate $BUILT_PRODUCTS_DIR/$WRAPPER_NAME -e UIASCRIPT /Users/aaxe/Documents/projects/teamaxe/code/moralife/SystemTests/$i.js -e UIARESULTSPATH $RESULTS_DIRECTORY

    done

    rm -Rf $RESULTS_DIRECTORY
    exit 1

else

    #Wipe the simulator
    rm -Rf ~/Library/Application\ Support/iPhone\ Simulator/

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

    exit 1
fi