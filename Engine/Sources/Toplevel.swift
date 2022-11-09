import Foundation
import Domains

enum Toplevel: String, Filter {
    case
    cloudfront,
    googleapis
    
    static func response(for domain: Domain, on: URL) -> Policy? {
        Self(rawValue: domain.suffix.first!)
            .map {
                .block($0.rawValue)
            }
    }
}
