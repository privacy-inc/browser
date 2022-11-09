public enum Rule: CaseIterable {
    case
    cookies,
    http,
    ads,
    screen,
    antidark,
    third
    
//    var rules: [Rule] {
//        switch self {
//        case .cookies:
//            return [.init(trigger: .all, action: .cookies)]
//        case .http:
//            return [.init(trigger: .all, action: .http)]
//        case .ads:
//            return [.init(trigger: .url(.ecosia), action: .css([".card-ad",
//                                                                ".card-productads"])),
//                    .init(trigger: .url(.google), action: .css(["#taw",
//                                                                "#rhs",
//                                                                "#tadsb",
//                                                                ".commercial",
//                                                                ".Rn1jbe",
//                                                                ".kxhcC",
//                                                                ".isv-r.PNCib.BC7Tfc",
//                                                                ".isv-r.PNCib.o05QGe"])),
//                    .init(trigger: .url(.youtube), action: .css([".ytd-search-pyv-renderer",
//                                                                 ".video-ads.ytp-ad-module"])),
//                    .init(trigger: .url(.bloomberg), action: .css([".leaderboard-wrapper"])),
//                    .init(trigger: .url(.forbes), action: .css([".top-ad-container"])),
//                    .init(trigger: .url(.huffpost), action: .css(["#advertisement-thamba"])),
//                    .init(trigger: .url(.wordpress), action: .css([".inline-ad-slot"])),
//                    .init(trigger: .all, action: .css(["[id*='google_ads']",
//                                                       "[id*='ezoic']",
//                                                       "[id*='adngin']",
//                                                       "[id*='outbrain']",
//                                                       "[id*='taboola']",
//                                                       "[class*='ezoic']",
//                                                       "[class*='ad_placeholder']",
//                                                       "[class*='ad-container']",
//                                                       "[class*='ads-block']",
//                                                       "[class*='wio-']",
//                                                       "[class*='ad-support']",
//                                                       "[class*='-top-ad']",
//                                                       "#ad-footer",
//                                                       ".adwrapper",
//                                                       ".ad-wrapper",
//                                                       ".ad_wrapper",
//                                                       ".adswrapper",
//                                                       ".ads-wrapper",
//                                                       ".ads_wrapper",
//                                                       ".adcontainer",
//                                                       ".ad_container",
//                                                       ".adscontainer",
//                                                       ".ads-container",
//                                                       ".ads_container",
//                                                       ".ad-footer",
//                                                       ".traffic-stars",
//                                                       ".tms-ad",
//                                                       ".m-inread-ad",
//                                                       ".outbrain"
//                                                      ]))]
//        case .screen:
//            return [.init(trigger: .url(.google), action: .css(["#consent-bump",
//                                                                "#lb",
//                                                                ".hww53CMqxtL__mobile-promo",
//                                                                "#Sx9Kwc",
//                                                                "#xe7COe",
//                                                                ".NIoIEf",
//                                                                ".QzsnAe.crIj3e",
//                                                                ".ml-promotion-container",
//                                                                ".USRMqe",
//                                                                ".n3tEjf-gNgoK-haAclf",
//                                                                ".tPWKIe",
//                                                                ".ruuNWe"])),
//                    .init(trigger: .url(.ecosia), action: .css([".serp-cta-wrapper",
//                                                                ".js-whitelist-notice",
//                                                                ".callout-whitelist",
//                                                                ".cookie-notice"])),
//                    .init(trigger: .url(.youtube), action: .css(["#consent-bump",
//                                                                 ".opened",
//                                                                 ".ytd-popup-container",
//                                                                 ".upsell-dialog-lightbox",
//                                                                 ".consent-bump-lightbox",
//                                                                 ".consent-bump-v2-lightbox",
//                                                                 "#lightbox",
//                                                                 ".ytd-consent-bump-v2-renderer"])),
//                    .init(trigger: .url(.instagram), action: .css([".RnEpo.Yx5HN",
//                                                                   ".RnEpo._Yhr4",
//                                                                   ".R361B",
//                                                                   ".NXc7H.jLuN9.X6gVd",
//                                                                   ".f11OC"])),
//                    .init(trigger: .url(.twitter), action: .css([
//                        ".css-1dbjc4n.r-aqfbo4.r-1p0dtai.r-1d2f490.r-12vffkv.r-1xcajam.r-zchlnj",
//                        "#layers"])),
//                    .init(trigger: .url(.reuters), action: .css(["#onetrust-consent-sdk",
//                                                                 "#newReutersModal"])),
//                    .init(trigger: .url(.thelocal), action: .css(["#qc-cmp2-container",
//                                                                  ".tp-modal",
//                                                                  ".tp-backdrop"])),
//                    .init(trigger: .url(.pinterest), action: .css(
//                        [".Jea.LCN.Lej.PKX._he.dxm.fev.fte.gjz.jzS.ojN.p6V.qJc.zI7.iyn.Hsu",
//                         ".QLY.Rym.ZZS._he.ojN.p6V.zI7.iyn.Hsu"])),
//                    .init(trigger: .url(.bbc), action: .css([".fc-consent-root",
//                                                             ".ssrcss-u3tmht-ConsentBanner.exhqgzu6",
//                                                             "#cookiePrompt"])),
//                    .init(trigger: .url(.reddit), action: .css(["._3q-XSJ2vokDQrvdG6mR__k",
//                                                                ".EUCookieNotice",
//                                                                ".XPromoPopup"])),
//                    .init(trigger: .url(.medium), action: .css([".branch-journeys-top",
//                                                                "#lo-highlight-meter-1-highlight-box",
//                                                                "#branch-banner-iframe"])),
//                    .init(trigger: .url(.bloomberg), action: .css(["#fortress-paywall-container-root",
//                                                                   ".overlay-container",
//                                                                   "#fortress-preblocked-container-root"])),
//                    .init(trigger: .url(.forbes), action: .css(["#consent_blackbar"])),
//                    .init(trigger: .url(.huffpost), action: .css(["#qc-cmp2-container"])),
//                    .init(trigger: .url(.nytimes), action: .css([".expanded-dock"])),
//                    .init(trigger: .url(.wordpress), action: .css(["#cmp-app-container"])),
//                    .init(trigger: .all, action: .css(["#gdpr-consent-tool-wrapper"
//                                                      ]))]
//        case .antidark:
//            return [.init(trigger: .url(.google), action: .css([".P1Ycoe",
//                                                                "#sDeBje"]))]
//        case .third:
//            return [.init(trigger: .script, action: .block)]
//        }
//    }
}
