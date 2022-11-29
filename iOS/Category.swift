import Foundation

enum Category: Hashable {
    case
    bookmarks,
    history,
    readingList,
    downloads,
    forget,
    report,
    settings,
    sponsor,
    policy,
    about,
    tab(UUID)
    
    var title: String {
        switch self {
        case .tab:
            return "Tabs"
        case .bookmarks:
            return "Bookmarks"
        case .history:
            return "History"
        case .readingList:
            return "Reading list"
        case .downloads:
            return "Downloads"
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
        case .tab:
            return "square.on.square.dashed"
        case .bookmarks:
            return "bookmark"
        case .history:
            return "clock"
        case .readingList:
            return "eyeglasses"
        case .downloads:
            return "square.and.arrow.down"
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
