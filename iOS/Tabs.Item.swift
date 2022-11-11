import SwiftUI

extension Tabs {
    struct Item: View {
        @ObservedObject var session: Session
        let id: UUID
        @State private var title: String?
        @State private var url: String?
        
        var body: some View {
            NavigationLink(value: id) {
                if let web = session[tab: id] {
                    Website(session: session, url: url ?? "", title: title ?? "")
                        .onReceive(web.publisher(for: \.title)) {
                            title = $0
                        }
                        .onReceive(web.publisher(for: \.url)) {
                            url = $0?.absoluteString
                        }
                } else {
                    HStack(spacing: 10) {
                        Image(systemName: "plus.viewfinder")
                            .font(.system(size: 24, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .frame(width: 28, height: 28)
                            .offset(x: -4)
                        Text("New tab")
                            .font(.callout.weight(.medium))
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    }
                    .frame(minHeight: 42)
                }
            }
        }
    }
}
