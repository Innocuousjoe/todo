import Foundation
import UIKit
import CoreData
import Moya

class TodoListState: TodoListStateProtocol {
    let api: APIProvider
    init(_ api: APIProvider) {
        self.api = api
    }
    
    private func existingItemRequest(_ id: Int) -> NSFetchRequest<ListItem> {
        let request = NSFetchRequest<ListItem>(entityName: "ListItem")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "id = %d", id)
        
        return request
    }
    
    func fetchTodoListItems(_ completion: @escaping (Swift.Result<[RemoteListItem], Error>) -> Void) {
        api.request(.getTaskList) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    completion(.failure(NSError(domain: "persistence", code: 123)))
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                
                do {
                    let items = try response.map([RemoteListItem].self)
                    items.forEach { remoteItem in
                        if let existingItem = try? managedContext.fetch(self.existingItemRequest(remoteItem.id)).first {
                            existingItem.setValue(remoteItem.userId, forKey: "userId")
                            existingItem.setValue(remoteItem.title, forKey: "title")
                            existingItem.setValue(remoteItem.completed, forKey: "completed")
                            
                        } else {
                            let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: managedContext)!
                            let newItem = NSManagedObject(entity: entity, insertInto: managedContext)
                            newItem.setValue(remoteItem.id, forKey: "id")
                            newItem.setValue(remoteItem.userId, forKey: "userId")
                            newItem.setValue(remoteItem.title, forKey: "title")
                            newItem.setValue(remoteItem.completed, forKey: "completed")
                        }
                    }
                    
                    try managedContext.save()
                    
                    completion(.success(items))
                } catch(let error) {
                    print(error)
                }
            case .failure(let error):
                print("Uh-oh! \(error.localizedDescription)")
            }
        }
    }
}
