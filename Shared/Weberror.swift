import Foundation

struct Weberror: Hashable {
    static let urlCantBeShown = 101
    static let frameLoadInterrupted = 102
    
    let url: URL?
    let message: String
}
