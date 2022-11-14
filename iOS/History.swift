import SwiftUI

struct History: View {
    @ObservedObject var session: Session
    @State private var days = [Day]()
    @State private var alert = false
    
    var body: some View {
        List {
            if days.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: Category.history.image)
                        .font(.system(size: 60, weight: .medium))
                        .padding(.top, 60)
                    Text("No record")
                }
                .foregroundStyle(.secondary)
                .frame(maxWidth: .greatestFiniteMagnitude)
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
            } else {
                ForEach(days, id: \.date) { day in
                    Section(day.date.relative) {
                        ForEach(day.items, id: \.url) { item in
                            Button {
                                session.open(url: item.url)
                            } label: {
                                Website(session: session, url: item.url, title: item.title)
                            }
                        }
                    }
                    .headerProminence(.increased)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    alert = true
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .foregroundStyle(days.isEmpty ? .tertiary : .secondary)
                        .foregroundColor(days.isEmpty ? .secondary : .pink)
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 24, weight: .regular))
                        .frame(width: 40, height: 36)
                        .contentShape(Rectangle())
                }
                .disabled(days.isEmpty)
                .confirmationDialog("Clear history", isPresented: $alert) {
                    Button("Clear", role: .destructive) {
                        Task {
                            await session.cloud.clearHistory()
                        }
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
