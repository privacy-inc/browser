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
                        session.open(url: item.url)
                    } label: {
                        Website(session: session, url: item.url, title: item.title)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Reading list")
//        .toolbar {
//            ToolbarItem(placement: .primaryAction) {
//                Button {
//                    alert = true
//                } label: {
//                    Image(systemName: "trash.circle.fill")
//                        .foregroundStyle(session.tabs.isEmpty ? .tertiary : .secondary)
//                        .foregroundColor(session.tabs.isEmpty ? .secondary : .pink)
//                        .symbolRenderingMode(.hierarchical)
//                        .font(.system(size: 24, weight: .regular))
//                        .frame(width: 40, height: 36)
//                        .contentShape(Rectangle())
//                }
//                .disabled(session.tabs.isEmpty)
//            }
//        }
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
