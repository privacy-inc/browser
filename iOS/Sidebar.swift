import SwiftUI

struct Sidebar: View {
    @ObservedObject var session: Session
    
    var body: some View {
        List(selection: $session.sidebar) {
            Section("Tabs") {
                ForEach(0 ..< 5) {
                    Item(tab: .init(index: $0))
                }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .headerProminence(.increased)
            
            Section("Bookmarks") {
                ForEach(0 ..< 5) {
                    Item(tab: .init(index: $0))
                }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .headerProminence(.increased)
            
            Section("History") {
                ForEach(0 ..< 5) {
                    Item(tab: .init(index: $0))
                }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .headerProminence(.increased)
        }
        .listStyle(.sidebar)
        .background(Color.init(white: 0.975, opacity: 1))
        .scrollContentBackground(.hidden)
        .toolbar(.hidden, for: .navigationBar)
    }
}
