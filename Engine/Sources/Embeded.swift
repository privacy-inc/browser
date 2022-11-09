enum Embeded: String, Filter {
    case
    about,
    data,
    file,
    blob
    
    var policy: Policy {
        switch self {
        case .about, .blob:
            return .ignore
        case .data, .file:
            return .allow
        }
    }
}
