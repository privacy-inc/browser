import Foundation
import Domains
import UniformTypeIdentifiers

extension URL {
    public static func saveTemporal(as name: String) -> Self {
        .init(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
    }
    
    public var isImage: Bool {
        guard
            let type = UTType(filenameExtension: absoluteString
                .components(separatedBy: ".")
                .last!
                .lowercased()),
            type.conforms(to: .movie) || type.conforms(to: .image)
        else { return false }
        return true
    }
    
    public func temporalDownload() async -> Self? {
        guard
            let (data, _) = try? await URLSession.shared.data(from: self)
        else { return nil }
        
        return data
            .saveTemporal(as: {
                $0.isEmpty ? "Website.html" : $0.contains(".") && $0.last != "." ? $0 : $0 + ".html"
            } (lastPathComponent.replacingOccurrences(of: "/", with: "")))
    }
    
    public func fileName(with type: String) -> String {
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
    
    var asRemoteString: String? {
        switch scheme {
        case "https", "http", "ftp":
            return absoluteString
        default:
            return nil
        }
    }
    
    var iconIdentifier: String? {
        guard let host = self.host else { return nil }
        
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
