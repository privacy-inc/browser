public struct Rule {
    public static var list: String {
        "[" + compress
            .map {
                """
    {
        "action": {
            \($0.action.content)
        },
        "trigger": {
            \($0.trigger.content)
        }
    }
    """
            }
            .joined(separator: ",") + "]"
    }
    
    private static var compress: [Self] {
        let items = self.items
        return items
            .filter {
                $0.trigger == .all || $0.trigger == .scripts
            }
        + items
            .filter {
                $0.trigger != .all && $0.trigger != .scripts
            }
            .reduce(into: [Allowed : Set<String>]()) {
                if case let .cssNone(css) = $1.action,
                   case let .url(url) = $1.trigger {
                    $0[url, default: []]
                        .formUnion(css)
                }
            }
            .map {
                .init(.url($0.0), .cssNone($0.1))
            }
    }
    
    private static var items: [Self] {
        cookies + ads + screen + dark
    }
    
    private static var cookies: [Self] {
        [.init(.all, .blockCookies)]
    }
    
    private static var ads: [Self] {
        [.init(.ecosia, [".card-ad",
                         ".card-productads"]),
         .init(.google, ["#taw",
                         "#rhs",
                         "#tadsb",
                         ".commercial",
                         ".Rn1jbe",
                         ".kxhcC",
                         ".isv-r.PNCib.BC7Tfc",
                         ".isv-r.PNCib.o05QGe"]),
         .init(.youtube, [".ytd-search-pyv-renderer",
                          ".video-ads.ytp-ad-module"]),
         .init(.bloomberg, [".leaderboard-wrapper"]),
         .init(.forbes, [".top-ad-container"]),
         .init(.huffpost, ["#advertisement-thamba"]),
         .init(.wordpress, [".inline-ad-slot"]),
         .init(["[id*='google_ads']",
                "[id*='ezoic']",
                "[id*='adngin']",
                "[id*='outbrain']",
                "[id*='taboola']",
                "[class*='ezoic']",
                "[class*='ad_placeholder']",
                "[class*='ad-container']",
                "[class*='ads-block']",
                "[class*='wio-']",
                "[class*='ad-support']",
                "[class*='-top-ad']",
                "#ad-footer",
                ".adwrapper",
                ".ad-wrapper",
                ".ad_wrapper",
                ".adswrapper",
                ".ads-wrapper",
                ".ads_wrapper",
                ".adcontainer",
                ".ad_container",
                ".adscontainer",
                ".ads-container",
                ".ads_container",
                ".ad-footer",
                ".traffic-stars",
                ".tms-ad",
                ".m-inread-ad",
                ".outbrain"
               ])]
    }
    
    private static var screen: [Self] {
        [.init(.google, ["#consent-bump",
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
                         ".ruuNWe"]),
         .init(.ecosia, [".serp-cta-wrapper",
                         ".js-whitelist-notice",
                         ".callout-whitelist",
                         ".cookie-notice"]),
         .init(.youtube, ["#consent-bump",
                          ".opened",
                          ".ytd-popup-container",
                          ".upsell-dialog-lightbox",
                          ".consent-bump-lightbox",
                          ".consent-bump-v2-lightbox",
                          "#lightbox",
                          ".ytd-consent-bump-v2-renderer"]),
         .init(.instagram, [".RnEpo.Yx5HN",
                            ".RnEpo._Yhr4",
                            ".R361B",
                            ".NXc7H.jLuN9.X6gVd",
                            ".f11OC"]),
         .init(.twitter, [
            ".css-1dbjc4n.r-aqfbo4.r-1p0dtai.r-1d2f490.r-12vffkv.r-1xcajam.r-zchlnj",
            "#layers"]),
         .init(.reuters, ["#onetrust-consent-sdk",
                          "#newReutersModal"]),
         .init(.thelocal, ["#qc-cmp2-container",
                           ".tp-modal",
                           ".tp-backdrop"]),
         .init(.pinterest,
               [".Jea.LCN.Lej.PKX._he.dxm.fev.fte.gjz.jzS.ojN.p6V.qJc.zI7.iyn.Hsu",
                ".QLY.Rym.ZZS._he.ojN.p6V.zI7.iyn.Hsu"]),
         .init(.bbc, [".fc-consent-root",
                      ".ssrcss-u3tmht-ConsentBanner.exhqgzu6",
                      "#cookiePrompt"]),
         .init(.reddit, ["._3q-XSJ2vokDQrvdG6mR__k",
                         ".EUCookieNotice",
                         ".XPromoPopup"]),
         .init(.medium, [".branch-journeys-top",
                         "#lo-highlight-meter-1-highlight-box",
                         "#branch-banner-iframe"]),
         .init(.bloomberg, ["#fortress-paywall-container-root",
                            ".overlay-container",
                            "#fortress-preblocked-container-root"]),
         .init(.forbes, ["#consent_blackbar"]),
         .init(.huffpost, ["#qc-cmp2-container"]),
         .init(.nytimes, [".expanded-dock"]),
         .init(.wordpress, ["#cmp-app-container"]),
         .init(["#gdpr-consent-tool-wrapper"])]
    }
    
    private static var dark: [Self] {
        [.init(.google, [".P1Ycoe",
                         "#sDeBje"])]
    }
    
    private static var thirdParty: [Self] {
        [.init(.scripts, .block)]
    }
    
    private let trigger: Trigger
    private let action: Action
    
    private init(_ trigger: Trigger, _ action: Action) {
        self.trigger = trigger
        self.action = action
    }
    
    private init(_ css: Set<String>) {
        trigger = .all
        action = .cssNone(css)
    }
    
    private init(_ allowed: Allowed, _ css: Set<String>) {
        trigger = .url(allowed)
        action = .cssNone(css)
    }
}
