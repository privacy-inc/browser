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
        
        await cloud.delete(history: "https://www.wikipedia.org")
        
        history = await cloud.actor.model.history
        XCTAssertEqual(history.count, 1)
    }
    
    func testBookmarks() async {
        var items = await cloud.actor.model.bookmarks
        XCTAssertTrue(items.isEmpty)
        
        await cloud.add(bookmark: .init("www.hello.com", "hello"))
        items = await cloud.actor.model.bookmarks
        XCTAssertEqual("www.hello.com", items.first?.url)
        XCTAssertEqual("hello", items.first?.title)
        
        await cloud.add(bookmark: .init("www.hello.com", "hello duplicated"))
        items = await cloud.actor.model.bookmarks
        XCTAssertEqual(items.count, 1)
        
        await cloud.delete(bookmark: "www.hello.com")
        items = await cloud.actor.model.bookmarks
        XCTAssertTrue(items.isEmpty)
        
        await cloud.add(bookmark: .init("www.hello.com", "hello again"))
        await cloud.update(bookmark: .init("www.hello2.com", "hello again 2"), for: "www.hello.com")
        items = await cloud.actor.model.bookmarks
        XCTAssertEqual("www.hello2.com", items.first?.url)
        XCTAssertEqual(items.count, 1)
    }
    
    func testPolicy() {
        let response = cloud.policy(request: .init(string: "https://google.com/hello")!, from: .init(string: "https://google.com")!)
        XCTAssertEqual(.allow, response)
    }
}
