import SwiftUI

struct Detail: View {
    let id: UUID
    @ObservedObject var session: Session
    
    var body: some View {
        ZStack {
            if let webview = session[tab: id] {
                Browser(webview: webview)
            }
            Search(session: session)
                .frame(height: 0)
        }
        .id(id)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Bar(session: session)
            }
        }
    }
}
