import Foundation
import Archivable

public struct Archive: Arch {
    public static let version = UInt8(2)
    public var timestamp: UInt32
    public internal(set) var bookmarks: [Bookmark]
    public internal(set) var history: [History]
    public internal(set) var tracking: Tracking
    
    public var data: Data {
        .init()
        .adding(size: UInt16.self, collection: bookmarks)
        .adding(size: UInt16.self, collection: history)
        .adding(tracking)
    }
    
    public init() {
        timestamp = 0
        bookmarks = []
        history = []
        tracking = .init()
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        switch version {
        case Self.version:
            bookmarks = data.collection(size: UInt16.self)
            history = data.collection(size: UInt16.self)
            tracking = .init(data: &data)
        case 1:
            bookmarks = await Archive_v1(version: version, timestamp: timestamp, data: data)
                .bookmarks
                .map {
                    .init(url: $0.id, title: $0.title)
                }
            history = []
            tracking = .init()
        default:
            bookmarks = []
            history = []
            tracking = .init()
        }
    }
}
