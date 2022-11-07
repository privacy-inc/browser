import Foundation
import Combine
import Domains

#if os(macOS) || os(iOS)

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public final class Favicon {
#if os(macOS)
    public typealias Output = NSImage
#elseif os(iOS)
    public typealias Output = UIImage
#endif
    
    private var actor = Actor()
    private var path: URL
    private let session: URLSession
    
    public init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 9
        configuration.timeoutIntervalForResource = 9
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        session = .init(configuration: configuration)
        
        path = Self.regenerate()
    }
    
    public func publisher(for website: URL) async -> CurrentValueSubject<Output?, Never>? {
        await actor.publisher(for: website, with: path)
    }
    
    public func request(for website: URL) async -> Bool {
        guard
            let icon = website.icon,
            await actor.request(icon: icon)
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
        
        Task
            .detached(priority: .utility) { [weak self] in
                try? await self?.fetch(url: url, for: icon)
            }
    }
    
    public func clear() {
        actor = .init()
        
        Task
            .detached(priority: .utility) { [weak self] in
                guard let self = self else { return }
                try? FileManager.default.removeItem(at: self.path)
                self.path = Self.regenerate()
            }
    }
    
    private func fetch(url: URL, for icon: String) async throws {
        let (location, response) = try await session.download(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            try? FileManager.default.removeItem(at: location)
            return
        }
        
        let file = path.appendingPathComponent(icon)
        
        if FileManager.default.fileExists(atPath: file.path) {
            try? FileManager.default.removeItem(at: file)
        }
        
        try? FileManager.default.moveItem(at: location, to: file)
        
        await actor.update(icon: icon, with: path)
    }
    
    private static func regenerate() -> URL {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("favicons")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            var resources = URLResourceValues()
            resources.isExcludedFromBackup = true
            try? url.setResourceValues(resources)
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        
        return url
    }
}

#endif
