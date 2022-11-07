import Foundation
import Combine

#if os(macOS) || os(iOS)

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

extension Favicon {
    final actor Actor {
        private var received = Set<String>()
        private var publishers = [String : CurrentValueSubject<Output?, Never>]()
        
        func publisher(for website: URL, with path: URL) -> CurrentValueSubject<Output?, Never>? {
            guard let icon = website.icon else { return nil }
            update(icon: icon, with: path)
            return publishers[icon]
        }
        
        func request(icon: String) -> Bool {
            !received.contains(icon)
        }
        
        func received(icon: String) {
            received.insert(icon)
        }
        
        func update(icon: String, with path: URL) {
            if publishers[icon] == nil {
                publishers[icon] = .init(nil)
            }
            
            if publishers[icon]!.value == nil {
                publishers[icon]!.value = image(for: icon, with: path)
            }
        }
        
        private func image(for icon: String, with path: URL) -> Output? {
            let url = path.appendingPathComponent(icon)
            
            guard
                FileManager.default.fileExists(atPath: url.path),
                let data = try? Data(contentsOf: url)
            else { return nil }
            
            return .init(data: data)
        }
    }
}

#endif
