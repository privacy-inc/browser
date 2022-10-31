import XCTest
@testable import Engine

final class MigrationTests: XCTestCase {
    func testBookmarks() async throws {
        var parsed = await Archive.init(version: 1, timestamp: 0, data: Archive_v1(
            bookmarks: []).data)
            .bookmarks
        XCTAssertTrue(parsed.isEmpty)
        
        parsed = await Archive.init(version: 1, timestamp: 0, data: Archive_v1(
            bookmarks: [.init(id: "www.something.else", title: "hello world"),
                        .init(id: "www.testing.com", title: "lorem ipsum")]).data)
        .bookmarks
        
        XCTAssertEqual(parsed.first?.title, "hello world")
        XCTAssertEqual(parsed.first?.url, "www.something.else")
        
        XCTAssertEqual(parsed.last?.title, "lorem ipsum")
        XCTAssertEqual(parsed.last?.url, "www.testing.com")
    }
}
