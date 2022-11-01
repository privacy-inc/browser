import SwiftUI

final class Session: ObservableObject {
    @Published var sidebar: Tab?
    var columns = NavigationSplitViewVisibility.automatic
}
