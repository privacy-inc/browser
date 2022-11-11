import Foundation
import Archivable

public struct Bookmark: Storable, Hashable, Website {
    public let url: String
    public let title: String
    
    public var data: Data {
        .init()
        .adding(size: UInt16.self, string: url)
        .adding(size: UInt16.self, string: title)
    }
    
    public init(data: inout Data) {
        url = data.string(size: UInt16.self)
        title = data.string(size: UInt16.self)
    }
    
    public init(url: String, title: String) {
        self.url = url
        self.title = title
    }
}
