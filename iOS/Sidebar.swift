import SwiftUI

struct Sidebar: View {
    @ObservedObject var session: Session
    
    var body: some View {
        List(selection: $session.sidebar) {
            Section("Browser") {
                ForEach([Category.tabs,
                         .bookmarks,
                         .history,
                         .readingList], id: \.self) {
                             link(for: $0)
                         }
            }
            .headerProminence(.increased)
            
            Section("Protection") {
                ForEach([Category.forget,
                         .report], id: \.self) {
                             link(for: $0)
                         }
            }
            .headerProminence(.increased)
            
            Section("App") {
                ForEach([Category.settings,
                         .sponsor,
                         .policy,
                         .about], id: \.self) {
                             link(for: $0)
                         }
            }
            .headerProminence(.increased)
        }
        .listStyle(.sidebar)
        .navigationTitle("Menu")
    }
    
    private func link(for category: Category) -> some View {
        NavigationLink(value: category) {
            Label(category.title, systemImage: category.image)
        }
    }
}
