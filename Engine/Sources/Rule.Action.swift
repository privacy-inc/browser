extension Rule {
    enum Action {
        case
        block,
        blockCookies,
        cssNone(Set<String>)
        
        var content: String {
            switch self {
            case .blockCookies:
                return """
        "type": "block-cookies"
        """
            case .block:
                return """
        "type": "block"
        """
            case let .cssNone(css):
                return """
        "type": "css-display-none",
        "selector": "\(css.joined(separator: ", "))"
        """
            }
        }
    }
}
