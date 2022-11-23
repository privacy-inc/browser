import SwiftUI

struct Detail: View {
    @ObservedObject var session: Session
    let id: UUID
    
    var body: some View {
        VStack(spacing: 0) {
            if let tab = session.tabs[id], let webview = tab.webview {
                if let error = tab.error {
                    Error(session: session, error: error)
                } else {
                    Tab(session: session, webview: webview)
                }
            } else {
                NewTab(session: session)
            }
            
            Divider()
            
            Search(session: session)
                .frame(height: 0)
        }
        .id(id)
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Bar(session: session)
        }
        .ignoresSafeArea(.keyboard)
    }
}
