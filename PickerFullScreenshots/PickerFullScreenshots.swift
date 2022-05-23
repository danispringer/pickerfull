//
//  PickerFullScreenshots.swift
//  PickerFullScreenshots
//
//  Created by dani on 5/22/22.
//  Copyright © 2022 Dani Springer. All rights reserved.
//

import XCTest

class PickerFullScreenshots: XCTestCase {


    // xcodebuild -testLanguage de -scheme Libi -project ./Libi.xcodeproj -derivedDataPath '/tmp/LibiDerivedData/'
    // -destination "platform=iOS Simulator,name=iPhone 11 Pro Max" build test



    var app: XCUIApplication!


    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--pickerfullScreenshots")
    }


    func testMakeScreenshots() {
        app.launch()

        // TODO: screenshot, image with color picker, advanced picker

        takeScreenshot(named: "Home")

        let toolbar = XCUIApplication().toolbars["Toolbar"]

        toolbar.buttons["Share color"].tap()
        app.buttons["Download as image"].firstMatch.tap()
        addUIInterruptionMonitor(withDescription: "desc") { _ in
            self.app.alerts.buttons["OK"].firstMatch.exists
        }

        var alertPressed = false

        addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
            alert.buttons["OK"].tap()
            alertPressed = true
            return true
        }

        XCTAssert(alertPressed)

        app.sheets["Image Saved"].scrollViews.otherElements.buttons["Open Gallery"].tap()

        app.tabBars["Tab Bar"].buttons["Albums"].tap()

        app.otherElements["Recents"].firstMatch.tap()
        app.images.firstMatch.tap()
        takeScreenshot(named: "Screenshot")


//        toolbar.buttons["Advanced picker"].tap()
//        let closeButton = app.scrollViews.otherElements.buttons["close"]
//        closeButton.tap()
//        toolbar.buttons["Image menu"].tap()
//        toolbar.buttons["Info menu"].tap()
    }


    func takeScreenshot(named name: String) {
        // Take the screenshot
        let fullScreenshot = XCUIScreen.main.screenshot()

        // Create a new attachment to save our screenshot
        // and give it a name consisting of the "named"
        // parameter and the device name, so we can find
        // it later.
        let screenshotAttachment = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: "Screenshot-\(UIDevice.current.name)-\(name).png",
            payload: fullScreenshot.pngRepresentation,
            userInfo: nil)

        // Usually Xcode will delete attachments after
        // the test has run; we don't want that!
        screenshotAttachment.lifetime = .keepAlways

        // Add the attachment to the test log,
        // so we can retrieve it later
        add(screenshotAttachment)
    }

}
