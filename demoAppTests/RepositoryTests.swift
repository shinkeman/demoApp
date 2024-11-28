import XCTest
@testable import demoApp

final class RepositoryTests: XCTestCase {
    var sut: RepositoryModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testRepositoryDecoding() throws {
        let path = Bundle(for: RepositoryTests.self).path(forResource: "sampleRepository", ofType: "json")!
        let data = NSData(contentsOfFile: path)! as Data
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        sut = try! decoder.decode(RepositoryModel.self, from: data)
        XCTAssertEqual(sut.id, 44838949)
        XCTAssertEqual(sut.fullName, "apple/swift")
        XCTAssertEqual(sut.stargazersCount, 61951)
        XCTAssertEqual(sut.language, "C++")
    }
}
