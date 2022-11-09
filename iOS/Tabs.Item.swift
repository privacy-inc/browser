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
                    WebsiteItem(session: session, url: url ?? "", title: title ?? "")
                        .onReceive(web.publisher(for: \.title)) {
                            title = $0
                        }
                        .onReceive(web.publisher(for: \.url)) {
                            url = $0?.absoluteString
                        }
                } else {
                    Text("New tab")
                        .foregroundColor(.accentColor)
                        .font(.body.weight(.bold))
                        .frame(minHeight: 40)
                }
            }
        }
    }
}
