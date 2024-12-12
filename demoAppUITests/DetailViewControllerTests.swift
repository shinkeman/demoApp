import XCTest

final class DetailViewControllerUITest: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
        try super.tearDownWithError()
    }

    func testDetailViewControllerScreen() {
        let searchBarElement = app.otherElements["searchBar"]
        let tableView = app.tables["tableView"]
        let exists = NSPredicate(format: "exists == 1")

        searchBarElement.tap()
        app.keyboards.keys["G"].tap()
        app.keyboards.keys["o"].tap()
        app.keyboards.keys["o"].tap()
        app.keyboards.keys["g"].tap()
        app.keyboards.keys["l"].tap()
        app.keyboards.keys["e"].tap()
        app.keyboards.buttons["search"].tap()
        
        waitForSeconds(3)

        // wait for data to load
        let firstTableCell = tableView.cells.firstMatch

        let expectation = expectation(for: exists, evaluatedWith: firstTableCell)

        wait(for: [expectation], timeout: 3)

        XCTAssertTrue(firstTableCell.exists, "cell 0 is not on the table")

        let cellName = firstTableCell.staticTexts.firstMatch.label
        firstTableCell.tap()

        let staticLabel = app.staticTexts["staticLabel"]
        XCTAssertTrue(staticLabel.exists)
        XCTAssertEqual(staticLabel.label, "The title of repository:")

        let nameLabel = app.staticTexts["nameLabel"].firstMatch
        XCTAssertTrue(nameLabel.exists)
        XCTAssertEqual(nameLabel.label, cellName)
    }
}
