#! /bin/sh

rm -Rf ~/Downloads/results
rm -Rf ~/Library/Application\ Support/iPhone\ Simulator/

mkdir ~/Downloads/results

scripts=( "introcompletion" "helpscreendismissals" "choicemoralentry" "choicemoralverify" "mainnavigation" "consciencenavigation" "choicemoraldisplay" "choicemoralcancel" "choicemoralentry" "choicemoralverify"
    "choiceimmoraldisplay" "choiceimmoralcancel" "choiceimmoralentry" "choiceimmoralverify")

for i in "${scripts[@]}"
do

instruments -t /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate $BUILT_PRODUCTS_DIR/$WRAPPER_NAME -e UIASCRIPT $SRCROOT/SystemTests/$i.js -e UIARESULTSPATH ~/Downloads/results

done