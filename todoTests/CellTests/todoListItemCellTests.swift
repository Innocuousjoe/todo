@testable import todo
import XCTest
import CoreData

final class todoListItemCellTests: XCTestCase {

    var cell: TodoListItemCell?
    var listItem: ListItem?
    private var appContext: NSManagedObjectContext?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        appContext = createInMemoryManagedObjectContext()
        let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: appContext!)!
        let newItem = NSManagedObject(entity: entity, insertInto: appContext)
        newItem.setValue(1, forKey: "id")
        newItem.setValue(1, forKey: "userId")
        newItem.setValue("Hallo", forKey: "title")
        newItem.setValue(false, forKey: "completed")
        do {
            try appContext?.save()
            listItem = newItem as? ListItem
        } catch {
            print("Error saving list item in test")
        }
        cell = TodoListItemCell()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConfigure() throws {
        cell?.configure(.init(listItem: listItem!, title: listItem!.title!))
        
        XCTAssert(cell?.titleLabel.text == "Hallo")
    }
}
