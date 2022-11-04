import SwiftUI

extension Sidebar {
    struct Item: View {
        @ObservedObject var session: Session
        let id: UUID
        
        var body: some View {
            NavigationLink(value: id) {
                HStack(spacing: 0) {
                    Image(systemName: "network")
                        .frame(width: 32, height: 32)
                        .offset(x: -8)
                    VStack(alignment: .leading) {
                        Text(session[tab: id]?.title ?? "")
                            .font(.body.weight(.medium))
                            .padding(.top, 2)
                        Text(session[tab: id]?.url?.absoluteString ?? "")
                            .foregroundStyle(.secondary)
                            .font(.init(UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize, weight: .light, width: .condensed)))
                    }
                    .lineLimit(1)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
            }
        }
    }
}
