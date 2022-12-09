import Foundation
import Combine
import Domains

#if os(macOS) || os(iOS)

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public final class Favicon: @unchecked Sendable {
#if os(macOS)
    public typealias Icon = NSImage
#elseif os(iOS)
    public typealias Icon = UIImage
#endif
    
    public let icons = CurrentValueSubject<_, Never>([String : Icon]())
    private let session: URLSession
    private let path: URL
    
    public init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        session = .init(configuration: configuration)
        
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("favicons")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            var resources = URLResourceValues()
            resources.isExcludedFromBackup = true
            try? url.setResourceValues(resources)
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        
        path = url
    }
    
    @MainActor public func load(iconIdentifier: String) {
        guard icons.value[iconIdentifier] == nil else { return }
        
        let url = path.appendingPathComponent(iconIdentifier)
        
        guard
            FileManager.default.fileExists(atPath: url.path),
            let data = try? Data(contentsOf: url),
            let image = Icon(data: data)
        else { return }
        
        icons.value[iconIdentifier] = image
    }
    
    public func received(url: String, for iconIdentifier: String) {
        Task {
            guard
                await needs(iconIdentifier: iconIdentifier),
                !url.isEmpty,
                let url = URL(string: url)
            else { return }
            try? await fetch(url: url, for: iconIdentifier)
            await load(iconIdentifier: iconIdentifier)
        }
    }
    
    @MainActor private func needs(iconIdentifier: String) -> Bool {
        icons.value[iconIdentifier] == nil
    }

    private func fetch(url: URL, for iconIdentifier: String) async throws {
        let (location, response) = try await session.download(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            try? FileManager.default.removeItem(at: location)
            return
        }

        let fileName = path.appendingPathComponent(iconIdentifier)

        if FileManager.default.fileExists(atPath: fileName.path) {
            try? FileManager.default.removeItem(at: fileName)
        }

        try? FileManager.default.moveItem(at: location, to: fileName)
    }
}

#endif
