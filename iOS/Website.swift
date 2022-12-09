import SwiftUI
import Domains

struct Website: View {
    @StateObject var info: Info
    
    var body: some View {
        HStack(spacing: 5) {
            ZStack {
                if info.error {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 22, weight: .medium))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.orange)
                } else if let image = info.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                }
            }
            .frame(width: 22, height: 22)
            .offset(x: -5)
            .padding(.vertical, 7)
            
            Text("\(info.title)\(Text(info.domain).foregroundColor(.secondary).font(.footnote.weight(.regular)))")
                .font(.callout.weight(.regular))
                .foregroundColor(.primary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)

            if info.badge {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 10, height: 10)
            }
        }
    }
}
