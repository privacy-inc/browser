import Foundation

struct Tab: Identifiable, Hashable {
    let id = UUID()
    let webview: Webview?
    
    init(webview: Webview? = nil) {
        self.webview = webview
    }
}
