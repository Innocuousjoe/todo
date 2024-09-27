import XCTest
@testable import todo

final class todoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAPI() throws {
        let api = APIProvider()
        let endpoint = api.endpoint(.getTaskList)
        XCTAssert(endpoint.url == "https://jsonplaceholder.typicode.com/todos")
        XCTAssert(endpoint.method == .get)
    }
}
