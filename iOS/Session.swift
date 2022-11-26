import SwiftUI
import Combine
import Archivable
import Engine

@MainActor final class Session: ObservableObject {
    @Published var sidebar: Category?
    @Published var path = [UUID]()
    @Published var tabs = [Tab()]
    @Published var downloads = [Download]()
    @Published var settings = Settings()
    var reviewed = false
    let field = Field()
    let cloud = Cloud<Archive>.new(identifier: "iCloud.privacy")
    let favicon = Favicon()
    let review = PassthroughSubject<Void, Never>()
    
    init() {
        path = [tabs.first!.id]
        sidebar = .tabs(tabs.first!.id)
        field.session = self
    }
    
    func newTab() {
        open(tab: .init())
        field.becomeFirstResponder()
    }
    
    func search(string: String) {
        guard
            let id = path.first,
            let url = settings.search(string)
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
        tabs.append(tab)
        path = [tab.id]
        sidebar = .tabs(tab.id)
    }
}
