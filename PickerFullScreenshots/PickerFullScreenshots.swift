//
//  PickerFullScreenshots.swift
//  PickerFullScreenshots
//
//  Created by Daniel Springer on 5/22/22.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

// TODO: update app store screenshots:
// - manual: picker in action
// - manual: generated screenshot

// - advanced editor, random history, share as text, home: done.

import XCTest

class PickerFullScreenshots: XCTestCase {

    // MARK: Properties

    var app: XCUIApplication!

    let pickerString = "Advanced editor"
    let nowNowString = "Not Now"


    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--pickerfullScreenshots")
    }


    func testShareTextOptions() {
        app.launch()
        app.buttons[nowNowString].tap()
        XCTAssertTrue(app.buttons["Export as text"].waitForExistence(timeout: 5))
        app.buttons["Export as text"].tap()
        takeScreenshot(named: "share-as-text-options")
    }


    func testRandomHistory() {
        app.launch()
        app.buttons[nowNowString].tap()
        for _ in 1...15 {
            app.buttons["New random color"].tap()
        }
        app.buttons["Random history"].tap()
        XCTAssertTrue(app.buttons["Edit"].waitForExistence(timeout: 5))
        takeScreenshot(named: "random-history")
    }


    func testAdvancedPicker() {
        app.launch()
        app.buttons[nowNowString].firstMatch.tap()
        app.buttons[pickerString].tap()
        XCTAssertTrue(app.buttons["Sliders"].waitForExistence(timeout: 5))
        app.buttons["Sliders"].tap()
        app.scrollViews.otherElements.buttons["Display P3 Hex Color #"].tap()
        app.buttons["sRGB"].tap()
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText("E57BF2")
        app.buttons["Spectrum"].tap()
        XCTAssertTrue(app.buttons["Sliders"].waitForExistence(timeout: 5))
        app.buttons["Sliders"].tap()
        XCTAssertTrue(app.scrollViews.otherElements.buttons["sRGB Hex Color #"]
            .waitForExistence(timeout: 5))
        takeScreenshot(named: "Advanced-Editor")
    }


    func testSaveImage() {
        app.launch()
        app.buttons[nowNowString].firstMatch.tap()
        app.staticTexts["Export as file"].tap()
        app.collectionViews.buttons["Generate Screenshot"].tap()
        XCTAssertTrue(app.staticTexts["Your Screenshot"].waitForExistence(timeout: 5))
    }

    func testHome() {
        app.launch()
        app.buttons[nowNowString].firstMatch.tap()
        XCTAssertTrue(app.buttons["About app"].waitForExistence(timeout: 5))
        takeScreenshot(named: "Home")
    }


    // MARK: Take Screenshot

    func takeScreenshot(named: String) {
        // Take the screenshot
        let fullScreenshot = XCUIScreen.main.screenshot()

        // Create a new attachment to save our screenshot
        // and give it a name consisting of the "named"
        // parameter and the device name, so we can find
        // it later.
        let screenshotAttachment = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: "Screenshot-\(UIDevice.current.model)-\(named).png",
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
