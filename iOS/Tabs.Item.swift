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
                    WebsiteItem(url: url ?? "", title: title ?? "")
                        .onReceive(web.publisher(for: \.title)) {
                            title = $0
                        }
                        .onReceive(web.publisher(for: \.url)) {
                            url = $0?.absoluteString
                        }
                } else {
                    Text("New tab")
                        .font(.body.weight(.medium))
                        .padding(.vertical, 8)
                }
            }
        }
    }
}
