import SwiftUI

struct Bar: View {
    let session: Session
    let tab: Tab
    @State private var domain = ""
    @State private var secure = true
    @State private var loading = false
    @State private var encryption = false
    
    var body: some View {
        Button {
            session.field.becomeFirstResponder()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(.tertiarySystemBackground))
                    .shadow(color: .init(white: 0, opacity: 0.1), radius: 5)
                
                if let webview = tab.webview {
                    HStack(spacing: 0) {
                        button(icon: secure ? "lock.fill" : "exclamationmark.triangle.fill") {
                            UIApplication.shared.hide()
                            encryption = true
                        }
                        .popover(isPresented: $encryption) {
                            Encryption(domain: domain, secure: secure)
                        }

                        Text(domain)
                            .font(.callout.weight(.regular))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .allowsHitTesting(false)
                            .frame(maxWidth: .greatestFiniteMagnitude)

                        button(icon: loading ? "xmark" : "arrow.clockwise") {
                            UIApplication.shared.hide()
                            if loading {
                                webview.stopLoading()
                            } else {
                                webview.reload()
                            }
                        }
                    }
                    .onReceive(webview.publisher(for: \.url)) {
                        domain = $0?.searchbar ?? ""
                    }
                    .onReceive(webview.publisher(for: \.hasOnlySecureContent)) {
                        secure = $0
                    }
                    .onReceive(webview.publisher(for: \.isLoading)) {
                        loading = $0
                    }
                }
            }
            .frame(width: 300, height: 36)
            .contentShape(Rectangle())
        }
    }
    
    private func button(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundColor(.primary)
                .font(.system(size: 10, weight: .regular))
                .contentShape(Rectangle())
                .frame(width: 45, height: 36)
        }
    }
}
