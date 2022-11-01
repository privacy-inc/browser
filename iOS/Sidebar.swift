import SwiftUI

struct Sidebar: View {
    @ObservedObject var session: Session
    
    var body: some View {
        List(0 ..< 30, selection: $session.sidebar) { index in
            NavigationLink(value: index) {
                Text(index.formatted())
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
