import SwiftUI

final class Session: ObservableObject {
    @Published var sidebar: Tab?
    @Published var tabs = [Tab]()
    var columns = NavigationSplitViewVisibility.automatic
}
