import SwiftUI

struct Content: View {
    @ObservedObject var session: Session
    
    var body: some View {
        if let tab = session.sidebar {
            Browser(tab: tab)
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}
