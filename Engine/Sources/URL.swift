import Foundation

extension URL {
    public static func temporal(_ name: String) -> Self {
        .init(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
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
    
    public var download: URL? {
        (try? Data(contentsOf: self))
            .map {
                $0.temporal({
                    $0.isEmpty ? "Website.html" : $0.contains(".") && $0.last != "." ? $0 : $0 + ".html"
                } (lastPathComponent.replacingOccurrences(of: "/", with: "")))
            }
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
        get {
            guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
            components.scheme = nil
            components.query = nil
            components.path = components.path.components(separatedBy: "/").prefix(2).joined(separator: "/")
            components.fragment = nil
            guard
                let string = components.string?.replacingOccurrences(of: "//", with: ""),
                let encoded = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            else { return nil }
            return encoded
        }
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
