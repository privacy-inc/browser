import SwiftUI

struct Browser: UIViewRepresentable {
    private weak var webview: Webview!
    
    init(webview: Webview) {
        self.webview = webview
    }
    
    func makeUIView(context: Context) -> Webview {
        webview
    }
    
    func updateUIView(_: Webview, context: Context) {
        
    }
}
