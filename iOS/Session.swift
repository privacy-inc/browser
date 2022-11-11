import SwiftUI
import Archivable
import Engine

@MainActor final class Session: ObservableObject {
    @Published var sidebar: Category? = .bookmarks
    @Published var content: Content?
    @Published var tabs: [Tab]
    @Published var typing = false
    @Published var settings = Settings()
    @Published var columns = NavigationSplitViewVisibility.doubleColumn
    let field = Field()
    let cloud = Cloud<Archive>.new(identifier: "iCloud.privacy")
    let favicon = Favicon()
    
    init() {
        let tab = Tab()
        tabs = [tab]
//        content = .tab(tab.id)
        field.session = self
    }
    
    subscript(tab id: UUID) -> Webview? {
        tabs
            .first {
                $0.id == id
            }?
            .webview
    }
    
    func newTab() {
        let tab = Tab()
        tabs.append(tab)
        sidebar = .tabs
        content = .tab(tab.id)
        columns = .detailOnly
        field.becomeFirstResponder()
    }
    
    func search(string: String) {
        guard
            case let .tab(id) = content,
            let index = tabs.firstIndex(where: { $0.id == id }),
            let url = settings.search(string)
        else { return }
        
        if tabs[index].webview == nil {
            tabs[index].webview = .init(cloud: cloud, favicon: favicon)
        }
        
        tabs[index].webview!.load(.init(url: url))
    }
    
    func open(url: String) {
        sidebar = .tabs
        
        var tab = Tab()
        tab.webview = .init(cloud: cloud, favicon: favicon)
        tab.webview!.load(.init(url: .init(string: url)!))
        tabs.append(tab)
        content = .tab(tab.id)
    }
    
    func close(tab id: UUID) {
        tabs
            .remove {
                $0.id == id
            }
    }
}
