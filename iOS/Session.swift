import SwiftUI
import Archivable
import Engine

@MainActor final class Session: ObservableObject {
    @Published var sidebar: Category? = .history
    @Published var content: AnyHashable?
    @Published var tabs: [Tab]
    @Published var typing = false
    @Published var settings = Settings()
    @Published var columns = NavigationSplitViewVisibility.doubleColumn
    let field = Field()
    let cloud = Cloud<Archive>.new(identifier: "iCloud.privacy")
//    let favicon = Favicon()
    
    init() {
        let tab = Tab()
        tabs = [tab]
//        content = tab.id
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
        content = tab.id
        field.becomeFirstResponder()
    }
    
    func search(string: String) {
        guard
            let id = content as? UUID,
            let index = tabs.firstIndex(where: { $0.id == id }),
            let url = settings.search(string)
        else { return }
        
        if tabs[index].webview == nil {
            tabs[index].webview = .init(cloud: cloud)
        }
        
        tabs[index].webview!.load(.init(url: url))
    }
    
    func open(url: String) {
        sidebar = .tabs
        
        var tab = Tab()
        tab.webview = .init(cloud: cloud)
        tab.webview!.load(.init(url: .init(string: url)!))
        tabs.append(tab)
        content = tab.id
    }
}
