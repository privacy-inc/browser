import Foundation
import Archivable

struct Archive_v1: Arch {
    var timestamp: UInt32
    let bookmarks: [Bookmark_v1]

    var data: Data {
        .init()
        .adding(size: UInt16.self, collection: bookmarks)
    }
    
    init() {
        fatalError()
    }
    
    init(bookmarks: [Bookmark_v1]) {
        timestamp = 0
        self.bookmarks = bookmarks
    }
    
    init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        bookmarks = data.collection(size: UInt16.self)
    }
}
