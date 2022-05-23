#!/bin/bash

# The Xcode project to create screenshots for
projectName="./PickerFull.xcodeproj"

# The scheme to run tests for
schemeName="PickerFull"


# All the simulators we want to screenshot
# Copy/Paste new names from Xcode's
# "Devices and Simulators" window
# or from `xcrun simctl list`.
#simulators=(
#    "iPhone 13 Pro Max"
#)
simulators=(
    "iPhone 8 Plus"
    "iPhone 13 Pro Max"
    "iPad Pro (12.9-inch) (5th generation)"
)

# All the languages we want to screenshot (ISO 3166-1 codes)
languages=(
    "en"
)

# All the appearances we want to screenshot
# (options are "light" and "dark")
appearances=(
    "light"
)

# Save final screenshots into this folder (it will be created)
targetFolder="/Users/dani/Desktop/PickerFullScreenshots"
rm -rf /Users/dani/Desktop/PickerFullScreenshots


for simulator in "${simulators[@]}"
do
    for language in "${languages[@]}"
    do
        for appearance in "${appearances[@]}"
        do
            rm -rf /tmp/PickerFullDerivedData/Logs/Test
            echo "📲 Building and Running for $simulator in $language"

            # Boot up the new simulator and set it to
            # the correct appearance
            xcrun simctl boot "$simulator"
            xcrun simctl ui "$simulator" appearance $appearance

            # Build and Test
            xcodebuild -testLanguage $language -scheme $schemeName -project $projectName -derivedDataPath '/tmp/PickerFullDerivedData/' -destination "platform=iOS Simulator,name=$simulator" build test
            echo "Collecting Results..."
            mkdir -p "$targetFolder/$simulator/"
            find /tmp/PickerFullDerivedData/Logs/Test -maxdepth 1 -type d -exec xcparse screenshots {} "$targetFolder/$simulator/" \;
        done
    done

    echo "✅ Done"
done
