import SwiftUI

struct Tabs: View {
    @ObservedObject var session: Session
    @State private var alert = false
    
    var body: some View {
        Section(header: Text("Tabs"),
                footer: closing) {
            ForEach(session.tabs) { tab in
                Item(session: session, id: tab.id)
                    .equatable()
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
        }.headerProminence(.increased)
    }
    
    private var closing: some View {
        Button {
            alert = true
        } label: {
            Text("Close all")
                .font(.callout)
                .foregroundColor(session.tabs.isEmpty ? .secondary : .pink)
                .padding(.vertical, 7)
        }
        .disabled(session.tabs.isEmpty)
        .confirmationDialog("Close all tabs", isPresented: $alert) {
            Button("Close all tabs", role: .destructive) {
                session.sidebar = nil
                session.tabs.forEach {
                    $0.webview?.clean()
                }
                session.tabs = []
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}
