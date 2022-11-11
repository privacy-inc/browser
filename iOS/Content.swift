import Foundation
import Engine

enum Content: Hashable {
    case
    tab(UUID),
    bookmark(Bookmark?)
}
