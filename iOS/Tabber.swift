import SwiftUI

struct Tabber: View {
    @ObservedObject var session: Session
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            Button {
                session.newTab()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 28, weight: .medium))
                    .contentShape(Rectangle())
                    .frame(width: 50, height: 44)
            }
            .padding(.top, 12)
            .padding(.bottom, 4)
        }
        .background(Color(.systemBackground))
    }
}
