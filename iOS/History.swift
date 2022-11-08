import SwiftUI

struct History: View {
    @ObservedObject var session: Session
    @State private var days = [Day]()
    @State private var alert = false
    
    var body: some View {
        List(days, id: \.date) { day in
            Section(day.date.relative) {
                ForEach(day.items, id: \.url) { item in
                    Button {
                        session.open(url: item.url)
                    } label: {
                        WebsiteItem(session: session, url: item.url, title: item.title)
                    }
                }
            }
            .headerProminence(.increased)
        }
        .listStyle(.plain)
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    alert = true
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .foregroundStyle(session.tabs.isEmpty ? .tertiary : .secondary)
                        .foregroundColor(session.tabs.isEmpty ? .secondary : .pink)
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 24, weight: .regular))
                        .frame(width: 40, height: 36)
                        .contentShape(Rectangle())
                }
                .disabled(session.tabs.isEmpty)
                .confirmationDialog("Clear history", isPresented: $alert) {
                    Button("Clear", role: .destructive) {
                        session.content = nil
                        session.tabs = []
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
        .onReceive(session.cloud) {
            days = $0
                .history
                .reduce(into: []) { result, item in
                    guard let last = result.last?.date else {
                        result.append(.init(item: item))
                        return
                    }
                    if Calendar.current.isDate(last, inSameDayAs: .init(timestamp: item.date)) {
                        var day = result.removeLast()
                        day.items.append(item)
                        result.append(day)
                    } else {
                        result.append(.init(item: item))
                    }
                }
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
