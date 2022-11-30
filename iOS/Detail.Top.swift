import SwiftUI

extension Detail {
    struct Top: View {
        let session: Session
        let webview: Webview
        @State private var back = false
        @State private var forward = false
        @State private var detail = false
        
        
        @State private var domain = ""
        @State private var loading = true
        @State private var secure = true
        @State private var encryption = false
        @State private var progress = Double()
        
        var body: some View {
            if let url = webview.url {
                ShareLink(item: url) {
                    image(icon: "square.and.arrow.up")
                }
            }
            
            button(icon: "chevron.backward", disabled: !back) {
                UIApplication.shared.hide()
                webview.goBack()
            }
            .onReceive(webview.publisher(for: \.canGoBack)) {
                back = $0
            }
            
            button(icon: "chevron.forward", disabled: !forward) {
                UIApplication.shared.hide()
                webview.goForward()
            }
            .onReceive(webview.publisher(for: \.canGoForward)) {
                forward = $0
            }
            
            button(icon: "ellipsis") {
                UIApplication.shared.hide()
                detail = true
            }
            .sheet(isPresented: $detail) {
                More(session: session)
            }
        }
        
        private func button(icon: String, disabled: Bool = false, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                image(icon: icon, disabled: disabled)
            }
            .disabled(disabled)
        }
        
        private func image(icon: String, disabled: Bool = false) -> some View {
            Image(systemName: icon)
                .foregroundStyle(disabled ? .tertiary : .primary)
                .foregroundColor(.primary)
                .font(.system(size: 12, weight: .regular))
                .contentShape(Rectangle())
                .frame(width: 40, height: 34)
        }
    }
}
