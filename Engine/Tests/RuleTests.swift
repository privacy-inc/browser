import XCTest
@testable import Engine

final class RuleTests: XCTestCase {
    func testAllCases() {
        XCTAssertTrue(Parser(content: Rule.list).cookies)
        XCTAssertEqual(1, Parser(content: Rule.list).amount(url: "google.com"))
        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "google.com", selectors: ["#taw",
                                                "#consent-bump",
                                                ".P1Ycoe"]))
    }

    func testAds() {
        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "ecosia.org", selectors: [".card-ad",
                                                ".card-productads"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "google.com", selectors: ["#taw",
                                                "#rhs",
                                                "#tadsb",
                                                ".commercial",
                                                ".Rn1jbe",
                                                ".kxhcC",
                                                ".isv-r.PNCib.BC7Tfc",
                                                ".isv-r.PNCib.o05QGe"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "youtube.com", selectors: [".ytd-search-pyv-renderer",
                                                 ".video-ads.ytp-ad-module"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "bloomberg.com", selectors: [".leaderboard-wrapper"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "forbes.com", selectors: [".top-ad-container"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "huffpost.com", selectors: ["#advertisement-thamba"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "wordpress.com", selectors: [".inline-ad-slot"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(selectors: ["[id*='google_ads']",
                             "[id*='ezoic']",
                             "[class*='ezoic']",
                             "[id*='adngin']",
                             ".adwrapper",
                             ".ad-wrapper",
                             "[class*='ad_placeholder']",
                             ".traffic-stars",
                             "[class*='ads-block']",
                             "[class*='wio-']",
                             ".ad-footer",
                             "#ad-footer",
                             "[class*='ad-support']",
                             "[class*='-top-ad']",
                             ".tms-ad",
                             ".m-inread-ad",
                             ".ads_container",
                             ".outbrain",
                             "[id*='outbrain']",
                             "[id*='taboola']",
                             "[class*='ad-container']"]))
    }

    func testScreen() {
        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "google.com", selectors: ["#consent-bump",
                                                "#lb",
                                                ".hww53CMqxtL__mobile-promo",
                                                "#Sx9Kwc",
                                                "#xe7COe",
                                                ".NIoIEf",
                                                ".QzsnAe.crIj3e",
                                                ".ml-promotion-container",
                                                ".USRMqe",
                                                ".n3tEjf-gNgoK-haAclf",
                                                ".tPWKIe",
                                                ".ruuNWe"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "ecosia.org", selectors: [".serp-cta-wrapper",
                                                ".js-whitelist-notice",
                                                ".callout-whitelist",
                                                ".cookie-notice"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "youtube.com", selectors: ["#consent-bump",
                                                 ".opened",
                                                 ".ytd-popup-container",
                                                 ".upsell-dialog-lightbox",
                                                 ".consent-bump-lightbox",
                                                 ".consent-bump-v2-lightbox",
                                                 "#lightbox",
                                                 ".ytd-consent-bump-v2-renderer"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "instagram.com", selectors: [".RnEpo.Yx5HN",
                                                   ".RnEpo._Yhr4",
                                                   ".R361B",
                                                   ".NXc7H.jLuN9.X6gVd",
                                                   ".f11OC"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "twitter.com", selectors: [
                ".css-1dbjc4n.r-aqfbo4.r-1p0dtai.r-1d2f490.r-12vffkv.r-1xcajam.r-zchlnj",
                "#layers"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "reuters.com", selectors: ["#onetrust-consent-sdk",
                                                 "#newReutersModal"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "thelocal.de", selectors: ["#qc-cmp2-container",
                                                 ".tp-modal",
                                                 ".tp-backdrop"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "pinterest.com", selectors: [
                ".Jea.LCN.Lej.PKX._he.dxm.fev.fte.gjz.jzS.ojN.p6V.qJc.zI7.iyn.Hsu",
                ".QLY.Rym.ZZS._he.ojN.p6V.zI7.iyn.Hsu"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "bbc.com", selectors: [".fc-consent-root",
                                             "#cookiePrompt",
                                             ".ssrcss-u3tmht-ConsentBanner.exhqgzu6"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "reddit.com", selectors: ["._3q-XSJ2vokDQrvdG6mR__k",
                                                ".EUCookieNotice",
                                                ".XPromoPopup"]))
        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "medium.com", selectors: [".branch-journeys-top",
                                                "#lo-highlight-meter-1-highlight-box",
                                                "#branch-banner-iframe"]))
        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "bloomberg.com", selectors: ["#fortress-paywall-container-root",
                                                   ".overlay-container",
                                                   "#fortress-preblocked-container-root"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "forbes.com", selectors: ["#consent_blackbar"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "huffpost.com", selectors: ["#qc-cmp2-container"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "nytimes.com", selectors: [".expanded-dock"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(url: "wordpress.com", selectors: ["#cmp-app-container"]))

        XCTAssertTrue(Parser(content: Rule.list)
            .css(selectors: ["#gdpr-consent-tool-wrapper"]))
    }
}

private struct Parser {
    private let dictionary: [[String : [String : Any]]]
    
    init(content: String) {
        dictionary = (try! JSONSerialization.jsonObject(with: .init(content.utf8))) as! [[String : [String : Any]]]
    }
    
    var cookies: Bool {
        dictionary.contains {
            ($0["action"]!["type"] as! String) == "block-cookies"
            && ($0["trigger"]!["url-filter"] as! String) == ".*"
        }
    }
    
    var http: Bool {
        dictionary.contains {
            ($0["action"]!["type"] as! String) == "make-https"
            && ($0["trigger"]!["url-filter"] as! String) == ".*"
        }
    }
    
    var third: Bool {
        dictionary.contains {
            ($0["action"]!["type"] as! String) == "block"
            && ($0["trigger"]!["url-filter"] as! String) == ".*"
            && ($0["trigger"]!["load-type"] as! [String]).first == "third-party"
            && ($0["trigger"]!["resource-type"] as! [String]).first == "script"
        }
    }
    
    func css(url: String, selectors: [String]) -> Bool {
        dictionary.contains {
            ($0["action"]!["type"] as! String) == "css-display-none"
            && ($0["action"]!["selector"] as! String)
                .components(separatedBy: ", ")
                .intersection(other: selectors).count == selectors.count
            && ($0["trigger"]!["url-filter"] as! String).hasPrefix("^https?://+([^:/]+\\.)?")
            && ($0["trigger"]!["url-filter"] as! String).hasSuffix("[:/]")
            && ($0["trigger"]!["url-filter-is-case-sensitive"] as! Bool)
            && ($0["trigger"]!["load-type"] as! [String]).first == "first-party"
            && ($0["trigger"]!["resource-type"] as! [String]).first == "document"
            && ($0["trigger"]!["if-domain"] as! [String]).first == "*" + url
        }
    }
    
    func css(selectors: [String]) -> Bool {
        dictionary.contains {
            ($0["action"]!["type"] as! String) == "css-display-none"
            && ($0["action"]!["selector"] as! String)
                .components(separatedBy: ", ")
                .intersection(other: selectors).count == selectors.count
            && ($0["trigger"]!["url-filter"] as! String) == ".*"
        }
    }
    
    func amount(url: String) -> Int {
        dictionary.filter {
            ($0["trigger"]?["if-domain"] as? [String])?.first == "*" + url
        }.count
    }
}

private extension Array where Element : Hashable {
    func intersection(other: [Element]) -> Set<Element> {
        .init(self)
        .intersection(other)
    }
}
