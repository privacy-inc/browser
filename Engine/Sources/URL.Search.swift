import Foundation
import Domains

private let google = "https://www.google.com/search"
private let dataPrefix = "\(Embeded.data.rawValue):"
private let filePrefix = "\(Embeded.file.rawValue):"

extension URL {
    public init?(search: String) {
        guard let search = search
            .trimmed(transform: {
                $0.hasPrefix(dataPrefix)
                || $0.hasPrefix(filePrefix)
                    ? $0
                    : $0.url
                        ?? $0.file
                        ?? $0.partial
                        ?? Self.query(search: $0)
            })
        else { return nil }
        self.init(string: search)
    }
    
    public var searchbar: String {
        guard
            absoluteString.hasPrefix(google),
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let query = components.queryItems?.first(where: { $0.name == "q" }),
            let search = query.value,
            !search.isEmpty
        else { return absoluteString.domain }
        return search
    }
    
    private static func query(search: String) -> String? {
        var components = URLComponents(string: google)!
        components.queryItems = [.init(name: "q", value: search)]
        return components.string
    }
}

private extension String {
    func trimmed(transform: (Self) -> Self?) -> Self? {
        {
            $0.isEmpty ? nil : transform($0)
        } (trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    var url: Self? {
        (.init(string: self)
            ?? addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed.union(.urlFragmentAllowed))
            .flatMap(URL.init(string:)))
                .flatMap {
                    $0.scheme != nil && ($0.host != nil || $0.query != nil)
                        ? ($0.scheme?.contains("http") == true ? $0.absoluteString.urlCased : $0.absoluteString)
                        : nil
                }
    }
    
    var file: Self? {
        {
            $0
                .flatMap {
                    $0.isFileURL ? self : nil
                }
        } (URL(string: self))
    }
    
    var partial: Self? {
        {
            $0.count > 1
            && $0
                .last
                .flatMap {
                    Tld.suffix[$0.lowercased()]
                } != nil
            && true
                && !$0.first!.isEmpty
                && !contains(" ")
                ? "https://" + self
                : nil
        } (components(separatedBy: "/")
            .first!
            .components(separatedBy: "."))
    }
    
    var urlCased: Self {
        {
            ($0.count > 1 ? $0.first! + "://" : "") + {
                $0.first!.lowercased() + ($0.count > 1 ? "/" + $0.dropFirst().joined(separator: "/") : "")
            } ($0.last!.components(separatedBy: "/"))
        } (components(separatedBy: "://"))
    }
}
