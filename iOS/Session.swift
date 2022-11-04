import SwiftUI
import Engine

@MainActor final class Session: ObservableObject {
    @Published var sidebar: Category? = .tabs
    @Published var content: AnyHashable?
    @Published var tabs: [Tab]
    @Published var typing = false
    @Published var settings = Settings()
    @Published var columns = NavigationSplitViewVisibility.doubleColumn
    let field = Field()
    
    init() {
        let tab = Tab()
        tabs = [tab]
        content = tab.id
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
