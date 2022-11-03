import Foundation
import Archivable

public struct Settings: Storable, Equatable, Sendable {
    public var search: Search
    
    public var data: Data {
        .init()
        .adding(search.rawValue)
    }
    
    public init(data: inout Data) {
        search = .init(rawValue: data.number())!
    }
    
    public init() {
        search = .google
    }
}
