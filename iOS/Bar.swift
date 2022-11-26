import SwiftUI

struct Bar: View {
    @ObservedObject var session: Session
    let tab: Tab
    @State private var back = false
    @State private var forward = false
    @State private var detail = false
    @State private var loading = false
    
    var body: some View {
        HStack(spacing: 0) {
            if let webview = tab.webview {
                button(icon: loading ? "pause" : "arrow.clockwise") {
                    UIApplication.shared.hide()
                    
                    if loading {
                        webview.stopLoading()
                    } else {
                        webview.reload()
                    }
                }
                .padding(.leading, 10)
                .onReceive(webview.publisher(for: \.isLoading)) {
                    loading = $0
                }
                
                button(icon: "chevron.backward", disabled: !back) {
                    UIApplication.shared.hide()
                    webview.goBack()
                }
                .onReceive(webview.publisher(for: \.canGoBack)) {
                    back = $0
                }
                
                Spacer()
            } else {
                Spacer()
                    .frame(width: 32)
            }
            
            Button {
                session.field.becomeFirstResponder()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.secondary)
                }
                .frame(height: 36)
            }
            
            if let webview = tab.webview {
                Spacer()
                
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
                .padding(.trailing, 10)
                .sheet(isPresented: $detail) {
                    Detail(session: session)
                }
            } else {
                Spacer()
                    .frame(width: 32)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 4)
    }
    
    private func button(icon: String, disabled: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundStyle(disabled ? .tertiary : .primary)
                .foregroundColor(.primary)
                .font(.system(size: 19, weight: .regular))
                .contentShape(Rectangle())
                .frame(width: 55, height: 40)
        }
        .disabled(disabled)
    }
}
