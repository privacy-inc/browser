import SwiftUI

extension Detail {
    struct Top: View {
        let session: Session
        let webview: Webview
        @State private var back = false
        @State private var forward = false
        @State private var detail = false
        @State private var keyboard = false
        @State private var progress = Double()
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        button(icon: "sidebar.left") {
                            UIApplication.shared.hide()
                            dismiss()
                        }
                    }
                    
                    Spacer()
                    
                    if keyboard {
                        Button {
                            UIApplication.shared.hide()
                        } label: {
                            Text("Cancel")
                                .font(.callout)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 5)
                                .contentShape(Rectangle())
                        }
                        
                    } else {
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
                        
                        if let url = webview.url {
                            ShareLink(item: url) {
                                image(icon: "square.and.arrow.up")
                            }
                        }
                        
                        button(icon: "ellipsis") {
                            UIApplication.shared.hide()
                            detail = true
                        }
                        .sheet(isPresented: $detail) {
                            More(session: session)
                        }
                    }
                }
                
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(Color.primary.opacity(0.05))
                    Progress(value: progress)
                        .stroke(Color.accentColor, style: .init(lineWidth: 2))
                        .frame(height: 2)
                }
                .frame(height: 3)
                .onReceive(webview.publisher(for: \.estimatedProgress)) {
                    progress = $0
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                keyboard = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboard = false
            }
            
            /*
             NotificationCenter
                       .default
                       .publisher(for: UIResponder.keyboardWillShowNotification)
                       .map { _ in true },
                     NotificationCenter
                       .default
                       .publisher(for: UIResponder.keyboardWillHideNotification)
                       .map { _ in false })
             */
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
                .font(.system(size: 14, weight: .regular))
                .contentShape(Rectangle())
                .frame(width: 60, height: 45)
        }
    }
}
