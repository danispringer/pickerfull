//
//  PickerFullScreenshots.swift
//  PickerFullScreenshots
//
//  Created by dani on 5/22/22.
//  Copyright © 2022 Dani Springer. All rights reserved.
//

import XCTest

class PickerFullScreenshots: XCTestCase {

    // MARK: Properties

    var app: XCUIApplication!
    let toolbar = XCUIApplication().toolbars["Toolbar"]


    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--pickerfullScreenshots")
    }


    func testHome() {
        app.launch()
        takeScreenshot(name: "Home")
    }


    func testAdvancedPicker() {
        app.launch()
        toolbar.buttons["Editor"].tap()
        XCTAssertTrue(app.buttons["Sliders"].waitForExistence(timeout: 5))
        app.buttons["Sliders"].tap()
// XCTAssert(XCUIApplication().scrollViews.otherElements.staticTexts["Display P3 Hex Color #"]
// .waitForExistence(timeout: 5))
//        XCUIApplication().scrollViews.otherElements.staticTexts["Display P3 Hex Color #"].tap()
//        XCTAssert(app.buttons["sRGB"].waitForExistence(timeout: 5))
//        app.buttons["sRGB"].tap()
//        XCTAssert(app.staticTexts["Colors"].waitForExistence(timeout: 5))
        takeScreenshot(name: "Advanced")
    }


    // TODO: take manually. more needed?
//    func testFloatingPicker() {
//        app.launch()
//        toolbar.buttons["Image menu"].tap()
//        app.collectionViews.buttons["Choose Photo"].tap()
//        app.buttons["Albums"].tap()
//
//        app.scrollViews.otherElements.images.firstMatch.tap()
//        XCTAssert(app.otherElements["Photos"].scrollViews.otherElements
//            .images.firstMatch.waitForExistence(timeout: 5))
//        app.otherElements["Photos"].scrollViews.otherElements.images.firstMatch.tap()
//        XCTAssert(toolbar.buttons["Editor"].waitForExistence(timeout: 5))
//        toolbar.buttons["Editor"].tap()
//        app.buttons["Floating color picker"].tap()
//        XCTAssert(toolbar.waitForExistence(timeout: 5))
//        _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 10.0)
//        takeScreenshot(name: "Floating-picker")
//        // how to show floating picker in screenshot?
//
//        // how to hide picker?
//        app.toolbars.buttons.firstMatch.tap()
//    }


    func testSaveImage() {
        app.launch()
        XCTAssertTrue(toolbar.buttons["Share"].firstMatch.waitForExistence(timeout: 5))
        toolbar.buttons["Share"].tap()
        app.buttons["Download as image"].firstMatch.tap()
        XCTAssertTrue(app.sheets["Image Saved"].waitForExistence(timeout: 5))
    }


    // MARK: Take Screenshot

    func takeScreenshot(name: String) {
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
