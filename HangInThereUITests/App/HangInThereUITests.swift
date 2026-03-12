//
//  HangInThereUITests.swift
//  HangInThereUITests
//
//  Created by Rafael Plinio on 12/03/26.
//

import XCTest

final class HangInThereUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testStartFlowShowsCategorySelection() throws {
        let app = XCUIApplication()
        app.launchArguments.append("UITesting")
        app.launch()

        XCTAssertTrue(app.staticTexts["splash.title"].waitForExistence(timeout: 2))

        app.buttons["splash.startButton"].tap()

        XCTAssertTrue(app.staticTexts["categorySelection.title"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["categorySelection.category.animals"].exists)
    }

    @MainActor
    func testChoosingCategoryShowsGameScreen() throws {
        let app = XCUIApplication()
        app.launchArguments.append("UITesting")
        app.launch()

        app.buttons["splash.startButton"].tap()
        app.buttons["categorySelection.category.animals"].tap()
        app.buttons["levelSelection.level.easy"].tap()

        XCTAssertTrue(app.otherElements["game.categoryTitle"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.otherElements["game.modeBadge"].exists)
        XCTAssertTrue(app.buttons["game.categoriesButton"].exists)
        XCTAssertTrue(app.staticTexts["game.hintText"].exists)
        XCTAssertTrue(app.staticTexts["game.maskedAnswer"].label.contains("_"))
    }

    @MainActor
    func testWinningRoundShowsSummaryActions() throws {
        let app = XCUIApplication()
        app.launchArguments.append("UITesting")
        app.launch()

        app.buttons["splash.startButton"].tap()
        app.buttons["categorySelection.category.animals"].tap()
        app.buttons["levelSelection.level.easy"].tap()

        app.buttons["game.keyboard.C"].tap()
        app.buttons["game.keyboard.A"].tap()
        app.buttons["game.keyboard.T"].tap()

        XCTAssertTrue(app.staticTexts["game.summaryTitle"].waitForExistence(timeout: 2))
        XCTAssertEqual(app.staticTexts["game.summaryTitle"].label, "Round Cleared")
        XCTAssertTrue(app.buttons["game.nextRoundButton"].exists)
        XCTAssertTrue(app.buttons["game.changeCategoryButton"].exists)
    }
}
