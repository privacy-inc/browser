import SwiftUI
import Domains

private let size = CGFloat(32)

private let empty: UIImage = {
    UIGraphicsBeginImageContext(.init(width: 1, height: 1))
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
} ()

private let blank: UIImage = {
    UIGraphicsBeginImageContext(.init(width: size, height: size))
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
} ()

struct WebsiteItem: View {
    let session: Session
    private let url: String
    private let title: String
    private let domain: String
    @StateObject private var icon = Icon()
    
    init(session: Session, url: String, title: String) {
        self.session = session
        self.url = url
        self.domain = url.domain
        self.title = title.isEmpty ? title : title + " "
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text("\(Image(uiImage: icon.image == nil ? empty : blank)) \(title)\(Text(domain).foregroundColor(.secondary).font(.callout))")
                .font(.body.weight(.medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            
            if let image = icon.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .frame(width: size, height: size)
                    .allowsHitTesting(false)
            }
        }
        .frame(minHeight: 38)
        .onChange(of: url) { url in
            Task {
                await update(url: url)
            }
        }
        .task {
            await update(url: url)
        }
    }
    
    private func update(url: String) async {
        await icon.load(favicon: session.favicon, website: .init(string: url))
    }
}
