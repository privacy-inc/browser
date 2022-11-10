import SwiftUI

struct Detail: View {
    let id: UUID
    @ObservedObject var session: Session
    @State private var colour = Color(.systemBackground)
    @State private var progress = AnimatablePair(Double(), Double())
    
    var body: some View {
        ZStack {
            if let webview = session[tab: id] {
                Color.white
                VStack(spacing: 0) {
                    ZStack {
                        Rectangle()
                            .fill(Color(.secondarySystemBackground))
                            .frame(height: 3)
                        Progress(progress: progress)
                            .stroke(Color.accentColor, style: .init(lineWidth: 4, lineCap: .round))
                    }
                    .frame(height: 3)
                    Browser(webview: webview)
                        .onReceive(webview.publisher(for: \.estimatedProgress)) { value in
                            guard value != 1 || progress.second != 0 else { return }
                            
                            progress.first = 0
                            withAnimation(.easeInOut(duration: 0.5)) {
                                progress.second = value
                            }
                            
                            if value == 1 {
                                DispatchQueue
                                    .main
                                    .asyncAfter(deadline: .now() + 0.7) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            progress = .init(1, 1)
                                        }
                                    }
                            }
                        }
                        .onReceive(webview.publisher(for: \.underPageBackgroundColor)) {
                            guard let theme = $0 else {
                                colour = .init(.systemBackground)
                                return
                            }
                            colour = .init(theme)
                        }
                    Divider()
                }
            } else {
                Button {
                    session.field.becomeFirstResponder()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .foregroundColor(.secondary)
                        .contentShape(Rectangle())
                        .frame(width: 120, height: 120)
                }
                .ignoresSafeArea(.keyboard)
                .task {
                    guard session.tabs.count > 1 else { return }
                    session.field.becomeFirstResponder()
                }
            }
            Search(session: session)
                .frame(height: 0)
        }
        .id(id)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Bar(session: session)
            }
        }
    }
}
