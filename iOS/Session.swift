import SwiftUI

final class Session: ObservableObject {
    @Published var sidebar: Int?
    
    var colums = NavigationSplitViewVisibility.automatic
    
}
