import SwiftUI

struct Sidebar: View {
    @ObservedObject var session: Session
    
    var body: some View {
        List(selection: $session.sidebar) {
            section("Tabs") {
                ForEach(session.tabs) {
                    Item(session: session, id: $0.id)
                }
            }
            
            section("Bookmarks") {
                EmptyView()
            }
            
            section("History") {
                EmptyView()
            }
        }
        .listStyle(.sidebar)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Bar(session: session)
                Search(session: session)
            }
        }
    }
    
    private func section(_ title: LocalizedStringKey, items: () -> some View) -> some View {
        Section(title) {
            items()
        }
        .textCase(.none)
    }
}
