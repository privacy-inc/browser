import SwiftUI

struct Sidebar: View {
    @ObservedObject var session: Session
    @State private var forget = false
    
    var body: some View {
        List(selection: $session.sidebar) {
            Tabs(session: session)
            
            Section("Browser") {
                ForEach([Category.bookmarks,
                         .history,
                         .readingList,
                         .downloads], id: \.self) {
                             link(for: $0)
                         }
            }
            .headerProminence(.increased)
            
            Section("App") {
                ForEach([Category.sponsor,
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
            VStack(spacing: 14) {
                Divider()
                
                ZStack {
                    HStack {
                        Button {
                            forget = true
                        } label: {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.pink)
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 18, weight: .medium))
                                .contentShape(Rectangle())
                                .frame(width: 50, height: 38)
                        }
                        .padding(.bottom, 8)
                        .padding(.leading)
                        
                        Spacer()
                    }
                    
                    Button {
                        session.newTab()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 32, weight: .regular))
                            .contentShape(Rectangle())
                            .frame(width: 50, height: 38)
                    }
                    .padding(.bottom, 8)
                }
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .background(Color(.systemBackground))
        }
    }
    
    private func link(for category: Category) -> some View {
        NavigationLink(value: category) {
            Label(category.title, systemImage: category.image)
        }
    }
}
