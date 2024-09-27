import Foundation
import Moya

typealias APIProvider = MoyaProvider<API>

enum API {
    case getTaskList
}

extension API: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        switch self {
        case .getTaskList:
            return URL(string: "https://jsonplaceholder.typicode.com")!
        }
    }
    
    var path: String {
        switch self {
        case .getTaskList:
            return "todos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTaskList:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getTaskList:
            return .requestPlain
        }
    }
}
