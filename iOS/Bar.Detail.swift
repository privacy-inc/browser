import SwiftUI

extension Bar {
    struct Detail: View {
        @ObservedObject var session: Session
        
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
                            
                            Menu {
                                HStack {
                                    Button("-") {
                                        
                                    }
                                    
                                    Text("8%")
                                    
                                    Button("+") {
                                        
                                    }
                                }
                            } label: {
                                Image(systemName: "textformat.size")
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
