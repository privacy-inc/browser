import Foundation
import Archivable

public struct Tracking: Storable {
    public var total: Int {
        domains
            .values
            .flatMap {
                $0
                    .map(\.value)
                    .map(Int.init)
            }
            .reduce(0, +)
    }
    
    public var data: Data {
        .init()
        .adding(collection: UInt16.self, strings: UInt8.self, items: trackers)
        .adding(UInt16(domains.count))
        .adding(domains
            .flatMap { item in
                Data()
                    .adding(size: UInt8.self, string: item.key)
                    .adding(UInt16(item.value.count))
                    .adding(item
                        .value
                        .flatMap { tracker in
                            Data()
                                .adding(tracker.key)
                                .adding(tracker.value)
                        })
            })
    }
    
    public init(data: inout Data) {
        trackers = data.items(collection: UInt16.self, strings: UInt8.self)
        domains = (0 ..< .init(data.number() as UInt16))
            .reduce(into: [:]) { result, _ in
                result[data.string(size: UInt8.self)] = (0 ..< .init(data.number() as UInt16))
                    .reduce(into: [:]) { result, _ in
                        result[data.number()] = data.number()
                    }
            }
    }
    
    private let domains: [String : [UInt16 : UInt16]]
    private let trackers: [String]
    
    public init() {
        self.init(domains: [:], trackers: [])
    }
    
    private init(domains: [String : [UInt16 : UInt16]], trackers: [String]) {
        self.domains = domains
        self.trackers = trackers
    }
    
    public func count(domain: String) -> Int {
        domains[domain, default: [:]]
            .map(\.value)
            .map(Int.init)
            .reduce(0, +)
    }
    
    public func items(for domain: String) -> [Item] {
        domains[domain, default: [:]]
            .map {
                .init(tracker: trackers[.init($0.key)], count: .init($0.value))
            }
            .sorted { (first: Item, second: Item) -> Bool in
                first.count == second.count
                    ? first.tracker.localizedCaseInsensitiveCompare(second.tracker) == .orderedAscending
                    : first.count > second.count
            }
    }
    
    func with(tracker: String, on domain: String) -> Self {
        trackers
            .index(element: tracker) { index, trackers in
                .init(domains: domains.increase(tracker: .init(index), for: domain),
                      trackers: trackers)
            }
    }
}

private extension Array where Element : Equatable {
    func index<T>(element: Element, result: (Int, Self) -> T) -> T {
        firstIndex(of: element)
            .map {
                result($0, self)
            }
        ?? result(count, self + element)
    }
}

private extension Dictionary where Key == String, Value == [UInt16 : UInt16] {
    func increase(tracker: UInt16, for domain: String) -> Self {
        var result = self
        result[domain, default: [:]][tracker, default: 0] += 1
        return result
    }
}
