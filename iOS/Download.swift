import Foundation
import WebKit

struct Download: Identifiable {
    var data: Data?
    private(set) weak var download: WKDownload!
    let id = UUID()
}
