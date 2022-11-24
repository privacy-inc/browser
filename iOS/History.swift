import SwiftUI
import Engine

struct History: View {
    @ObservedObject var session: Session
    @State private var history = [Engine.History]()
    @State private var days = [Day]()
    @State private var alert = false
    @State private var search = ""
    
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
                            .swipeActions {
                                Button {
                                    Task {
                                        await session.cloud.delete(history: item.url)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash.circle.fill")
                                        .symbolRenderingMode(.hierarchical)
                                }
                                .tint(.pink)
                            }
                        }
                    }
                    .headerProminence(.increased)
                }
            }
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
        .searchable(text: $search)
        .navigationTitle(Category.history.title)
        .navigationBarTitleDisplayMode(.large)
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
        .onChange(of: search) {
            update(search: $0)
        }
        .onReceive(session.cloud) {
            history = $0.history
            update(search: search)
        }
    }
    
    private func update(search: String) {
        days = history
            .filter {
                let filter = search.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard !filter.isEmpty else { return true }
                
                return $0.url.localizedCaseInsensitiveContains(search)
                    || $0.title.localizedCaseInsensitiveContains(search)
            }
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
