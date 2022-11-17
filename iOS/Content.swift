import Foundation
import Engine

enum Content: Hashable {
    case
    tab(UUID),
    error(String),
    bookmark(Bookmark?)
}
