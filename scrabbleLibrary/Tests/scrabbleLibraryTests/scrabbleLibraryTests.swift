import XCTest
@testable import scrabbleLibrary

class scrabbleLibraryTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(scrabbleLibrary().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
