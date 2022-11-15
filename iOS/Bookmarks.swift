import SwiftUI
import Engine

struct Bookmarks: View {
    @ObservedObject var session: Session
    @State private var items = [Bookmark]()
    
    var body: some View {
        List(selection: $session.content) {
            if items.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: Category.bookmarks.image)
                        .font(.system(size: 60, weight: .medium))
                        .padding(.top, 60)
                    Text("No bookmarks")
                }
                .foregroundStyle(.secondary)
                .frame(maxWidth: .greatestFiniteMagnitude)
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
            } else {
                ForEach(items, id: \.url) { item in
                    Button {
                        session.open(url: item.url)
                    } label: {
                        Website(session: session, url: item.url, title: item.title)
                    }
                    .swipeActions {
                        Button {
                            session.content = .bookmark(item)
                            
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                session.columns = .detailOnly
                            }
                        } label: {
                            Label("Edit", systemImage: "pencil.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                        }
                        .tint(.blue)
                        
                        Button {
                            Task {
                                await session.cloud.delete(bookmark: item.url)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                        }
                        .tint(.pink)
                    }
                }
                .onMove { index, destination in
                    Task {
                        await session.cloud.move(bookmark: index, destination: destination)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Bookmarks")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                EditButton()
                    .disabled(items.count < 2)
                
                Button {
                    session.content = .bookmark(nil)
                    
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        session.columns = .detailOnly
                    }
                } label: {
                    Image(systemName: "plus.square")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 20, weight: .regular))
                        .frame(width: 40, height: 36)
                        .contentShape(Rectangle())
                }
            }
        }
        .onReceive(session.cloud) {
            items = $0.bookmarks
        }
    }
}

private extension Date {
    var relative: String {
        if Calendar.current.isDate(self, inSameDayAs: .now) {
            return "Today"
        } else {
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
            
            if Calendar.current.isDate(self, inSameDayAs: yesterday) {
                return "Yesterday"
            } else {
                return formatted(.relative(presentation: .named, unitsStyle: .wide))
            }
        }
    }
}
