import SwiftUI
import Domains

struct Website: View {
    let session: Session
    private let url: String
    private let title: String
    private let domain: String
    private let badge: Bool
    @StateObject private var icon = Icon()
    
    init(session: Session, url: String, title: String, badge: Bool = false) {
        self.session = session
        self.url = url
        self.domain = url.domain
        self.title = (title.isEmpty ? (url.components(separatedBy: "://").last ?? url) : title) + "\n"
        self.badge = badge
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let image = icon.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .frame(width: 28, height: 28)
                    .allowsHitTesting(false)
                    .offset(x: -4)
                    .padding(.vertical, 3)
            }
            Text("\(title)\(Text(domain).foregroundColor(.secondary).font(.footnote.weight(.light)))")
                .font(.callout.weight(.regular))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            
            if badge {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 10, height: 10)
            }
        }
        .frame(minHeight: 42)
        .onChange(of: url) { url in
            Task {
                await update(url: url)
            }
        }
        .task {
            await update(url: url)
        }
        .onAppear {
            Task {
                await update(url: url)
            }
        }
    }
    
    @MainActor private func update(url: String) async {
        await icon.load(favicon: session.favicon, website: .init(string: url))
    }
}
