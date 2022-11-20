import Foundation

extension UserDefaults {
    @objc dynamic var font: Int {
        object(forKey: "font") as? Int ?? 100
    }
}
