import XCTest

final class demoAppUITestsLaunchTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let title = app.staticTexts["Repositories"].firstMatch
        XCTAssertTrue(title.exists)

        waitForSeconds(5)
    }
}
