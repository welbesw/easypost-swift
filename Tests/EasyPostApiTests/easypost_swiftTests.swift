import XCTest
@testable import EasyPostApi

final class easypost_swiftTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let apiToken = "TestToken"
        EasyPostApi.sharedInstance.setCredentials(apiToken, baseUrl: "https://api.easypost.com/v2/")
    }
}
