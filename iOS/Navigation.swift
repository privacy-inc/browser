import SwiftUI

struct Navigation: View {
    @StateObject private var session = Session()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $session.colums) {
            Sidebar(session: session)
        } content: {
            Content(session: session)
        } detail: {
            Detail(session: session)
        }
    }
}
