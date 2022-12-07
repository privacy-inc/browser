import Foundation

#if os(macOS) || os(iOS)

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

extension Favicon {
    final actor Actor {
        let path: URL
        private var received = Set<String>()
        private var icons = [String : Icon]()
        
        init() {
            var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("favicons")
            
            if !FileManager.default.fileExists(atPath: url.path) {
                var resources = URLResourceValues()
                resources.isExcludedFromBackup = true
                try? url.setResourceValues(resources)
                try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            }
            
            self.path = url
        }
        
        func icon(for website: URL) -> Icon? {
            guard let icon = website.icon else { return nil }
            update(icon: icon)
            return icons[icon]
        }
        
        func request(icon: String) -> Bool {
            !received.contains(icon)
        }
        
        func received(icon: String) {
            received.insert(icon)
        }
        
        func update(icon: String) {
            guard icons[icon] == nil else { return }
            
            let url = path.appendingPathComponent(icon)
            
            guard
                FileManager.default.fileExists(atPath: url.path),
                let data = try? Data(contentsOf: url),
                let image = Icon(data: data)
            else { return }
            
            icons[icon] = image
        }
    }
}

#endif
