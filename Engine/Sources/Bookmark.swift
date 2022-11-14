import Foundation
import Archivable
import Domains

public struct Bookmark: Storable, Hashable, Website, Sendable {
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
    
    public init?(url: String, title: String) {
        guard var value = URL(string: url) else { return nil }
        
        if value.scheme == nil {
            if let complete = URL(string: "http://\(url)") {
                value = complete
            } else {
                return nil
            }
        }
        
        self.init(value.absoluteString, title)
    }
    
    init(_ url: String, _ title: String) {
        self.url = url
        self.title = title
    }
}
