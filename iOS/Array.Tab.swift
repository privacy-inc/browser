import Foundation

extension Array where Element == Tab {
    subscript(_ id: UUID) -> Tab? {
        get {
            first {
                $0.id == id
            }
        }
        set {
            guard
                let index = firstIndex(where: { $0.id == id }),
                let tab = newValue
            else { return }
            self[index] = tab
        }
    }
}
