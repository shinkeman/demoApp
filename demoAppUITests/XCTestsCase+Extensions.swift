import XCTest

extension XCTestCase {
    func waitForSeconds(_ s: Double) {
        let timeExpectation = XCTestExpectation(description: "Waiting for \(s) seconds")
        DispatchQueue.main.asyncAfter(deadline: .now() + s) {
            timeExpectation.fulfill()
        }
        wait(for: [timeExpectation], timeout: s)
    }
}
