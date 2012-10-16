#! /bin/sh
#rm -Rf ~/Library/Application\ Support/iPhone\ Simulator/

mkdir ~/Downloads/results

scripts=( "introcompletion" "helpscreendismissals" "reportpienavigation" "choicemoralentry" "choicemoralverify" "mainnavigation" "consciencenavigation" "choicemoraldisplay" "choicemoralcancel" "choicemoralentry" "choicemoralverify"
"choiceimmoraldisplay" "choiceimmoralcancel" "choiceimmoralentry" "choiceimmoralverify")

for i in "${scripts[@]}"
do

#rm -Rf *.trace
#rm -rf ${WORKSPACE}/SystemTests/results
#mkdir ${WORKSPACE}/SystemTests/results

#instruments -t /Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate ${WORKSPACE}/build/Release-iphonesimulator/MoraLife.app -e UIASCRIPT ${WORKSPACE}/SystemTests/$i.js -e UIARESULTSPATH ${WORKSPACE}/SystemTests/results

#cp "${WORKSPACE}/SystemTests/results/Run 1/Automation Results.plist" ${WORKSPACE}/test-reports/$i.xml

instruments -t /Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate $BUILT_PRODUCTS_DIR/$WRAPPER_NAME -e UIASCRIPT $SRCROOT/SystemTests/$i.js -e UIARESULTSPATH ~/Downloads/results

done

rm -Rf ~/Downloads/results