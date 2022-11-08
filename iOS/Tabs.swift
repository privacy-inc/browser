import SwiftUI

struct Tabs: View {
    @ObservedObject var session: Session
    @State private var alert = false
    
    var body: some View {
        List(selection: $session.content) {
            ForEach(session.tabs) { tab in
                Item(session: session, id: tab.id)
                    .swipeActions {
                        Button {
                            withAnimation {
                                session.close(tab: tab.id)
                            }
                        } label: {
                            Label("Close", systemImage: "xmark.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                        }
                        .tint(.pink)
                    }
            }
            .onMove { index, destination in
                session.tabs.move(fromOffsets: index, toOffset: destination)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Tabs")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    session.newTab()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 32, weight: .regular))
                        .frame(width: 50, height: 40)
                        .contentShape(Rectangle())
                }
            }
            
            
            
            ToolbarItemGroup(placement: .primaryAction) {
                EditButton()
                
                Button {
                    alert = true
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .foregroundStyle(session.tabs.isEmpty ? .tertiary : .secondary)
                        .foregroundColor(session.tabs.isEmpty ? .secondary : .pink)
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 24, weight: .regular))
                        .frame(width: 40, height: 36)
                        .contentShape(Rectangle())
                }
                .disabled(session.tabs.isEmpty)
                .confirmationDialog("Close tabs", isPresented: $alert) {
                    Button("Close new tabs") {
                        session.tabs.removeAll {
                            $0.webview == nil
                        }
                    }
                    Button("Close all", role: .destructive) {
                        session.content = nil
                        session.tabs = []
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
    }
}
