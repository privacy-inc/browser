import SwiftUI

struct Bar: View {
    @ObservedObject var session: Session
    let tab: Tab
    @State private var back = false
    @State private var forward = false
    @State private var detail = false
    @State private var loading = false
    
    var body: some View {
        if let webview = tab.webview {
//            button(icon: loading ? "pause" : "arrow.clockwise") {
//                UIApplication.shared.hide()
//
//                if loading {
//                    webview.stopLoading()
//                } else {
//                    webview.reload()
//                }
//            }
//            .onReceive(webview.publisher(for: \.isLoading)) {
//                loading = $0
//            }
            
//            button(icon: "chevron.backward", disabled: !back) {
//                UIApplication.shared.hide()
//                webview.goBack()
//            }
//            .onReceive(webview.publisher(for: \.canGoBack)) {
//                back = $0
//            }
            
        }
        
        Button {
            session.field.becomeFirstResponder()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.secondary)
            }
            .frame(width: 300, height: 36)
        }
        
        if let webview = tab.webview {
//            button(icon: "chevron.forward", disabled: !forward) {
//                UIApplication.shared.hide()
//                webview.goForward()
//            }
//            .onReceive(webview.publisher(for: \.canGoForward)) {
//                forward = $0
//            }
//            
//            button(icon: "ellipsis") {
//                UIApplication.shared.hide()
//                detail = true
//            }
//            .sheet(isPresented: $detail) {
//                Detail(session: session)
//            }
        }
    }
    
    private func button(icon: String, disabled: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundStyle(disabled ? .tertiary : .primary)
                .foregroundColor(.primary)
                .font(.system(size: 19, weight: .regular))
                .contentShape(Rectangle())
                .frame(width: 40, height: 40)
        }
        .disabled(disabled)
    }
}
