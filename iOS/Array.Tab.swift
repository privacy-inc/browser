import Foundation

extension Array where Element == Tab {
    subscript(_ id: UUID) -> Tab? {
        first {
            $0.id == id
        }
    }
}
