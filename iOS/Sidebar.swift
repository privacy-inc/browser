import SwiftUI

struct Sidebar: View {
    @ObservedObject var session: Session
    
    var body: some View {
        List(selection: $session.sidebar) {
            section("Tabs") {
                ForEach(session.tabs) {
                    Item(id: $0.id)
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
        .background(Color.init(white: 0.975, opacity: 1))
        .scrollContentBackground(.hidden)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private func section(_ title: LocalizedStringKey, items: () -> some View) -> some View {
        Section(title) {
            items()
        }
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowBackground(Color.clear)
        .headerProminence(.increased)
    }
}
