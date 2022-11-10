import Foundation
import Archivable

public struct Log: Storable {
    public let domain: String
    public let url: String
    
    public var data: Data {
        .init()
        .adding(size: UInt8.self, string: domain)
        .adding(size: UInt8.self, string: url)
    }
    
    public init(data: inout Data) {
        domain = data.string(size: UInt8.self)
        url = data.string(size: UInt8.self)
    }
    
    init(domain: String, url: String) {
        self.domain = domain
        self.url = url
    }
}
