#! /bin/sh
#Wipe the simulator
#rm -Rf ~/Library/Application\ Support/iPhone\ Simulator/

mkdir ~/Downloads/results

#Setup script order
scripts=( "introcompletion" "helpscreendismissals" "referenceverify" "reportpienavigation" "choicemoralentry" "choicemoralverify" "homenavigation" "consciencenavigation" "choicemoraldisplay" "choicemoralcancel" "choicemoralentry" "choicemoralverify"
"choiceimmoraldisplay" "choiceimmoralcancel" "choiceimmoralentry" "choiceimmoralverify")

for i in "${scripts[@]}"
do

#Remove previous trace files and reports
#rm -Rf *.trace
#rm -rf ${WORKSPACE}/SystemTests/results
#mkdir ${WORKSPACE}/SystemTests/results

#Launch Instruments, use UIAutomation template, point to currently-built app, run js test script, send output to results dir
#instruments -t /Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate ${WORKSPACE}/build/Release-iphonesimulator/MoraLife.app -e UIASCRIPT ${WORKSPACE}/SystemTests/$i.js -e UIARESULTSPATH ${WORKSPACE}/SystemTests/results

#Copy the OCUnit results xml to reports
#cp "${WORKSPACE}/SystemTests/results/Run 1/Automation Results.plist" ${WORKSPACE}/test-reports/$i.xml

instruments -t /Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate $BUILT_PRODUCTS_DIR/$WRAPPER_NAME -e UIASCRIPT $SRCROOT/SystemTests/$i.js -e UIARESULTSPATH ~/Downloads/results

done

rm -Rf ~/Downloads/results