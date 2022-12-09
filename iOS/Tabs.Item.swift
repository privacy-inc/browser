import SwiftUI

extension Tabs {
    struct Item: View, Equatable {
        @ObservedObject var session: Session
        let id: UUID
        
        var body: some View {
            NavigationLink(value: Category.tab(id)) {
                if let tab = session.tabs[id] {
                    if let error = tab.error {
                        Website(info: .init(error: error))
                    } else if let webview = tab.webview {
                        Website(info: .init(webview: webview, favicon: session.favicon))
                    } else {
                        HStack(spacing: 5) {
                            Image(systemName: "plus.viewfinder")
                                .font(.system(size: 16, weight: .medium))
                                .symbolRenderingMode(.hierarchical)
                                .frame(width: 22, height: 22)
                                .offset(x: -5)
                                .padding(.vertical, 7)
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
