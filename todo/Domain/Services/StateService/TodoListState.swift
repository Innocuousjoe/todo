import Foundation
import Moya

class TodoListState: TodoListStateProtocol {
    let api: APIProvider
    init(_ api: APIProvider) {
        self.api = api
    }
    
    func fetchTodoListItems(_ completion: @escaping (Swift.Result<[RemoteListItem], Error>) -> Void) {
        api.request(.getTaskList) { result in
            switch result {
            case .success(let response):
                do {
                    let items = try response.map([RemoteListItem].self)
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
