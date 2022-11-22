import Foundation
import WebKit

struct Download: Identifiable {
    var fail: Fail?
    private(set) weak var webview: Webview?
    private(set) weak var item: WKDownload!
    let id: UUID
    
    init(webview: Webview, item: WKDownload) {
        id = .init()
        self.webview = webview
        self.item = item
    }
}
