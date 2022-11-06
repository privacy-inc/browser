import SwiftUI

extension History {
    struct Item: View {
        let url: String
        let title: String
        
        var body: some View {
            Button {
                
            } label: {
                HStack(spacing: 0) {
                    Image(systemName: "network")
                        .frame(width: 32, height: 32)
                        .offset(x: -8)
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.body.weight(.medium))
                            .padding(.top, 2)
                        Text(url)
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
