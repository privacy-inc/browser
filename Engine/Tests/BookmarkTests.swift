import XCTest
import Engine

final class BookmarkTests: XCTestCase {
    func testURL() {
        XCTAssertNil(Bookmark(url: "", title: ""))
        XCTAssertNotNil(Bookmark(url: "hello.com", title: ""))
    }
    
    func testScheme() {
        let item = Bookmark(url: "hello.com", title: "")
        XCTAssertEqual("http://hello.com", item?.url)
    }
}
