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
                Spacer()
                
                Button {
                    session.field.becomeFirstResponder()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .contentShape(Rectangle())
                        .frame(width: 100, height: 100)
                }
                .ignoresSafeArea(.keyboard)
                
                Spacer()
            }
            
            Search(session: session)
                .frame(height: 0)
        }
        .id(id)
        .toolbar(.hidden, for: .navigationBar)
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .safeAreaInset(edge: .top, spacing: 0) {
            Top(session: session, id: id)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if case let .tab(id) = session.sidebar,
               let tab = session.tabs[id],
               tab.error == nil {
                Bar(session: session, tab: tab)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}
