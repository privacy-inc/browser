import SwiftUI

struct Tabs: View {
    @ObservedObject var session: Session
    
    var body: some View {
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
    }
}
