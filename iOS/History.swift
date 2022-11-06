import SwiftUI

struct History: View {
    @ObservedObject var session: Session
    @State private var days = [Day]()
    @State private var alert = false
    
    var body: some View {
        List(days, id: \.date) { day in
            Section(day.date.formatted(.dateTime.year(.defaultDigits).month(.defaultDigits).day(.defaultDigits).weekday(.abbreviated))) {
                ForEach(day.items, id: \.url) {
                    Item(url: $0.url, title: $0.title)
                }
            }
        }
        .listStyle(.insetGrouped)
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
                .confirmationDialog("Close tabs", isPresented: $alert) {
                    Button("Close new tabs") {
                        session.tabs.removeAll {
                            $0.webview == nil
                        }
                    }
                    Button("Close all", role: .destructive) {
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
