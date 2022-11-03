import Foundation

struct Tab: Identifiable, Hashable {
    let id = UUID()
    let webview: Webview
}
