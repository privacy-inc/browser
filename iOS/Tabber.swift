import SwiftUI

struct Tabber: View {
    @ObservedObject var session: Session
    
    var body: some View {
        ZStack {
            Button {
                session.newTab()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 32, weight: .regular))
                    .frame(width: 50, height: 40)
                    .contentShape(Rectangle())
            }
        }
    }
}
