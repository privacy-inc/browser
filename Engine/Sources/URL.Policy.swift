import Foundation
import Domains

extension URL {
    public var policy: Policy {
        scheme
            .map {
                Embeded(rawValue: $0)
                    .map(\.policy)
                ?? Scheme(rawValue: $0)
                    .map(\.policy)
                    .map {
                        guard $0 == .allow else { return $0 }
                        return host
                            .map(Tld.domain(host:))
                            .map { domain in
                                guard !domain.suffix.isEmpty else { return .ignore }
                                
                                for filter in [Subdomain.self,
                                               Allowed.self,
                                               Blocked.self,
                                               Toplevel.self] as [any Filter.Type] {
                                    guard let response = filter.response(for: domain, on: self) else { continue }
                                    return response
                                }
                                
                                return .allow
                            }
                        ?? .ignore
                    }
                ?? .deeplink
            }
            ?? .ignore
    }
}
