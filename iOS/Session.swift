import SwiftUI
import Combine
import Archivable
import Engine

@MainActor final class Session: ObservableObject {
    @Published var sidebar: Category? = .history
    @Published var content: Content?
    @Published var tabs: [Tab]
    @Published var downloads = [Download]()
    @Published var settings = Settings()
    @Published var columns = NavigationSplitViewVisibility.doubleColumn
    var reviewed = false
    let field = Field()
    let cloud = Cloud<Archive>.new(identifier: "iCloud.privacy")
    let favicon = Favicon()
    let review = PassthroughSubject<Void, Never>()
    
    var current: Int? {
        guard case let .tab(id) = content else { return nil }
        return tabs.firstIndex { $0.id == id }
    }
    
    init() {
        let tab = Tab()
        tabs = [tab]
//        content = .tab(tab.id)
        field.session = self
    }
    
    func newTab() {
        UINavigationBar.setAnimationsEnabled(false)
        let tab = Tab()
        tabs.append(tab)
        content = .tab(tab.id)
        sidebar = .tabs
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            columns = .detailOnly
        }
        
        field.becomeFirstResponder()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UINavigationBar.setAnimationsEnabled(true)
        }
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
        tabs[id]?.webview?.clean()
        tabs
            .remove {
                $0.id == id
            }
    }
}
