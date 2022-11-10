import SwiftUI

struct Navigation: View {
    @StateObject private var session = Session()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $session.columns) {
            Sidebar(session: session)
        } content: {
            switch session.sidebar {
            case .tabs:
                Tabs(session: session)
            case .bookmarks:
                Bookmarks(session: session)
            case .history:
                History(session: session)
            default:
                EmptyView()
            }
        } detail: {
            switch session.sidebar {
            case .tabs:
                if let id = session.content as? UUID {
                    Detail(id: id, session: session)
                }
            default:
                EmptyView()
            }
        }
    }
}
