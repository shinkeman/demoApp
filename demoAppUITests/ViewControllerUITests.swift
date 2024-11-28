import XCTest
@testable import demoApp

final class ViewControllerUITest: XCTestCase {
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

    func testViewControllerInitialization() {
        let searchBarElement = app.otherElements["searchBar"]
        XCTAssertTrue(searchBarElement.exists)
        
        let tableView = app.tables["tableView"]
        XCTAssertTrue(tableView.exists)
    }

    func testUISearchBarTyping() {
        let searchBarElement = app.otherElements["searchBar"]
        XCTAssertTrue(searchBarElement.exists)
        
        searchBarElement.tap()
        XCTAssertTrue(app.keyboards.firstMatch.exists)

        app.keyboards.keys["T"].tap()
        app.keyboards.keys["e"].tap()
        app.keyboards.keys["s"].tap()
        app.keyboards.keys["t"].tap()
    }

    func testTableViewScroll() {
        let searchBarElement = app.otherElements["searchBar"]
        let exists = NSPredicate(format: "exists == 1")
        let tableView = app.tables["tableView"]

        searchBarElement.tap()
        app.keyboards.keys["G"].tap()
        app.keyboards.keys["o"].tap()
        app.keyboards.keys["o"].tap()
        app.keyboards.keys["g"].tap()
        app.keyboards.keys["l"].tap()
        app.keyboards.keys["e"].tap()
        app.keyboards.buttons["search"].tap()

        let firstTableCell = tableView.cells.firstMatch
        let expectation = expectation(for: exists, evaluatedWith: firstTableCell)
        waitForExpectations(timeout: 10, handler: nil)
        expectation.fulfill()

        let cellCount = tableView.cells.count
        let lastTableCell = tableView.cells.allElementsBoundByIndex[cellCount-1]

        tableView.swipeUp()

        XCTAssertTrue(lastTableCell.exists, "last cell is not on the table")
    }
    
    func testNavigation() {
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

        // wait for data to load
        let firstTableCell = tableView.cells.firstMatch
        let expectation = expectation(for: exists, evaluatedWith: firstTableCell)
        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertTrue(firstTableCell.exists, "cell 0 is not on the table")
        expectation.fulfill()

        firstTableCell.tap()

        let backButton = app.navigationBars["navBar"].buttons["Repositories"]
        XCTAssertTrue(backButton.exists)
        backButton.tap()
    }
}
