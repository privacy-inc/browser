import SwiftUI
import StoreKit

@main
struct App: SwiftUI.App {
    @StateObject private var session = Session()
    @Environment(\.requestReview) private var review
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            Navigation(session: session)
                .onReceive(session.review) {
                    guard !session.reviewed else { return }
                    review()
                    session.reviewed = true
                }
        }
    }
}
//
//extension UINavigationController {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        hidesBarsOnSwipe = true
//        hidesBarsWhenKeyboardAppears = true
//        // other customizations
//        //    navigationBar.tintColor = .white
//    }
//}
