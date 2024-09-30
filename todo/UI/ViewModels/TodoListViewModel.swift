import Foundation
import CoreData
import UIKit

class TodoListViewModel {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Hashable {
        case listItems
    }
    
    enum Item: Hashable {
        case item(TodoListItemCell.ViewModel)
    }
    
    var listItems: [ListItem] {
        listItemFRC.fetchedObjects as? [ListItem] ?? []
    }
    
    private lazy var listItemFRC: NSFetchedResultsController<NSManagedObject> = {
        let newFRC = NSFetchedResultsController(
            fetchRequest: listItemRequest,
            managedObjectContext: viewContext!,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        newFRC.delegate = frcDelegate
        
        return newFRC
    }()
    
    private lazy var frcDelegate: FetchedResultsControllerDelegate = {
        return FetchedResultsControllerDelegate(
            onChange: { [weak self] in self?.updateSnapshot() }
        )
    }()
    
    private var listItemRequest: NSFetchRequest = {
        let request = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        request.predicate = NSPredicate(format: "userId = 3")
        request.sortDescriptors = []
        
        return request
    }()
    
    var onSnapshotUpdate: ((_ snapshot: Snapshot) -> Void)?
    
    let listState: TodoListStateProtocol
    var viewContext: NSManagedObjectContext?
    
    init(_ state: TodoListStateProtocol) {
        listState = state
        viewContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    func viewDidLoad() {
        try! listItemFRC.performFetch()
        listState.fetchTodoListItems { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
//                self.listItems = items
                ()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateSnapshot() {
        var snapshot = Snapshot()
        defer { onSnapshotUpdate?(snapshot) }
        
        snapshot.appendSections([.listItems])
        snapshot.appendItems(listItems.map { .item(.init(listItem: $0)) })
    }
}

