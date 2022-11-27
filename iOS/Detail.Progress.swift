//import SwiftUI
//
//extension Detail {
//    struct Progress: Shape {
//        var progress: Double
//
//        func path(in rect: CGRect) -> Path {
//            .init {
//                $0.move(to: .init(x: progress.first * rect.width / 2, y: 0))
//                $0.addLine(to: .init(x: progress.second * rect.width, y: 1))
//            }
//        }
//
//        var animatableData: Double {
//            get {
//                progress
//            }
//            set {
//                progress = newValue
//            }
//        }
//    }
//}
