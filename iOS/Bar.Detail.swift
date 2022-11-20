import SwiftUI

extension Bar {
    struct Detail: View {
        @ObservedObject var session: Session
        @State private var reader = false
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationStack {
                if case let .tab(id) = session.content,
                   let webview = session[tab: id]?.webview,
                   webview.url != nil {
                    List {
                        Web(session: session, webview: webview)
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            Button("Reload") {
                                
                            }

                            Button {
                                reader = true
                            } label: {
                                Image(systemName: "textformat.size")
                            }
                            .sheet(isPresented: $reader, onDismiss: {
                                dismiss()
                            }) {
                                Reader(session: session)
                            }
                            
                            Button("Bookmark") {

                            }
                        }
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}
