import Foundation
import Domains

protocol Filter {
    var policy: Policy { get }
    static func response(for domain: Domain, on: URL) -> Policy?
}

extension Filter {
    var policy: Policy {
        .allow
    }
    
    static func response(for domain: Domain, on: URL) -> Policy? {
        .allow
    }
}
