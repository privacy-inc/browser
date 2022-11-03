import SwiftUI

struct Content: View {
    @ObservedObject var session: Session
    
    var body: some View {
        if let id = session.sidebar,
           let webview = session[tab: id] {
            Browser(webview: webview)
                .toolbar(.hidden, for: .navigationBar)
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Bar(session: session)
                    }
                }
        }
    }
}
