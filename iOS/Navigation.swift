import SwiftUI

struct Navigation: View {
    @ObservedObject var session: Session
    
    var body: some View {
        NavigationSplitView(columnVisibility: $session.columns) {
            Sidebar(session: session)
        } content: {
            content
                .navigationDestination(for: Content.self) { _ in
                    detail
                }
        } detail: {
            detail
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
    
    @ViewBuilder private var detail: some View {
        switch session.content {
        case let .tab(id):
            Detail(session: session, id: id)
        case let .bookmark(bookmark):
            Bookmarks.Edit(session: session, bookmark: bookmark)
        default:
            EmptyView()
        }
    }
}
