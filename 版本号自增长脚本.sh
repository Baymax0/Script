#!/bin/bash
# V-0.1
# Autor Lizhiwei

if ["${CONFIGURATION}"="Release"];then

buildNumber=$(/usr/libexec/PlistBuddy -c"Print CFBundleVersion""$INFOPLIST_FILE")
appVersion=$(/usr/libexec/PlistBuddy -c"Print CFBundleShortVersionString""$INFOPLIST_FILE")
buildNumber=`echo $buildNumber|sed's/.*\./''/'`
buildNumber=$appVersion.$(($buildNumber +1))
/usr/libexec/PlistBuddy -c"Set :CFBundleVersion $buildNumber""$INFOPLIST_FILE"

fi





