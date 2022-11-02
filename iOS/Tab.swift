import Foundation

@MainActor struct Tab: Hashable {
    let index: Int
    let webview = Webview()
}
