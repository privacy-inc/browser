import SwiftUI

struct Navigation: View {
    @StateObject private var session = Session()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $session.columns) {
            Sidebar(session: session)
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Tabber(session: session)
                    }
                }
        } content: {
            content
                .toolbar {
                    if !(UIDevice.current.userInterfaceIdiom == .pad && session.columns == .all) {
                        ToolbarItem(placement: .bottomBar) {
                            Tabber(session: session)
                        }
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
