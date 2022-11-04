import Foundation

struct Tab: Identifiable, Hashable {
    var webview: Webview?
    let id = UUID()
    
    init(webview: Webview? = nil) {
        self.webview = webview
    }
}
