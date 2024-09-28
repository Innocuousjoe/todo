import Foundation

protocol TodoListStateProtocol {
    func fetchTodoListItems(_ completion: @escaping ((Swift.Result<[RemoteListItem], Error>) -> Void))
}
