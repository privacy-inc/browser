import SwiftUI

extension Sidebar {
    struct Item: View {
        let tab: Tab
        
        var body: some View {
            NavigationLink(value: tab) {
                Text("Hello world")
            }
        }
    }
}
