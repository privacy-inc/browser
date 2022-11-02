import Foundation

@MainActor struct Tab: Identifiable, Hashable {
    let id = UUID()
    let webview: Webview
}
