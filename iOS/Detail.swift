import SwiftUI

struct Detail: View {
    let id: UUID?
    @ObservedObject var session: Session
    
    var body: some View {
        if let id,
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
