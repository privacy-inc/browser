import SwiftUI

struct Bar: View {
    let session: Session
    let tab: Tab
    
    @State private var loading = false
    
    var body: some View {
        if let webview = tab.webview {
            
            
        }
        
        Button {
            session.field.becomeFirstResponder()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(.tertiarySystemBackground))
                    .shadow(color: .init(white: 0, opacity: 0.1), radius: 5)
            }
            .frame(width: 300, height: 36)
            .contentShape(Rectangle())
        }
        
        if let webview = tab.webview {
            
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
