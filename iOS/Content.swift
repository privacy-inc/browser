import SwiftUI

struct Content: View {
    @ObservedObject var session: Session
    
    var body: some View {
        VStack {
            Text(session.sidebar?.index.formatted() ?? "")
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
