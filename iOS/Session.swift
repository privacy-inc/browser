import SwiftUI

@MainActor final class Session: ObservableObject {
    @Published var sidebar: Tab?
    @Published var tabs = [Tab]()
    @Published var typing = false
    var columns = NavigationSplitViewVisibility.automatic
    let field = Field()
    
    init() {
        field.session = self
    }
}
