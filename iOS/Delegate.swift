import StoreKit

final class Delegate: NSObject, UIApplicationDelegate/*, SKPaymentTransactionObserver, Sendable*/ {
//    weak var session: Session?
//
//    func application(_ application: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        SKPaymentQueue.default().add(self)
//        application.registerForRemoteNotifications()
//        return true
//    }
//
//    func application(_: UIApplication, didReceiveRemoteNotification: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
//        await session?.cloud.backgroundFetch == true ? .newData : .noData
//    }
//
//    nonisolated func paymentQueue(_: SKPaymentQueue, shouldAddStorePayment: SKPayment, for product: SKProduct) -> Bool {
//        Task
//            .detached { [weak self] in
//                await self?.session?.store.purchase(legacy: product)
//            }
//        return false
//    }
//
//    nonisolated func paymentQueue(_: SKPaymentQueue, updatedTransactions: [SKPaymentTransaction]) {
//
//    }
    
}
