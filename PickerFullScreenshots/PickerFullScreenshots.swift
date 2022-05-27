//
//  PickerFullScreenshots.swift
//  PickerFullScreenshots
//
//  Created by dani on 5/22/22.
//  Copyright © 2022 Dani Springer. All rights reserved.
//

import XCTest

class PickerFullScreenshots: XCTestCase {


    var app: XCUIApplication!
    let toolbar = XCUIApplication().toolbars["Toolbar"]
    var spring = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--pickerfullScreenshots")
    }


    func testHome() {
        app.launch()
        takeScreenshot(named: "Home")
    }


    func testAdvancedPicker() {
        app.launch()
        toolbar.buttons["Advanced picker"].tap()
        XCTAssertTrue(app.buttons["Sliders"].waitForExistence(timeout: 5))
        app.buttons["Sliders"].tap()
// XCTAssert(XCUIApplication().scrollViews.otherElements.staticTexts["Display P3 Hex Color #"]
// .waitForExistence(timeout: 5))
//        XCUIApplication().scrollViews.otherElements.staticTexts["Display P3 Hex Color #"].tap()
//        XCTAssert(app.buttons["sRGB"].waitForExistence(timeout: 5))
//        app.buttons["sRGB"].tap()
//        XCTAssert(app.staticTexts["Colors"].waitForExistence(timeout: 5))
        takeScreenshot(named: "Advanced")
    }


    func testFloatingPicker() {
        app.launch()
        toolbar.buttons["Image menu"].tap()
        app.collectionViews.buttons["Choose Photo"].tap()
        XCTAssert(app.otherElements["Photos"].scrollViews.otherElements
            .images["Photo, March 30, 2018, 3:14 PM"]
            .waitForExistence(timeout: 10))
        app.otherElements["Photos"].scrollViews.otherElements.images["Photo, March 30, 2018, 3:14 PM"].tap()
        XCTAssert(toolbar.buttons["Advanced picker"].waitForExistence(timeout: 10))
        toolbar.buttons["Advanced picker"].tap()
        app.buttons["Floating color picker"].tap()

        takeScreenshot(named: "Floating-picker")
        app.images.firstMatch.tap()
        // TODO: how to show floating picker in screenshot?
    }


    func testSaveImage() {
        app.launch()
        XCTAssertTrue(toolbar.buttons["Share color"].firstMatch.waitForExistence(timeout: 5))
        toolbar.buttons["Share color"].tap()
        app.buttons["Download as image"].firstMatch.tap()
        XCTAssertTrue(app.sheets["Image Saved"].waitForExistence(timeout: 5))
    }


    // MARK: Take Screenshot

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
