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
                session.field.resignFirstResponder()
                session.typing = false
                
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
            .padding(.leading, 20)
           
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
                        .opacity(session.typing ? 0 : 1)
                }
                .frame(width: 100, height: 36)
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
            .padding(.trailing, 20)
        }
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
                .font(.system(size: 14, weight: .semibold))
                .contentShape(Rectangle())
                .frame(width: 40, height: 40)
        }
        .disabled(disabled)
    }
}
