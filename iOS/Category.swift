enum Category {
    case
    tabs,
    bookmarks,
    history,
    readingList,
    forget,
    report,
    settings,
    sponsor,
    policy,
    about
    
    var title: String {
        switch self {
        case .tabs:
            return "Tabs"
        case .bookmarks:
            return "Bookmarks"
        case .history:
            return "History"
        case .readingList:
            return "Reading list"
        case .forget:
            return "Forget"
        case .report:
            return "Privacy report"
        case .settings:
            return "Settings"
        case .sponsor:
            return "Sponsor"
        case .policy:
            return "Privacy policy"
        case .about:
            return "About"
        }
    }
    
    var image: String {
        switch self {
        case .tabs:
            return "square.on.square.dashed"
        case .bookmarks:
            return "bookmark"
        case .history:
            return "clock"
        case .readingList:
            return "eyeglasses"
        case .forget:
            return "flame"
        case .report:
            return "checkerboard.shield"
        case .settings:
            return "gear"
        case .sponsor:
            return "heart"
        case .policy:
            return "hand.raised"
        case .about:
            return "star"
        }
    }
}
