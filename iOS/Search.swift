import SwiftUI

struct Search: UIViewRepresentable {
    let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func makeUIView(context: Context) -> Field {
        session.field
    }
    
    func updateUIView(_: Field, context: Context) {
        
    }
}
