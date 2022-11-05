import SwiftUI

struct Detail: View {
    let id: UUID
    @ObservedObject var session: Session
    
    var body: some View {
        ZStack {
            if let webview = session[tab: id] {
                Browser(webview: webview)
            } else {
                Button {
                    session.field.becomeFirstResponder()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .foregroundColor(.secondary)
                        .contentShape(Rectangle())
                        .frame(width: 120, height: 120)
                }
                .ignoresSafeArea(.keyboard)
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
