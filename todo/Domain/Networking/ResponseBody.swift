import Foundation

struct RemoteListItem: Codable, Hashable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
