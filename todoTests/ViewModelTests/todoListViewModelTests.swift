@testable import todo
import CoreData
import XCTest

final class todoListViewModelTests: XCTestCase {
    var viewModel: TodoListViewModel!
    
    override func setUpWithError() throws {
        viewModel = TodoListViewModel(MockTodoListState())
        let _ = createInMemoryManagedObjectContext()!
////            .init(userId: 3, id: 2, title: "One", completed: false),
////            .init(userId: 4, id: 5, title: "Six", completed: true),
////            .init(userId: 7, id: 8, title: "Nine", completed: true)
//        [(userId: 3, id: 2, title: "One", completed: false),
//         (userId: 4, id: 5, title: "Six", completed: true),
//         (userId: 7, id: 8, title: "Nine", completed: false)
//        ].forEach { tuple in
//            let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: appContext)!
//            let newItem = NSManagedObject(entity: entity, insertInto: appContext)
//            newItem.setValue(tuple.id, forKey: "id")
//            newItem.setValue(tuple.userId, forKey: "userId")
//            newItem.setValue(tuple.title, forKey: "title")
//            newItem.setValue(tuple.completed, forKey: "completed")
//            
//            do {
//                try appContext.save()
//            } catch {
//                print("Error saving list item in test")
//            }
//        }
    }
    
    func testViewDidLoad() throws {
        viewModel.onSnapshotUpdate = { snapshot in
            XCTAssert(snapshot.sectionIdentifiers.count == 1)
            XCTAssert(snapshot.itemIdentifiers.count == 1)
        }
        viewModel.viewDidLoad()

        print(viewModel.listItems.count)
        XCTAssert(viewModel.listItems.count == 140)
    }
}
