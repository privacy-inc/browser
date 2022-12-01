import SwiftUI

struct Sidebar: View {
    @ObservedObject var session: Session
    @State private var alert = false
    
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
            VStack(spacing: 14) {
                Divider()
                
                ZStack {
                    HStack {
                        Button {
                            alert = true
                        } label: {
                            Image(systemName: "trash.circle.fill")
                                .foregroundStyle(session.tabs.isEmpty ? .tertiary : .secondary)
                                .foregroundColor(session.tabs.isEmpty ? .secondary : .pink)
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 24, weight: .regular))
                                .contentShape(Rectangle())
                                .frame(width: 50, height: 38)
                        }
                        .padding(.bottom, 8)
                        .padding(.leading)
                        .disabled(session.tabs.isEmpty)
                        .confirmationDialog("Close tabs", isPresented: $alert) {
                            Button("Close new tabs") {
                                session.sidebar = nil
                                session.tabs.removeAll {
                                    $0.webview == nil
                                }
                            }
                            Button("Close all", role: .destructive) {
                                session.sidebar = nil
                                session.tabs.forEach {
                                    $0.webview?.clean()
                                }
                                session.tabs = []
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                        
                        Spacer()
                    }
                    
                    Button {
                        session.newTab()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 30, weight: .regular))
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
