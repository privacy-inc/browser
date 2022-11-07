import SwiftUI
import Domains

struct WebsiteItem: View {
    let url: String
    let title: String
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "network")
                .frame(width: 32, height: 32)
                .offset(x: -8)
            Text("\(title.isEmpty ? title : title + " ")\(Text(url.domain).foregroundColor(.secondary).font(.footnote))")
                .font(.body.weight(.regular))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        }
        .foregroundColor(.primary)
        .frame(minHeight: 38)
    }
}
