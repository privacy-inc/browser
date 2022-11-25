import SwiftUI

struct Downloads: View {
    @ObservedObject var session: Session
    @State private var alert = false
    
    var body: some View {
        List {
            if session.downloads.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: Category.downloads.image)
                        .font(.system(size: 60, weight: .medium))
                        .padding(.top, 60)
                    Text("No downloads")
                }
                .foregroundStyle(.secondary)
                .frame(maxWidth: .greatestFiniteMagnitude)
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
            } else {
                ForEach($session.downloads) { item in
                    Item(download: item)
                        .swipeActions {
                            Button {
                                session.downloads.first { $0.id == item.id }?.item.cancel()
                                withAnimation {
                                    _ = session.downloads.remove { $0.id == item.id }
                                }
                            } label: {
                                Label("Remove", systemImage: "xmark.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            .tint(.pink)
                        }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(Category.downloads.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    alert = true
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .foregroundStyle(session.downloads.isEmpty ? .tertiary : .secondary)
                        .foregroundColor(session.downloads.isEmpty ? .secondary : .pink)
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 24, weight: .regular))
                        .frame(width: 40, height: 36)
                        .contentShape(Rectangle())
                }
                .disabled(session.downloads.isEmpty)
                .confirmationDialog("Remove all", isPresented: $alert) {
                    Button("Remove", role: .destructive) {
                        session.downloads.forEach { $0.item.cancel() }
                        session.downloads = []
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
    }
}
