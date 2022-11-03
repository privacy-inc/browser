import SwiftUI

extension Sidebar {
    struct Item: View {
        @ObservedObject var session: Session
        let id: UUID
        
        var body: some View {
            NavigationLink(value: id) {
                HStack {
                    Image(systemName: "network")
                        .frame(width: 36, height: 36)
                    VStack(alignment: .leading) {
                        Text(session[tab: id]?.title ?? "")
                            .font(.body.weight(.medium))
                        Text(session[tab: id]?.url?.absoluteString ?? "")
                            .foregroundStyle(.secondary)
                            .font(.init(UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .light, width: .condensed)))
                    }
                    .lineLimit(1)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .padding(.vertical, 10)
            }
        }
    }
}
