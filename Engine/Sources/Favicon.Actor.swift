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
        private(set) var received = Set<String>()
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
            guard let asFavicon = website.asFavicon else { return nil }
            update(asFavicon: asFavicon)
            return icons[asFavicon]
        }
        
        func received(asFavicon: String) {
            received.insert(asFavicon)
        }
        
        func update(asFavicon: String) {
            guard icons[asFavicon] == nil else { return }
            
            let url = path.appendingPathComponent(asFavicon)
            
            guard
                FileManager.default.fileExists(atPath: url.path),
                let data = try? Data(contentsOf: url),
                let image = Icon(data: data)
            else { return }
            
            icons[asFavicon] = image
        }
    }
}

#endif
