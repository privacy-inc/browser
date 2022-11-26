import SwiftUI

struct Navigation: View {
    @ObservedObject var session: Session
    
    var body: some View {
        NavigationSplitView {
            Sidebar(session: session)
        } detail: {
            content
        }
    }
    
    @ViewBuilder private var content: some View {
        switch session.sidebar {
        case .tabs:
            Tabs(session: session)
        case .bookmarks:
            Bookmarks(session: session)
        case .history:
            History(session: session)
        case .readingList:
            Reads(session: session)
        case .downloads:
            Downloads(session: session)
        default:
            EmptyView()
        }
    }
}
