import SwiftUI

extension Detail {
    struct Progress: Shape {
        var value: Double

        func path(in rect: CGRect) -> Path {
            .init {
                $0.move(to: .init(x: 0, y: 1))
                $0.addLine(to: .init(x: value * rect.width, y: 1))
            }
        }

        var animatableData: Double {
            get {
                value
            }
            set {
                value = newValue
            }
        }
    }
}
