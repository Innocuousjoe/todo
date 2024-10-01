@testable import todo
import CoreData

class MockListItems {
    func createObject(with details: (userId: Int, id: Int, title: String, completed: Bool), in context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: context)!
        let newItem = NSManagedObject(entity: entity, insertInto: context)
        newItem.setValue(details.id, forKey: "id")
        newItem.setValue(details.userId, forKey: "userId")
        newItem.setValue(details.title, forKey: "title")
        newItem.setValue(details.completed, forKey: "completed")
    }
}
