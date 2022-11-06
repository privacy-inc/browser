import Foundation
import Archivable

public struct History: Storable, Website {
    public let url: String
    public let title: String
    public let date: UInt32
    
    public var data: Data {
        .init()
        .adding(size: UInt16.self, string: url)
        .adding(size: UInt16.self, string: title)
        .adding(date)
    }
    
    public init(data: inout Data) {
        url = data.string(size: UInt16.self)
        title = data.string(size: UInt16.self)
        date = data.number()
    }
    
    public init(url: String, title: String) {
        self.url = url
        self.title = title
        date = .now
    }
}
