import SwiftUI

struct Bar: View {
    let session: Session
    let tab: Tab
    @State private var url: URL?
    @State private var domain = ""
    @State private var secure = true
    @State private var loading = false
    @State private var encryption = false
    
    var body: some View {
        HStack {
            Button {
                if let url {
                    session.field.insertText(url.absoluteString)
                }
                session.field.becomeFirstResponder()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.tertiarySystemBackground))
                        .shadow(color: .init(white: 0, opacity: 0.1), radius: 7)
                    
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
                                .font(.body.weight(.regular))
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
                            url = $0
                            domain = url?.searchbar ?? ""
                        }
                        .onReceive(webview.publisher(for: \.hasOnlySecureContent)) {
                            secure = $0
                        }
                        .onReceive(webview.publisher(for: \.isLoading)) {
                            loading = $0
                        }
                    }
                }
                .frame(width: 300, height: 40)
                .contentShape(Rectangle())
            }
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .padding(.top, 12)
        .padding(.bottom, 10)
    }
    
    private func button(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundColor(.primary)
                .font(.system(size: 13, weight: .regular))
                .contentShape(Rectangle())
                .frame(width: 40, height: 40)
        }
    }
}
