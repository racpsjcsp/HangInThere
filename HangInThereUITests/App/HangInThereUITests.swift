//
//  HangInThereUITests.swift
//  HangInThereUITests
//
//  Created by Rafael Plinio on 12/03/26.
//

import XCTest

final class HangInThereUITests: XCTestCase {

    private func anyElement(_ app: XCUIApplication, id: String) -> XCUIElement {
        app.descendants(matching: .any)[id]
    }

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

        XCTAssertTrue(app.staticTexts["levelSelection.title"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["levelSelection.backButton"].exists)
        XCTAssertTrue(app.buttons["levelSelection.level.easy"].exists)
        XCTAssertTrue(app.buttons["levelSelection.level.medium"].exists)
        XCTAssertTrue(app.buttons["levelSelection.level.hard"].exists)

        app.buttons["levelSelection.level.medium"].tap()

        XCTAssertTrue(anyElement(app, id: "game.modeBadge").waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["game.categoriesButton"].exists)
        XCTAssertTrue(app.staticTexts["game.hintText"].exists)
        XCTAssertTrue(app.staticTexts["game.maskedAnswer"].label.contains("_"))
    }

    @MainActor
    func testLevelSelectionBackReturnsToCategories() throws {
        let app = XCUIApplication()
        app.launchArguments.append("UITesting")
        app.launch()

        app.buttons["splash.startButton"].tap()
        app.buttons["categorySelection.category.animals"].tap()

        XCTAssertTrue(app.staticTexts["levelSelection.title"].waitForExistence(timeout: 2))

        app.buttons["levelSelection.backButton"].tap()

        XCTAssertTrue(app.staticTexts["categorySelection.title"].waitForExistence(timeout: 2))
    }

    @MainActor
    func testChoosingHardLevelShowsHardModeBadge() throws {
        let app = XCUIApplication()
        app.launchArguments.append("UITesting")
        app.launch()

        app.buttons["splash.startButton"].tap()
        app.buttons["categorySelection.category.animals"].tap()
        app.buttons["levelSelection.level.hard"].tap()

        let badge = anyElement(app, id: "game.modeBadge")

        XCTAssertTrue(badge.waitForExistence(timeout: 2))
        XCTAssertTrue(badge.label.contains("Hard"))
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
