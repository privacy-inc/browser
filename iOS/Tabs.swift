import SwiftUI

struct Tabs: View {
    @ObservedObject var session: Session
    @State private var alert = false
    @Environment(\.verticalSizeClass) var horizontal
    
    var body: some View {
        List(selection: $session.content) {
            if session.tabs.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: Category.tabs.image)
                        .font(.system(size: 60, weight: .medium))
                        .padding(.top, 60)
                    Text("No tabs open")
                }
                .foregroundStyle(.secondary)
                .frame(maxWidth: .greatestFiniteMagnitude)
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
            } else {
                ForEach(session.tabs) { tab in
                    Item(session: session, id: tab.id)
                        .swipeActions {
                            Button {
                                withAnimation {
                                    session.close(tab: tab.id)
                                }
                            } label: {
                                Label("Close", systemImage: "xmark.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                            }
                            .tint(.pink)
                        }
                }
                .onMove { index, destination in
                    session.tabs.move(fromOffsets: index, toOffset: destination)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Tabs")
        .onChange(of: session.content) { _ in
            if UIDevice.current.userInterfaceIdiom == .pad {
                switch UIApplication.shared.scene?.interfaceOrientation {
                case .landscapeLeft, .landscapeRight:
                    session.columns = .doubleColumn
                default:
                    session.columns = .detailOnly
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                EditButton()
                    .disabled(session.tabs.count < 2)

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
                        session.tabs.forEach {
                            $0.webview?.clean()
                        }
                        session.tabs = []
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
        }
    }
}
