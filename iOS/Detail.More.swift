import SwiftUI
import Engine

extension Detail {
    struct More: View {
        @ObservedObject var session: Session
        @State private var reader = false
        @State private var isBookmark = false
        @State private var isReadingList = false
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationStack {
                if case let .tab(id) = session.sidebar,
                   let webview = session.tabs[id]?.webview,
                   let url = webview.url {
                    
                    Web(session: session, webview: webview)
                        .toolbar {
                            ToolbarItemGroup(placement: .bottomBar) {
                                Button {
                                    guard !isReadingList else { return }
                                    isReadingList = true
                                    Task {
                                        await session.cloud.add(read: .init(url: url.absoluteString,
                                                                            title: webview.title ?? ""))
                                    }
                                } label: {
                                    Label("Add to reading list",
                                          systemImage: isReadingList ? "checkmark.circle.fill" : "eyeglasses")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 15, weight: .bold))
                                        .contentShape(Rectangle())
                                        .frame(minWidth: 50, minHeight: 40)
                                }
                                .disabled(isReadingList)
                                
                                Spacer()
                                
                                Button {
                                    Task {
                                        if isBookmark {
                                            await session.cloud.delete(bookmark: url.absoluteString)
                                        } else {
                                            guard
                                                let bookmark = Bookmark(url: url.absoluteString,
                                                                        title: webview.title ?? "")
                                            else { return }
                                            await session.cloud.add(bookmark: bookmark)
                                        }
                                    }
                                } label: {
                                    Label(isBookmark ? "Remove from bookmarks" : "Add to bookmarks",
                                          systemImage: isBookmark ? "bookmark.fill" : "bookmark")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 13, weight: .bold))
                                        .contentShape(Rectangle())
                                        .frame(minWidth: 50, minHeight: 40)
                                }
                                .onReceive(session.cloud) {
                                    isBookmark = $0.bookmarks.contains { $0.url == url.absoluteString }
                                }
                                
                                Spacer()
                                
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
                                
                                Spacer()
                                
                                Button {
                                    webview.findInteraction?.presentFindNavigator(showingReplace: false)
                                } label: {
                                    Label("Find on page", systemImage: "magnifyingglass")
                                        .symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 15, weight: .bold))
                                        .contentShape(Rectangle())
                                        .frame(minWidth: 50, minHeight: 40)
                                }
                            }
                        }
                }
            }
            .presentationDetents([.medium])
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
