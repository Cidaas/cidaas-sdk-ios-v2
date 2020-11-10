import XCTest
@testable import cidaas

final class cidaasTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(cidaas().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
