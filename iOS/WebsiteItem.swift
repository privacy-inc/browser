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
    print("blanked")
    UIGraphicsBeginImageContext(.init(width: size, height: size))
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
} ()

struct WebsiteItem: View {
    let url: String
    let title: String
    @State private var image: UIImage?
    
    init(url: String, title: String) {
        self.url = url.domain
        self.title = title.isEmpty ? title : title + " "
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Text("\(Image(uiImage: image == nil ? empty : blank)) \(title)\(Text(url).foregroundColor(.secondary).font(.callout))")
                .font(.body.weight(.medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .frame(width: size, height: size)
                    .allowsHitTesting(false)
            }
        }
        .frame(minHeight: 38)
    }
}
