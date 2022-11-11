import Foundation
import Archivable

public struct Read: Storable, Website {
    public let url: String
    public let title: String
    public let read: Bool
    
    public var data: Data {
        .init()
        .adding(size: UInt16.self, string: url)
        .adding(size: UInt16.self, string: title)
        .adding(read)
    }
    
    public init(data: inout Data) {
        url = data.string(size: UInt16.self)
        title = data.string(size: UInt16.self)
        read = data.bool()
    }
    
    public init(url: String, title: String) {
        self.init(url: url, title: title, read: false)
    }
    
    private init(url: String, title: String, read: Bool) {
        self.url = url
        self.title = title
        self.read = read
    }
    
    public func done() -> Self {
        .init(url: url, title: title, read: true)
    }
}
