import XCTest

final class UnifiedAppUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        setupSnapshot(app)
        app.launch()
    }

    func testNavigateAllFiveTabs() {
        // Tab 1: Home
        let homeTab = app.tabBars.buttons.element(boundBy: 0)
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        homeTab.tap()

        // Tab 2: Academics
        let academicsTab = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(academicsTab.exists)
        academicsTab.tap()
        sleep(1)

        // Tab 3: Flight Deck
        let flightDeckTab = app.tabBars.buttons.element(boundBy: 2)
        XCTAssertTrue(flightDeckTab.exists)
        flightDeckTab.tap()
        sleep(1)

        // Tab 4: Captain Adel AI
        let adelTab = app.tabBars.buttons.element(boundBy: 3)
        XCTAssertTrue(adelTab.exists)
        adelTab.tap()
        sleep(1)

        // Tab 5: Regulations
        let regulationsTab = app.tabBars.buttons.element(boundBy: 4)
        XCTAssertTrue(regulationsTab.exists)
        regulationsTab.tap()
        sleep(1)
    }

    func testFlightDeckToolsNavigation() {
        let flightDeckTab = app.tabBars.buttons.element(boundBy: 2)
        XCTAssertTrue(flightDeckTab.waitForExistence(timeout: 5))
        flightDeckTab.tap()

        // Open Crosswind Calculator
        let crosswindTool = app.staticTexts["Crosswind & Runway Visualizer"]
        if crosswindTool.waitForExistence(timeout: 3) {
            crosswindTool.tap()
            sleep(1)
            app.navigationBars.buttons.element(boundBy: 0).tap() // Back button
        }
    }

    func testSettingsSheetOpenAndDismiss() {
        let homeTab = app.tabBars.buttons.element(boundBy: 0)
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        homeTab.tap()

        let settingsBtn = app.navigationBars.buttons.matching(identifier: "gearshape.fill").element(boundBy: 0)
        if settingsBtn.waitForExistence(timeout: 3) {
            settingsBtn.tap()
            sleep(1)
            let doneBtn = app.buttons["Done"]
            if doneBtn.waitForExistence(timeout: 3) {
                doneBtn.tap()
            }
        }
    }
}
