import SwiftUI

struct Content: View {
    @ObservedObject var session: Session
    
    var body: some View {
        VStack {
            Browser()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
