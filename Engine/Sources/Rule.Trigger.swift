extension Rule {
    enum Trigger: Equatable {
        case
        all,
        scripts,
        url(Allowed)
        
        var content: String {
            switch self {
            case .all:
                return """
        "url-filter": ".*"
        """
            case .scripts:
                return """
        "url-filter": ".*",
        "load-type": ["third-party"],
        "resource-type": ["script"]
        """
            case let .url(url):
                return """
        "url-filter": "^https?://+([^:/]+\\\\.)?\(url.rawValue)\\\\.\(url.tld)[:/]",
        "url-filter-is-case-sensitive": true,
        "if-domain": ["*\(url.rawValue).\(url.tld.rawValue)"],
        "load-type": ["first-party"],
        "resource-type": ["document"]
        """
            }
        }
    }
}
