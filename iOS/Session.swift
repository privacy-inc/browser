import SwiftUI
import Engine

@MainActor final class Session: ObservableObject {
    @Published var sidebar: Category?
    @Published var tabs = [Tab]()
    @Published var typing = false
    @Published var settings = Settings()
    var columns = NavigationSplitViewVisibility.all
    let field = Field()
    
    init() {
        field.session = self
    }
    
    func search(string: String) {
        guard let url = settings.search(string) else { return }
        let tab = Tab(webview: .init(url: url))
        tabs.append(tab)
//        sidebar = tab.id
    }
    
    subscript(tab id: UUID) -> Webview? {
        tabs
            .first {
                $0.id == id
            }?
            .webview
    }
}
