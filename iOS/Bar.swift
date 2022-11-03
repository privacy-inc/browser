import SwiftUI

struct Bar: View {
    @ObservedObject var session: Session
    
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: "gear")
                .foregroundColor(.primary)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 50, height: 40)
                .contentShape(Rectangle())
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
        
        Button {
            
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.primary)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 50, height: 40)
                .contentShape(Rectangle())
        }
    }
}
