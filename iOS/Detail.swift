import SwiftUI

struct Detail: View {
    @ObservedObject var session: Session
    
    var body: some View {
        VStack {
            Text(session.sidebar?.index.formatted() ?? "")
        }
    }
}
