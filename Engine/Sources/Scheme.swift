import Foundation

public enum Scheme: String, Filter {
    case
    https,
    http,
    ftp,
    gmsg,
    privacy
    
    var policy: Policy {
        switch self {
        case .http, .https:
            return .allow
        case .ftp:
            return .ignore
        case .gmsg:
            return .block(Allowed.Subdomain.mobileads.rawValue)
        case .privacy:
            return .app
        }
    }
}
