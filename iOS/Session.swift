import SwiftUI
import Combine
import Archivable
import Engine

@MainActor final class Session: ObservableObject {
    @Published var sidebar: Category?
    @Published var tabs = [Tab()]
    @Published var downloads = [Download]()
    var reviewed = false
    let field = Field()
    let cloud = Cloud<Archive>.new(identifier: "iCloud.privacy")
    let favicon = Favicon()
    let review = PassthroughSubject<Void, Never>()
    
    init() {
        sidebar = .tab(tabs.first!.id)
        field.session = self
    }
    
    func newTab() {
        open(tab: .init())
        field.becomeFirstResponder()
    }
    
    func search(string: String) {
        guard
            case let .tab(id) = sidebar,
            let url = URL(search: string)
        else { return }
        
        if tabs[id]?.webview == nil {
            tabs[id]?.webview = .init(session: self)
        }
        
        tabs[id]?.webview?.load(.init(url: url))
    }
    
    func open(url: String) {
        open(url: .init(string: url)!)
    }
    
    func open(url: URL) {
        var tab = Tab()
        tab.webview = .init(session: self)
        tab.webview!.load(.init(url: url))
        open(tab: tab)
    }
    
    func close(tab id: UUID) {
        tabs[id]?.webview?.clean()
        tabs
            .remove {
                $0.id == id
            }
    }
    
    private func open(tab: Tab) {
        tabs.insert(tab, at: 0)
        sidebar = .tab(tab.id)
    }
}
