import Foundation
import UIKit

class TodoListViewModel {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Hashable {
        case listItems
    }
    
    enum Item: Hashable {
        case item(TodoListItemCell.ViewModel)
    }
    
    var listItems: [RemoteListItem] = [] {
        didSet {
            updateSnapshot()
        }
    }
    
    var onSnapshotUpdate: ((_ snapshot: Snapshot) -> Void)?
    
    let name: String
    let listState: TodoListStateProtocol
    
    init(_ state: TodoListStateProtocol) {
        name = "Test"
        listState = state
    }
    
    func viewDidLoad() {
        listState.fetchTodoListItems { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let items):
                self.listItems = items
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateSnapshot() {
        var snapshot = Snapshot()
        defer { onSnapshotUpdate?(snapshot) }
        
        snapshot.appendSections([.listItems])
        let filteredItems = listItems.filter { $0.userId == 3 }
        snapshot.appendItems(filteredItems.map { .item(.init(listItem: $0)) })
    }
}
