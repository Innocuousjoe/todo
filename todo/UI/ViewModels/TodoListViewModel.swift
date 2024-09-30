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
        case addItem
    }
    
    enum Page {
        case active
        case completed
        case all
    }
    
    var listItems: [ListItem] {
        let items = listItemFRC.fetchedObjects as? [ListItem] ?? []
        
        switch page {
        case .active:
            return items.filter { !$0.completed }
        case .completed:
            return items.filter { $0.completed }
        case .all:
            return items
        }
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
    
    var page: Page = .active {
        didSet {
            updateSnapshot()
        }
    }
    
    let listState: TodoListStateProtocol
    var viewContext: NSManagedObjectContext?
    
    init(_ state: TodoListStateProtocol) {
        listState = state
        viewContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    func didTapNewPage(_ newPage: Page) {
        guard newPage != page else { return }
        self.page = newPage
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
    
    func addOrUpdate(_ title: String, listItem: ListItem? = nil) {
        guard let viewContext else { return }
        if let listItem {
            listItem.setValue(title, forKey: "title")
        } else if let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: viewContext) {
            let newItem = NSManagedObject(entity: entity, insertInto: viewContext)
            //        newItem.setValue(UUID(), forKey: "id")
            newItem.setValue(3, forKey: "userId")
            newItem.setValue(title, forKey: "title")
            newItem.setValue(page == .completed, forKey: "completed")
        }
        
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func toggleCheck(_ listItem: ListItem) {
        guard let viewContext else { return }
        do {
            listItem.setValue(!listItem.completed, forKey: "completed")
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func deleteItem(_ listItem: ListItem, completion: @escaping (Bool) -> Void) {
        guard 
            let viewContext
        else {
            completion(false)
            return
        }
        
        do {
            viewContext.delete(listItem)
            try viewContext.save()
            completion(true)
        } catch {
            print(error)
        }
    }
    
    //MARK: Private
    private func updateSnapshot() {
        var snapshot = Snapshot()
        defer { onSnapshotUpdate?(snapshot) }
        
        snapshot.appendSections([.listItems])
        snapshot.appendItems(listItems.map { .item(.init(listItem: $0)) })
        snapshot.appendItems([.addItem])
    }
}

