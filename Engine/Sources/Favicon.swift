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
            let asFavicon = website.asFavicon,
            await !actor.received.contains(asFavicon)
        else { return false }
        return true
    }
    
    public func received(url: String, for website: URL) async {
        guard let asFavicon = website.asFavicon else { return }
        await actor.received(asFavicon: asFavicon)
        
        guard
            !url.isEmpty,
            let url = URL(string: url)
        else { return }
        
        try? await fetch(url: url, for: asFavicon)
    }

    private func fetch(url: URL, for asFavicon: String) async throws {
        let (location, response) = try await session.download(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            try? FileManager.default.removeItem(at: location)
            return
        }
        
        let fileName = actor.path.appendingPathComponent(asFavicon)
        
        if FileManager.default.fileExists(atPath: fileName.path) {
            try? FileManager.default.removeItem(at: fileName)
        }
        
        try? FileManager.default.moveItem(at: location, to: fileName)
        
        await actor.update(asFavicon: asFavicon)
    }
}

#endif
