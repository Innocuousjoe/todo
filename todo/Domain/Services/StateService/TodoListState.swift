import Foundation
import Moya

class TodoListState: TodoListStateProtocol {
    var onFetchSuccess: ((Swift.Result<[RemoteListItem], Error>) -> Void)?
    
    let api: APIProvider
    init(_ api: APIProvider) {
        self.api = api
    }
    
    func fetchTodoListItems(_ completion: (Swift.Result<[RemoteListItem], Error>) -> Void) {
        api.request(.getTaskList) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                do {
                    let items = try response.map([RemoteListItem].self)
                    onFetchSuccess?(.success(items))
                } catch(let error) {
                    print(error)
                }
            case .failure(let error):
                print("Uh-oh! \(error.localizedDescription)")
            }
        }
    }
}
