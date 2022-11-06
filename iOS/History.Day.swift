import Foundation
import Engine

extension History {
    struct Day {
        var items: [Engine.History]
        let date: Date
        
        init(item: Engine.History) {
            self.items = [item]
            self.date = .init(timestamp: item.date)
        }
    }
}
