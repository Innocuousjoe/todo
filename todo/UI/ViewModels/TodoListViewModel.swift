import Foundation

class TodoListViewModel {
    
    var listItems: [RemoteListItem]?
    
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
}
