@testable import todo
import Foundation

class MockTodoListState: TodoListStateProtocol {
    func fetchTodoListItems(_ completion: ((Result<[RemoteListItem], Error>) -> Void)) {
        let items: [RemoteListItem] = 
        [
            .init(userId: 1, id: 2, title: "Three", completed: false),
            .init(userId: 4, id: 5, title: "Six", completed: true),
            .init(userId: 7, id: 8, title: "Nine", completed: true)
        ]
        
        completion(.success(items))
    }
}
