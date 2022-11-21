import SwiftUI

extension Bar {
    struct Detail: View {
        @ObservedObject var session: Session
        @State private var loading = false
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
                                if UIDevice.current.userInterfaceIdiom == .pad {
                                    readerButton
                                        .popover(isPresented: $reader) {
                                            Reader(session: session)
                                        }
                                } else {
                                    readerButton
                                        .sheet(isPresented: $reader, onDismiss: {
                                            dismiss()
                                        }) {
                                            Reader(session: session)
                                        }
                                }
                                
                                Button {
                                    
                                } label: {
                                    Label("Add to reading list", systemImage: "eyeglasses")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 15, weight: .bold))
                                        .contentShape(Rectangle())
                                        .frame(minWidth: 50, minHeight: 40)
                                }
                                
                                Button {
                                    
                                } label: {
                                    Label("Add to bookmarks", systemImage: "bookmark")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 15, weight: .bold))
                                        .contentShape(Rectangle())
                                        .frame(minWidth: 50, minHeight: 40)
                                }
                                
                                Button {
                                    if loading {
                                        webview.stopLoading()
                                    } else {
                                        webview.reload()
                                    }
                                    
                                    dismiss()
                                } label: {
                                    Label(loading ? "Store" : "Reload",
                                          systemImage: loading ? "xmark.square" : "arrow.clockwise.circle")
                                    .symbolRenderingMode(.hierarchical)
                                    .symbolVariant(.fill)
                                    .font(.system(size: 22, weight: .medium))
                                    .contentShape(Rectangle())
                                    .frame(minWidth: 50, minHeight: 40)
                                }
                                .onReceive(webview.publisher(for: \.isLoading)) {
                                    loading = $0
                                }
                            }
                        }
                }
            }
            .presentationDetents([.medium, .large])
        }
        
        private var readerButton: some View {
            Button {
                reader = true
            } label: {
                Label("Reader", systemImage: "textformat.size")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 17, weight: .bold))
                    .contentShape(Rectangle())
                    .frame(minWidth: 50, minHeight: 40)
            }
        }
    }
}
