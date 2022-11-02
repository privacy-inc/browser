import SwiftUI

extension Sidebar {
    struct Item: View {
        let id: UUID
        
        var body: some View {
            NavigationLink(value: id) {
                Text("Hello world")
            }
        }
    }
}
