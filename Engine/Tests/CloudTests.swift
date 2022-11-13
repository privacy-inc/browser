import XCTest
@testable import Archivable
@testable import Engine

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testHistory() async {
        var history = await cloud.actor.model.history
        XCTAssertTrue(history.isEmpty)
        
        let url = URL(string: "https://www.google.com")!
        await cloud.history(url: url, title: "something")
        
        history = await cloud.actor.model.history
        XCTAssertEqual(history.count, 1)
        
        await cloud.history(url: url, title: "something else")
        
        history = await cloud.actor.model.history
        XCTAssertEqual(history.count, 1)
        
        await cloud.history(url: .init(string: "https://www.wikipedia.org")!, title: "something else")
        
        history = await cloud.actor.model.history
        XCTAssertEqual(history.count, 2)
    }
    
    func testBookmarks() async {
        var items = await cloud.actor.model.bookmarks
        XCTAssertTrue(items.isEmpty)
        
        await cloud.add(bookmark: .init("www.hello.com", "hello"))
        items = await cloud.actor.model.bookmarks
        XCTAssertEqual("www.hello.com", items.first?.url)
        XCTAssertEqual("hello", items.first?.title)
    }
    
    func testPolicy() async {
        let response = await cloud.policy(request: .init(string: "https://google.com/hello")!, from: .init(string: "https://google.com")!)
        XCTAssertEqual(.allow, response)
        let logged = await cloud.model.log.first
        XCTAssertEqual(logged?.domain, "google.com")
        XCTAssertEqual(logged?.url, "https://google.com/hello")

        if case .block = await cloud.policy(request: .init(string: "https://something.googleapis.com")!, from: .init(string: "https://google.com")!) {
            let tracking = await cloud.model.tracking.items(for: "google.com")
            XCTAssertEqual([.init(tracker: "googleapis", count: 1)], tracking)
        } else {
            XCTFail()
        }
    }
}
