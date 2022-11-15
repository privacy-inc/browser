import Foundation
import Domains

extension URL {
    public static func temporal(_ name: String) -> Self {
        .init(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
    }
    
    public var policy: Policy {
        scheme
            .map {
                Embeded(rawValue: $0)
                    .map(\.policy)
                ?? Scheme(rawValue: $0)
                    .map(\.policy)
                    .map {
                        guard $0 == .allow else { return $0 }
                        return host(percentEncoded: false)
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
    
    public var download: URL? {
        (try? Data(contentsOf: self))
            .map {
                $0.temporal({
                    $0.isEmpty ? "Website.html" : $0.contains(".") && $0.last != "." ? $0 : $0 + ".html"
                } (lastPathComponent.replacingOccurrences(of: "/", with: "")))
            }
    }
    
    public func file(_ type: String) -> String {
        absoluteString
            .components(separatedBy: ".")
            .dropLast()
            .last
            .map {
                $0.components(separatedBy: "/")
            }
            .flatMap(\.last)
            .map {
                $0 + "." + type
            }
        ?? "_." + type
    }
    
    var remoteString: String? {
        switch scheme {
        case "https", "http", "ftp":
            return absoluteString
        default:
            return nil
        }
    }
    
    var icon: String? {
        guard let host = host(percentEncoded: false) else { return nil }
        
        var string = Tld.domain(host: host).minimal
        if let component = pathComponents.dropFirst().first {
            string = "\(string)/\(component)"
        }
        
        guard
            let encoded = string
                .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else { return nil }
        
        return encoded
    }
    
#if os(macOS)

    var bookmark: Data {
        (try? bookmarkData(options: .withSecurityScope)) ?? .init()
    }

#elseif os(iOS)
    
    var bookmark: Data {
        _ = startAccessingSecurityScopedResource()
        let data = (try? bookmarkData()) ?? .init()
        stopAccessingSecurityScopedResource()
        return data
    }

#else

    var bookmark: Data {
        .init()
    }

#endif
}
