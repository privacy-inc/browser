import SwiftUI

struct Bar: View {
    @ObservedObject var session: Session
    @State private var back = false
    @State private var forward = false
    @State private var progress = AnimatablePair(Double(), Double())
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(spacing: 0) {
            button(icon: "sidebar.leading") {
                UIApplication.shared.hide()
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    switch session.columns {
                    case .all, .doubleColumn:
                        session.columns = .detailOnly
                    default:
                        session.columns = .doubleColumn
                    }
                } else {
                    dismiss()
                }
            }
            .padding(.leading, 10)
           
            if let webview {
                button(icon: "chevron.backward", disabled: !back) {
                    webview.goBack()
                }
                .onReceive(webview.publisher(for: \.canGoBack)) {
                    back = $0
                }
            }
            
            Spacer()
            
            Button {
                session.field.becomeFirstResponder()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.secondary)
                }
                .frame(height: 36)
                .frame(maxWidth: 160)
            }
            
            Spacer()
            
            if let webview {
                button(icon: "chevron.forward", disabled: !forward) {
                    webview.goForward()
                }
                .onReceive(webview.publisher(for: \.canGoForward)) {
                    forward = $0
                }
            }
            
            button(icon: "ellipsis") {
                
            }
            .padding(.trailing, 10)
        }
        .padding(.top, 12)
        .padding(.bottom, 4)
    }
    
    private var webview: Webview? {
        guard case let .tab(id) = session.content else { return nil }
        return session[tab: id]
    }
    
    private func button(icon: String, disabled: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundStyle(disabled ? .tertiary : .primary)
                .foregroundColor(.primary)
                .font(.system(size: 21, weight: .medium))
                .contentShape(Rectangle())
                .frame(width: 55, height: 40)
        }
        .disabled(disabled)
    }
}
