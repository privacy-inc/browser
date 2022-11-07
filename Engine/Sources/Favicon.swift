import Foundation
import Combine
import Domains

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

#if os(macOS) || os(iOS)

public final actor Favicon {
    private var received = Set<String>()
    private var publishers = [String : Pub]()
    
    nonisolated private let session: URLSession = {
        var configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 6
        configuration.timeoutIntervalForResource = 6
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        return .init(configuration: configuration)
    } ()
    
    private lazy var path = directory()
    
    public init() {
        
    }
    
    public func publisher(for website: URL) -> Pub? {
        guard let icon = try? website.icon else { return nil }
        
        if publishers[icon] == nil {
            publishers[icon] = .init()
        }
        
        let publisher = publishers[icon]!
        
        Task
            .detached(priority: .utility) {
                if await publisher.output == nil {
                    guard let output = await self.output(for: icon) else { return }
                    await publisher.received(output: output)
                }
            }
        
        return publisher
    }
    
    public func request(for website: URL) -> Bool {
        guard
            let icon = try? website.icon,
            !received.contains(icon)
        else { return false }
        return true
    }
    
    public func received(url: String, for website: URL) async {
        guard let icon = try? website.icon else { return }
        received.insert(icon)
        
        guard
            !url.isEmpty,
            let url = URL(string: url)
        else { return }
        
        Task
            .detached(priority: .utility) {
                try? await self.fetch(url: url, for: icon)
            }
    }
    
    public func clear() {
        publishers = [:]
        received = []
        
        Task
            .detached(priority: .utility) {
                await self.regenerate()
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
        
        guard let output = output(for: icon) else { return }
        
        if publishers[icon] == nil {
            publishers[icon] = .init()
        }
        
        await publishers[icon]!.received(output: output)
    }
    
    private func output(for icon: String) -> Pub.Output? {
        let url = path.appendingPathComponent(icon)
        
        guard
            FileManager.default.fileExists(atPath: url.path),
            let data = try? Data(contentsOf: url)
        else { return nil }
        
        return .init(data: data)
    }
    
    private func regenerate() {
        try? FileManager.default.removeItem(at: path)
        path = directory()
    }
    
    private func directory() -> URL {
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

extension Favicon {
    public final actor Pub: Publisher {
#if os(macOS)
public typealias Output = NSImage
#elseif os(iOS)
public typealias Output = UIImage
#endif

        public typealias Failure = Never
        fileprivate private(set) var output: Output?
        private var contracts = [Contract]()
        
        fileprivate func received(output: Output) async {
            self.output = output
            await clean()
            await send(contracts: contracts, output: output)
        }
        
        public nonisolated func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let sub = Sub(subscriber: .init(subscriber))
            subscriber.receive(subscription: sub)
            
            let contract = Contract(sub: sub)
            
            Task {
                await store(contract: contract)
                
                if let output = await output {
                    await sub.send(output: output)
                }
            }
        }
        
        private func store(contract: Contract) async {
            contracts.append(contract)
            await clean()
        }
        
        private func send(contracts: [Contract], output: Output) async {
            for contract in contracts {
                await contract.sub?.send(output: output)
            }
        }
        
        private func clean() async {
            let all = contracts
            var active = [Contract]()
            for contract in all {
                if await contract.sub?.subscriber != nil {
                    active.append(contract)
                }
            }
            contracts = active
        }
    }
}
    
private extension Favicon.Pub {
    final actor Sub: Subscription {
        private(set) var subscriber: AnySubscriber<Output, Failure>?
        
        init(subscriber: AnySubscriber<Output, Failure>) {
            self.subscriber = subscriber
        }
        
        func send(output: Output) async {
            if let subscriber = subscriber {
                await send(subscriber: subscriber, output: output)
            }
        }
        
        nonisolated func cancel() {
            Task {
                await clear()
            }
        }
        
        nonisolated func request(_: Subscribers.Demand) {

        }
        
        private func clear() {
            subscriber = nil
        }
        
        @MainActor private func send(subscriber: AnySubscriber<Output, Failure>, output: Output) {
            _ = subscriber.receive(output)
        }
    }
    
    struct Contract {
        private(set) weak var sub: Sub?
        
        init(sub: Sub) {
            self.sub = sub
        }
    }
}

#endif
