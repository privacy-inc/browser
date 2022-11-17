import Foundation

struct Tab: Identifiable, Hashable {
    var webview: Webview?
    var error: Weberror?
    let id = UUID()
    
    init(webview: Webview? = nil) {
        self.webview = webview
    }
}
