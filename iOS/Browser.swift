import SwiftUI

struct Browser: UIViewRepresentable {
    private let tab: Tab
    
    init(tab: Tab) {
        self.tab = tab
    }
    
    func makeUIView(context: Context) -> Webview {
        tab.webview
    }
    
    func updateUIView(_: Webview, context: Context) {
        
    }
}
