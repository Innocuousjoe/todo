@testable import todo
import XCTest

final class todoListViewModelTests: XCTestCase {
    var viewModel: TodoListViewModel!
    
    override func setUpWithError() throws {
        viewModel = TodoListViewModel(MockTodoListState())
    }
    
    func testViewDidLoad() throws {
        viewModel.viewDidLoad()
        
        XCTAssert(viewModel.name == "Test")
        XCTAssert(viewModel.listItems?.count == 3)
    }
}
