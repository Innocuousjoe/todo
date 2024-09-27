import Foundation

protocol TodoListStateProtocol {
    func fetchTodoListItems(_ completion: ((Swift.Result<[RemoteListItem], Error>) -> Void))
}
