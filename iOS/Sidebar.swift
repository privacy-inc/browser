import SwiftUI

struct Sidebar: View {
    @ObservedObject var session: Session
    
    var body: some View {
        List(selection: $session.sidebar) {
            Section("Tabs") {
                Tabs(session: session)
            }
            .headerProminence(.increased)
            
            Section("Browser") {
                ForEach([Category.bookmarks,
                         .history,
                         .readingList,
                         .downloads], id: \.self) {
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
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack {
                Divider()
                
                Button {
                    session.newTab()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 30, weight: .regular))
                        .contentShape(Rectangle())
                        .frame(width: 50, height: 38)
                }
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .background(.ultraThinMaterial)
        }
    }
    
    private func link(for category: Category) -> some View {
        NavigationLink(value: category) {
            Label(category.title, systemImage: category.image)
        }
    }
}
