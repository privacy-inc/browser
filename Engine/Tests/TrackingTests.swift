import XCTest
@testable import Engine

final class TrackingTests: XCTestCase {
    func testTracking() {
        let tracking = Tracking()
            .with(tracker: "evil1", on: "avocado.org")
            .with(tracker: "evil2", on: "avocado.org")
            .with(tracker: "evil1", on: "tulum.com")
            .with(tracker: "evil3", on: "avocado.org")
            .with(tracker: "evil4", on: "sol.com")
            .with(tracker: "evil1", on: "avocado.org")
        
        XCTAssertEqual(6, tracking.total)
        XCTAssertEqual(4, tracking.count(domain: "avocado.org"))
        XCTAssertEqual(1, tracking.count(domain: "tulum.com"))
        XCTAssertEqual(1, tracking.count(domain: "sol.com"))
        XCTAssertEqual(0, tracking.count(domain: "moon.com"))
        XCTAssertEqual([
            .init(tracker: "evil1", count: 2),
            .init(tracker: "evil2", count: 1),
            .init(tracker: "evil3", count: 1)], tracking.items(for: "avocado.org"))
    }
    
    func testStorable() {
        let tracking = Tracking()
            .with(tracker: "evil1", on: "avocado.org")
            .with(tracker: "evil2", on: "avocado.org")
            .with(tracker: "evil1", on: "tulum.com")
            .with(tracker: "evil3", on: "avocado.org")
            .with(tracker: "evil4", on: "sol.com")
            .with(tracker: "evil1", on: "avocado.org")
        
        XCTAssertEqual([
            .init(tracker: "evil1", count: 2),
            .init(tracker: "evil2", count: 1),
            .init(tracker: "evil3", count: 1)], tracking.data.prototype(Tracking.self).items(for: "avocado.org"))
    }
}
