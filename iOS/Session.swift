import SwiftUI
import Archivable
import Engine

@MainActor final class Session: ObservableObject {
    @Published var sidebar: Category? = .tabs
    @Published var content: Content?
    @Published var tabs: [Tab]
    @Published var typing = false
    @Published var settings = Settings()
    @Published var columns = NavigationSplitViewVisibility.doubleColumn
    let field = Field()
    let cloud = Cloud<Archive>.new(identifier: "iCloud.privacy")
    let favicon = Favicon()
    
    var current: Int? {
        guard case let .tab(id) = content else { return nil }
        return tabs.firstIndex { $0.id == id }
    }
    
    init() {
        let tab = Tab()
        tabs = [tab]
        content = .tab(tab.id)
        field.session = self
    }
    
    subscript(tab id: UUID) -> Tab? {
        tabs
            .first {
                $0.id == id
            }
    }
    
    func newTab() {
        let tab = Tab()
        tabs.append(tab)
        content = .tab(tab.id)
        sidebar = .tabs
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            columns = .detailOnly
        }
        
        field.becomeFirstResponder()
    }
    
    func search(string: String) {
        guard
            let index = current,
            let url = settings.search(string)
        else { return }
        
        if tabs[index].webview == nil {
            tabs[index].webview = .init(session: self)
        }
        
        tabs[index].webview!.load(.init(url: url))
    }
    
    func open(url: String) {
        open(url: .init(string: url)!)
    }
    
    func open(url: URL) {
        var tab = Tab()
        tab.webview = .init(session: self)
        tab.webview!.load(.init(url: url))
        tabs.append(tab)
        content = .tab(tab.id)
        sidebar = .tabs
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            columns = .detailOnly
        }
    }
    
    func close(tab id: UUID) {
        self[tab: id]?.webview?.clean()
        tabs
            .remove {
                $0.id == id
            }
    }
}
