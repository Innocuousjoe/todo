@testable import todo
import XCTest

final class todoListItemCellTests: XCTestCase {

    var cell: TodoListItemCell?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cell = TodoListItemCell()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConfigure() throws {
        cell?.configure(.init(listItem: .init(userId: 1, id: 1, title: "Hallo", completed: false)))
        
        XCTAssert(cell?.titleLabel.text == "Hallo")
    }
}
