import SwiftUI

extension Detail {
    struct Tab: View {
        let session: Session
        let webview: Webview
        @State private var progress = Double()
        @State private var downloads = false
        
        var body: some View {
            
            Browser(webview: webview)
                .onReceive(webview.publisher(for: \.estimatedProgress)) {
                    progress = $0
                }
                .onReceive(webview.downloads) {
                    downloads = true
                }
                .sheet(isPresented: $downloads) {
                    NavigationStack {
                        Downloads(session: session)
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button {
                                        downloads = false
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 22, weight: .medium))
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(.secondary)
                                            .contentShape(Rectangle())
                                            .frame(width: 35, height: 40)
                                    }
                                }
                            }
                    }
                    .presentationDetents([.medium])
                }
                .safeAreaInset(edge: .top, spacing: 0) {
                    ZStack {
                        Rectangle()
                            .fill(Color.primary.opacity(0.05))
                        Progress(value: progress)
                            .stroke(Color.accentColor, style: .init(lineWidth: 2))
                    }
                    .frame(height: 2)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Top(session: session, webview: webview)
                    }
                }
        }
    }
}
