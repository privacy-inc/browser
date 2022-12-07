import SwiftUI
import Domains

struct Website: View {
    let session: Session
    @State private var image: UIImage?
    private let url: String
    private let title: String
    private let domain: String
    private let error: Bool
    private let badge: Bool
    
    init(session: Session,
         url: String,
         title: String,
         error: Bool = false,
         badge: Bool = false) {
        
        self.session = session
        self.url = url
        self.domain = url.domain
        self.title = (title.isEmpty ? (url.components(separatedBy: "://").last ?? url) : title) + " "
        self.error = error
        self.badge = badge
    }
    
    var body: some View {
        HStack(spacing: 5) {
            ZStack {
                if error {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 22, weight: .medium))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.orange)
                } else if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                }
            }
            .frame(width: 22, height: 22)
            .offset(x: -5)
            .padding(.vertical, 7)
            
            Text("\(title)\(Text(domain).foregroundColor(.secondary).font(.footnote.weight(.regular)))")
                .font(.callout.weight(.regular))
                .foregroundColor(.primary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)

            if badge {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 10, height: 10)
            }
        }
        .task {
            guard let url = URL(string: url) else { return }
            image = await session.favicon.icon(for: url)
        }
    }
}
