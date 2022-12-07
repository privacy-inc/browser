import Foundation
import Domains

#if os(macOS) || os(iOS)

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public final class Favicon {
#if os(macOS)
    public typealias Icon = NSImage
#elseif os(iOS)
    public typealias Icon = UIImage
#endif
    
    private var actor = Actor()
    private let session: URLSession
    
    public init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        session = .init(configuration: configuration)
    }
    
    public func icon(for website: URL) async -> Icon? {
        await actor.icon(for: website)
    }
    
    public func request(for website: URL) async -> Bool {
        guard
            let icon = website.icon,
            await !actor.received.contains(icon)
        else { return false }
        return true
    }
    
    public func received(url: String, for website: URL) async {
        guard let icon = website.icon else { return }
        await actor.received(icon: icon)
        
        guard
            !url.isEmpty,
            let url = URL(string: url)
        else { return }
        
        try? await fetch(url: url, for: icon)
    }

    private func fetch(url: URL, for icon: String) async throws {
        let (location, response) = try await session.download(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            try? FileManager.default.removeItem(at: location)
            return
        }
        
        let file = actor.path.appendingPathComponent(icon)
        
        if FileManager.default.fileExists(atPath: file.path) {
            try? FileManager.default.removeItem(at: file)
        }
        
        try? FileManager.default.moveItem(at: location, to: file)
        
        await actor.update(icon: icon)
    }
}

#endif
