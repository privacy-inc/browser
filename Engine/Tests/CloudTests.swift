import XCTest
@testable import Archivable
@testable import Engine

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
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
}
