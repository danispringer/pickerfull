#!/bin/bash

# The Xcode project to create screenshots for
projectName="./PickerFull.xcodeproj"

# The scheme to run tests for
schemeName="PickerFull"

# All the simulators we want to screenshot
# Copy/Paste new names from Xcode's
# "Devices and Simulators" window
# or from `xcrun simctl list`.

simulators=(
    "iPhone 14 Pro Max"
    "iPhone 13 Pro Max"
    "iPhone 8 Plus"
    "iPad Pro (12.9-inch) (6th generation)"
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
# To prevent duplicates when re-running tests
rm -rf /Users/dani/Desktop/PickerFullScreenshots

# Clear user screenshots
rm -rf "$HOME/Library/Developer/CoreSimulator/Devices/*/data/Media/DCIM/100APPLE/IMG_{0007..0999}.JPG"

#find "$HOME/Library/Developer/CoreSimulator/Devices/*/data/Media/DCIM/100APPLE/" ! \( -name "IMG_{0001..0006}.JPG" -a -name "IMG_{0001..0006}.HEIC" \) -delete

for simulator in "${simulators[@]}"; do
    for language in "${languages[@]}"; do
        for appearance in "${appearances[@]}"; do
            rm -rf /tmp/PickerFullDerivedData/Logs/Test
            echo "📲 Building and Running for $simulator in $language"

            # Boot up the new simulator and set it to
            # the correct appearance
            xcrun simctl boot "$simulator"
            xcrun simctl ui "$simulator" appearance "$appearance"

            # Build and Test
            xcodebuild -testLanguage "$language" -scheme $schemeName -project $projectName -derivedDataPath '/tmp/PickerFullDerivedData/' -destination "platform=iOS Simulator,name=$simulator" build test
            echo "Collecting Results..."
            mkdir -p "$targetFolder/$simulator/"
            find /tmp/PickerFullDerivedData/Logs/Test -maxdepth 1 -type d -exec xcparse screenshots {} "$targetFolder/$simulator/" \;
            xcrun simctl shutdown "$simulator"
        done
    done
    echo "✅ Done"
done

#~/Library/Developer/CoreSimulator/Devices/52F442A3-401A-4CC3-BA3B-28E60F86759B/data/Media/DCIM/100APPLE/IMG_0007.JPG
#xcrun simctl list devices | grep Booted | grep -E  '\w+-\w+-\w+-\w+-\w+' -o
mv $HOME/Library/Developer/CoreSimulator/Devices/*/data/Media/DCIM/100APPLE/* $HOME/Desktop
