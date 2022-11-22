import SwiftUI

struct Navigation: View {
    @StateObject private var session = Session()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $session.columns) {
            Sidebar(session: session)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    Tabber(session: session)
                }
        } content: {
            content
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    if !(UIDevice.current.userInterfaceIdiom == .pad && session.columns == .all) {
                        Tabber(session: session)
                    }
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
