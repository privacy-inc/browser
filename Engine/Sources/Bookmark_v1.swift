import Foundation
import Archivable

struct Bookmark_v1: Storable {
    let id: String
    let title: String
    
    var data: Data {
        .init()
        .adding(size: UInt16.self, string: id)
        .adding(size: UInt16.self, string: title)
    }
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    init(data: inout Data) {
        id = data.string(size: UInt16.self)
        title = data.string(size: UInt16.self)
    }
}
