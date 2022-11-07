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
    
    init() {
        let tab = Tab()
        tabs = [tab]
//        content = tab.id
        field.session = self
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
        
        tabs[index].webview?.load(.init(url: url))
    }
    
    subscript(tab id: UUID) -> Webview? {
        tabs
            .first {
                $0.id == id
            }?
            .webview
    }
}
