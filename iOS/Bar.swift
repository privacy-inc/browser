import SwiftUI

struct Bar: View {
    @ObservedObject var session: Session
    @State private var back = false
    @State private var forward = false
    @State private var detail = false
    @State private var progress = AnimatablePair(Double(), Double())
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(spacing: 0) {
            button(icon: "sidebar.leading") {
                UIApplication.shared.hide()
                dismiss()
            }
            .padding(.leading, 10)
           
            if let id = session.path.first,
               let tab = session.tabs[id]! {
                
                if tab.error == nil {
                    if let webview = tab.webview {
                        button(icon: "chevron.backward", disabled: !back) {
                            webview.goBack()
                        }
                        .onReceive(webview.publisher(for: \.canGoBack)) {
                            back = $0
                        }
                        
                        Spacer()
                    } else {
                        Spacer()
                            .frame(width: 10)
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
                            webview.goForward()
                        }
                        .onReceive(webview.publisher(for: \.canGoForward)) {
                            forward = $0
                        }
                        
                        button(icon: "ellipsis") {
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
                } else {
                    Spacer()
                }
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
                .font(.system(size: 21, weight: .regular))
                .contentShape(Rectangle())
                .frame(width: 55, height: 40)
        }
        .disabled(disabled)
    }
}
