#! /bin/sh
releaseConfig="Release"

if [ "$releaseConfig" = "${CONFIGURATION}" ]; then
echo "Running Crashlytics"
./Frameworks/Crashlytics.framework/run
fi
