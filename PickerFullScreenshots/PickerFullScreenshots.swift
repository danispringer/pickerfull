//
//  PickerFullScreenshots.swift
//  PickerFullScreenshots
//
//  Created by Daniel Springer on 5/22/22.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import XCTest

class PickerFullScreenshots: XCTestCase {

    // MARK: Properties

    var app: XCUIApplication!

    let pickerString = "Advanced editor"


    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--pickerfullScreenshots")
    }


    func testHome() {
        app.launch()
        app.buttons["Not Now"].firstMatch.tap()
        XCTAssertTrue(app.buttons["About app"].waitForExistence(timeout: 5))
        takeScreenshot(name: "Home")
    }


    func testTutorial() {
        app.launch()
        XCTAssertTrue(app.buttons["Not Now"].waitForExistence(timeout: 5))
        takeScreenshot(name: "Tutorial")
    }


    func testRandomHistory() {
        app.launch()
        app.buttons["Not Now"].tap()
        for _ in 1...15 {
            app.buttons["New random color"].tap()
        }
        app.buttons["Random history"].tap()
        XCTAssertTrue(app.buttons["Edit"].waitForExistence(timeout: 5))
        takeScreenshot(name: "random-history")
    }


    func testAdvancedPicker() {
        app.launch()
        app.buttons["Not Now"].firstMatch.tap()
        app.buttons[pickerString].tap()
        XCTAssertTrue(app.buttons["Sliders"].waitForExistence(timeout: 5))
        app.buttons["Sliders"].tap()
        app.scrollViews.otherElements.buttons["Display P3 Hex Color #"].tap()
        app.buttons["sRGB"].tap()
        app.textFields.firstMatch.tap()
        app.textFields.firstMatch.typeText("E57BF2")
        app.buttons["Sliders"].tap()
        takeScreenshot(name: "Advanced")
    }


    func testFloatingPicker() {
        app.launch()
        app.buttons["Not Now"].firstMatch.tap()
        app.staticTexts["Import photo"].tap()
        app.collectionViews.buttons["Choose Photo"].tap()
        app.scrollViews.otherElements.images.firstMatch.tap()
        XCTAssert(app.buttons[pickerString].waitForExistence(timeout: 5))
        app.buttons[pickerString].tap()
        app.buttons["Floating color picker"].tap()
        XCTAssert(app.waitForExistence(timeout: 5))
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 10.0)
        app.firstMatch.swipeUp(velocity: .fast)
        takeScreenshot(name: "Floating-picker")
        // how to show floating picker in screenshot?
    }


    func testSaveImage() {
        app.launch()
        app.buttons["Not Now"].firstMatch.tap()
        app.staticTexts["Export as file"].tap()
        app.collectionViews.buttons["Generate Screenshot"].tap()
        XCTAssertTrue(app.staticTexts["Your Screenshot"].waitForExistence(timeout: 5))
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
