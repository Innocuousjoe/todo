@testable import todo
import CoreData
import XCTest

final class todoListViewModelTests: XCTestCase {
    func testViewDidLoad() throws {
        let viewModel = TodoListViewModel(MockTodoListState())
        var calledSnapshotUpdate = false
        viewModel.onSnapshotUpdate = { snapshot in
            XCTAssert(snapshot.sectionIdentifiers.count == 1)
            calledSnapshotUpdate = true
        }
        
        viewModel.viewDidLoad()
        
        XCTAssert(calledSnapshotUpdate)
    }
}
