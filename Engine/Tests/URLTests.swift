import XCTest
@testable import Engine

final class URLTests: XCTestCase {
    func testFileName() {
        XCTAssertEqual("ecosia.png", URL(string: "https://www.ecosia.org")!.fileName(with: "png"))
        XCTAssertEqual("ecosia.png", URL(string: "https://www.ecosia.org/")!.fileName(with: "png"))
        XCTAssertEqual("ecosia.png", URL(string: "https://www.ecosia.org/something/sdsd/sddaadsdas/abc")!.fileName(with: "png"))
        XCTAssertEqual("abc.png", URL(string: "https://www.ecosia.org/something/sdsd/sddaadsdas/abc.html")!.fileName(with: "png"))
        XCTAssertEqual("x.png", URL(string: "https://www.ecosia.org/something/sdsd/sddaadsdas/abc.x.html")!.fileName(with: "png"))
        XCTAssertEqual("ecosia.png", URL(string: "https://www.ecosia.org/something/sdsd/sddaadsdas/abc/")!.fileName(with: "png"))
    }
    
    func testRemote() {
        XCTAssertNil(URL(string: "privacy://hello%20world")?.asRemoteString)
        XCTAssertNil(URL(string: "data:image/jpeg;base64")?.asRemoteString)
        XCTAssertNil(URL(string: "about:blank")?.asRemoteString)
        XCTAssertNil(URL(fileURLWithPath: NSTemporaryDirectory() + "file.html").asRemoteString)
        XCTAssertEqual("https://www.aguacate.com", URL(string: "https://www.aguacate.com")?.asRemoteString)
        XCTAssertEqual("https://goprivacy.app", URL(string: "https://goprivacy.app")?.asRemoteString)
    }
    
    func testIcon() {
        XCTAssertEqual("www.ck%2Fhello", URL(string: "http://www.avocado.www.ck/hello")?.asFavicon)
        XCTAssertEqual("hello.com%2Fa", URL(string: "https://hello.com/a")?.asFavicon)
        XCTAssertEqual("hello.com", URL(string: "http://hello.com")?.asFavicon)
        XCTAssertEqual("hello.com%2Fa", URL(string: "https://a.hello.com/a?var=3231123")?.asFavicon)
        XCTAssertEqual("hello.com%2Fa", URL(string: "https://a.hello.com/a/b/c?var=3231123")?.asFavicon)
        XCTAssertEqual("hello.com", URL(string: "https://a.hello.com/?var=3231123")?.asFavicon)
        XCTAssertEqual("twitter.com%2F_vaux", URL(string: "http://twitter.com/_vaux")?.asFavicon)
        XCTAssertEqual("wikipedia.org%2Fwiki", URL(string: "https://de.m.wikipedia.org/wiki/Alan_Moore#/languages")?.asFavicon)
    }
}
