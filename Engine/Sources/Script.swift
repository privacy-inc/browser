public enum Script {
    case
    favicon,
    dark,
    unpromise,
    find,
    text,
    location,
    video,
    image
    
    public var script: String {
        switch self {
        case .favicon:
            return Self._favicon
//        case .dark:
//            return Self._dark
//        case .unpromise:
//            return Self._unpromise
//        case .find:
//            return Self._find
//        case .text:
//            return Self._text
//        case .location:
//            return Self._location
        case .video:
            return "_privacy_incognit_finder(\"video\");"
        case .image:
            return "_privacy_incognit_finder(\"img\");"
        default: return ""
        }
    }
    
    public var method: String {
        switch self {
        case .favicon:
            return "GoPrivacyApp_favicon()"
        case .location:
            return "GoPrivacyApp_location"
        default:
            return ""
        }
    }
}
