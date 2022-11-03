import SwiftUI

struct Navigation: View {
    @StateObject private var session = Session()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $session.columns) {
            Sidebar(session: session)
        } detail: {
            Detail(id: session.sidebar, session: session)
        }
    }
}
