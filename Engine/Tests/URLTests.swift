import XCTest
@testable import Engine

final class URLTests: XCTestCase {
    func testFileName() {
        XCTAssertEqual("ecosia.png", URL(string: "https://www.ecosia.org")!.file("png"))
        XCTAssertEqual("ecosia.png", URL(string: "https://www.ecosia.org/")!.file("png"))
        XCTAssertEqual("ecosia.png", URL(string: "https://www.ecosia.org/something/sdsd/sddaadsdas/abc")!.file("png"))
        XCTAssertEqual("abc.png", URL(string: "https://www.ecosia.org/something/sdsd/sddaadsdas/abc.html")!.file("png"))
        XCTAssertEqual("x.png", URL(string: "https://www.ecosia.org/something/sdsd/sddaadsdas/abc.x.html")!.file("png"))
        XCTAssertEqual("ecosia.png", URL(string: "https://www.ecosia.org/something/sdsd/sddaadsdas/abc/")!.file("png"))
    }
    
    func testRemote() {
        XCTAssertNil(URL(string: "privacy://hello%20world")?.remoteString)
        XCTAssertNil(URL(string: "data:image/jpeg;base64")?.remoteString)
        XCTAssertNil(URL(string: "about:blank")?.remoteString)
        XCTAssertNil(URL(fileURLWithPath: NSTemporaryDirectory() + "file.html").remoteString)
        XCTAssertEqual("https://www.aguacate.com", URL(string: "https://www.aguacate.com")?.remoteString)
        XCTAssertEqual("https://goprivacy.app", URL(string: "https://goprivacy.app")?.remoteString)
    }
    
    func testIcon() {
        XCTAssertEqual("www.avocado.www.ck%2Fhello", URL(string: "www.avocado.www.ck/hello")?.icon)
        XCTAssertEqual("hello.com%2Fa", URL(string: "https://hello.com/a")?.icon)
        XCTAssertEqual("hello.com", URL(string: "http://hello.com")?.icon)
        XCTAssertEqual("a.hello.com%2Fa", URL(string: "https://a.hello.com/a?var=3231123")?.icon)
        XCTAssertEqual("a.hello.com%2Fa", URL(string: "https://a.hello.com/a/b/c?var=3231123")?.icon)
        XCTAssertEqual("a.hello.com%2F", URL(string: "https://a.hello.com/?var=3231123")?.icon)
        XCTAssertEqual("twitter.com%2F_vaux", URL(string: "twitter.com/_vaux")?.icon)
        XCTAssertEqual("de.m.wikipedia.org%2Fwiki", URL(string: "https://de.m.wikipedia.org/wiki/Alan_Moore#/languages")?.icon)
    }
}
