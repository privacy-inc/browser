import SwiftUI

extension Tabs {
    struct Item: View {
        @ObservedObject var session: Session
        let id: UUID
        @State private var title: String?
        @State private var url: String?
        
        var body: some View {
            NavigationLink(value: id) {
                HStack(spacing: 0) {
                    if let web = session[tab: id] {
                        Image(systemName: "network")
                            .frame(width: 32, height: 32)
                            .offset(x: -8)
                        VStack(alignment: .leading) {
                            Text(title ?? "")
                                .font(.body.weight(.medium))
                                .padding(.top, 2)
                            Text(url ?? "")
                                .foregroundStyle(.secondary)
                                .font(.init(UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize, weight: .light, width: .condensed)))
                        }
                        .onReceive(web.publisher(for: \.title)) {
                            title = $0
                        }
                        .onReceive(web.publisher(for: \.url)) {
                            url = $0?.absoluteString
                        }
                        .lineLimit(1)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    } else {
                        Text("New tab")
                            .font(.body.weight(.medium))
                            .padding(.vertical, 6)
                    }
                }
            }
        }
    }
}
