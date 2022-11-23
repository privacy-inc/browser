import Foundation
@preconcurrency import WebKit

struct Download: Identifiable, Sendable {
    var fail: Fail?
    var item: WKDownload
    let id: UUID
    let webview: Webview
    
    init(webview: Webview, item: WKDownload) {
        id = .init()
        self.webview = webview
        self.item = item
    }
}
