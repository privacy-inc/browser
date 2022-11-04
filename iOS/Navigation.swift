import SwiftUI

struct Navigation: View {
    @StateObject private var session = Session()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $session.columns) {
            Sidebar(session: session)
        } content: {
            switch session.sidebar {
            case .tabs:
                Detail(id: .init(), session: session)
            default:
                EmptyView()
            }
            
            
        } detail: {
            
        }
    }
}
