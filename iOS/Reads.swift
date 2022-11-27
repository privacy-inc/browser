import SwiftUI
import Engine

struct Reads: View {
    @ObservedObject var session: Session
    @State private var items = [Read]()
    
    var body: some View {
        List {
            if items.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: Category.readingList.image)
                        .font(.system(size: 60, weight: .medium))
                        .padding(.top, 60)
                    Text("Nothing to read")
                }
                .foregroundStyle(.secondary)
                .frame(maxWidth: .greatestFiniteMagnitude)
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
            } else {
                ForEach(items, id: \.url) { item in
                    Button {
                        Task {
                            await session.cloud.update(read: item.url)
                        }
                        
                        session.open(url: item.url)
                    } label: {
                        Website(session: session, url: item.url, title: item.title, badge: !item.read)
                    }
                    .swipeActions {
                        Button {
                            Task {
                                await session.cloud.delete(read: item.url)
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
                        await session.cloud.move(read: index, destination: destination)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(Category.readingList.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                EditButton()
                    .disabled(items.count < 2)
            }
        }
        .onReceive(session.cloud) {
            items = $0.reads
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
