import Foundation
import Domains

enum Subdomain: String, Filter {
    case
    sourcepoint,
    sourcepointcmp,
    tcf2
    
    static func response(for domain: Domain, on: URL) -> Policy? {
        domain
            .prefix
            .last
            .flatMap { prefix in
                Self(rawValue: prefix)
                    .map {
                        .block($0.rawValue)
                    }
            }
    }
}
