import SwiftUI

struct Bar: View {
    @ObservedObject var session: Session
    
    var body: some View {
        button(icon: "sidebar.leading") {
            if UIDevice.current.userInterfaceIdiom == .pad {
                session.columns = session.columns == .all || session.columns == .doubleColumn
                ? .detailOnly
                : .doubleColumn
            } else {
                session.content = nil
            }
        }
        
        Spacer()
        
        Button {
            session.field.becomeFirstResponder()
        } label: {
            Search(session: session)
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.secondary)
                .frame(width: 120, height: 36)
                .opacity(session.typing ? 0 : 1)
        }
        
        Spacer()
        
        button(icon: "ellipsis") {
            
        }
    }
    
    private func button(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundColor(.primary)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 50, height: 40)
                .contentShape(Rectangle())
        }
    }
}
