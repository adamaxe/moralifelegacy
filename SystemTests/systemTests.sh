#! /bin/sh

#Setup script order
#User can opt to just do one or more of the scripts by passing command line arguments
DEFAULT_SCRIPTS=( "introcompletion" "helpscreendismissals" "mainnavigation" "consciencenavigation" "referenceverify" "choicemoraldisplay" "choicemoralcancel" "choicemoralentry" "choicemoralverify" "choiceimmoraldisplay" "choiceimmoralcancel" "choiceimmoralentry" "choiceimmoralverify" "reportpienavigation")
SCRIPT_MESSAGE="\nHere are the available scripts: ${DEFAULT_SCRIPTS[@]}"

#If command line arguments are greater than 0, determine what user wants
if [ $# -gt 0 ]; then

    #Determine if user is looking for which scripts can run
    for i in "$@"
    do

        if [ "$i" = "-h" ] || [ "$i" = "--h" ] || [ "$i" = "-help" ] || [ "$i" = "/?" ] || [ "$i" = "help" ]; then

            #Display current scripts
            echo "Welcome to MoraLife System Test Runner!"
            echo "\nUsage:"
            echo "cd <Moralife root directory>"
            echo "To run all tests: ./SystemTests/systemTests.sh"
            echo "To run specific test(s): ./SystemTests/systemTests.sh <test name>"
            echo "To see a list of tests: ./SystemTests/systemTests.sh help"
            echo $SCRIPT_MESSAGE
            exit 0
        fi

        #Determine if user-supplied script is valid
        isValid=no
        for j in "${DEFAULT_SCRIPTS[@]}"
        do

            if [ "$j" = "$i" ]; then
                isValid=yes
            fi
        done

    done

    #If user provides incorrect script name, exit and show valid scripts
    if [ "$isValid" = "no" ]; then
        echo "That is not a valid script name. $SCRIPT_MESSAGE"
        exit 0
    fi

    #Otherwise, use the user provide list of scripts
    scripts=("$@")

#If there are no command line arguments, then wipe the sim and run the whole suite
else
    scripts=(${DEFAULT_SCRIPTS[@]})

    #Wipe the simulator
    rm -Rf ~/Library/Application\ Support/iPhone\ Simulator

fi

#Determine if script is being run from workstation or CI box
if [ "x$JENKINS_SYSTEM_TESTS" = "x" ]; then

    #Setup a place for the results to be copied to
    RESULTS_DIRECTORY=~/Downloads/results
    rm -Rf $RESULTS_DIRECTORY
    mkdir $RESULTS_DIRECTORY

    #Dynamically determine where the current build of the app resides
    XCODEBUILD_BUILD_DIR=`xcodebuild -showBuildSettings |grep [^_]BUILD_DIR | awk '{print $3}'`
    XCODEBUILD_WRAPPER_NAME=`xcodebuild -showBuildSettings |grep WRAPPER_NAME | awk '{print $3}'`

    #Iterate through every script
    for i in "${scripts[@]}"
    do

    instruments -D $RESULTS_DIRECTORY/$i-trace.trace -t /Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate $XCODEBUILD_BUILD_DIR/Debug-iphonesimulator/$XCODEBUILD_WRAPPER_NAME -e UIASCRIPT ./SystemTests/$i.js -e UIARESULTSPATH $RESULTS_DIRECTORY

    done

    rm -Rf $RESULTS_DIRECTORY
    exit 0


else

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
fi
