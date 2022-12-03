import SwiftUI

extension Tabs {
    struct Item: View, Equatable {
        @ObservedObject var session: Session
        let id: UUID
        @State private var title: String?
        @State private var url: String?
        
        var body: some View {
            NavigationLink(value: Category.tab(id)) {
                if let tab = session.tabs[id] {
                    if let error = tab.error {
                        Website(session: session,
                                url: error.url?.absoluteString ?? "",
                                title: error.message,
                                error: true)
                    } else if let web = tab.webview {
                        Website(session: session,
                                url: url ?? "",
                                title: title ?? "")
                            .onReceive(web.publisher(for: \.title)) {
                                title = $0
                            }
                            .onReceive(web.publisher(for: \.url)) {
                                url = $0?.absoluteString
                            }
                    } else {
                        HStack(spacing: 5) {
                            Image(systemName: "plus.viewfinder")
                                .font(.system(size: 16, weight: .medium))
                                .symbolRenderingMode(.hierarchical)
                                .frame(width: 22, height: 22)
                                .offset(x: -5)
                            Text("New tab")
                                .font(.callout.weight(.regular))
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        }
                    }
                }
            }
        }
        
        nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
}
