import SwiftUI

struct Bar: View {
    @ObservedObject var session: Session
    @State private var back = false
    @State private var forward = false
    @State private var progress = AnimatablePair(Double(), Double())
    
    var body: some View {
        HStack(spacing: 0) {
            button(icon: "sidebar.leading") {
                session.field.resignFirstResponder()
                session.typing = false
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    session.columns = session.columns == .all || session.columns == .doubleColumn
                    ? .detailOnly
                    : .doubleColumn
                } else {
                    session.content = nil
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
                        .frame(width: 120, height: 36)
                        .opacity(session.typing ? 0 : 1)
                }
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
        guard let id = session.content as? UUID else { return nil }
        return session[tab: id]
    }
    
    private func button(icon: String, disabled: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundStyle(disabled ? .tertiary : .primary)
                .foregroundColor(.primary)
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 40, height: 40)
                .contentShape(Rectangle())
        }
        .disabled(disabled)
    }
}
