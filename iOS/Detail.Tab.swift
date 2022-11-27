import SwiftUI

extension Detail {
    struct Tab: View {
        let session: Session
        let webview: Webview
        @State private var downloads = false
        
        var body: some View {
            Browser(webview: webview)
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
                .toolbar {
                    ToolbarItemGroup(placement: .principal) {
                        Top(webview: webview)
                    }
                }
            Divider()
        }
    }
}
