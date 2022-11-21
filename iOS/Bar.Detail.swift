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
                    Web(session: session, webview: webview)
                        .toolbar {
                            ToolbarItemGroup(placement: .bottomBar) {
                                Button("Reload") {
                                    
                                }
                                
                                if UIDevice.current.userInterfaceIdiom == .pad {
                                    Button {
                                        reader = true
                                    } label: {
                                        Image(systemName: "textformat.size")
                                    }
                                    .popover(isPresented: $reader) {
                                        Reader(session: session)
                                    }
                                } else {
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
