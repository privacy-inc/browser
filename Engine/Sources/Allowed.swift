import Foundation
import Domains

enum Allowed: String, Filter {
    case
    ecosia,
    google,
    youtube,
    instagram,
    twitter,
    reuters,
    thelocal,
    pinterest,
    facebook,
    bbc,
    reddit,
    spiegel,
    snapchat,
    linkedin,
    nyt,
    nytimes,
    medium,
    bloomberg,
    forbes,
    immobilienscout24,
    huffpost,
    giphy,
    wp,
    wordpress,
    yahoo,
    _1und1 = "1und1"
    
    var tld: Tld {
        switch self {
        case .ecosia:
            return .org
        case .thelocal,
             .spiegel,
             .immobilienscout24,
             ._1und1:
            return .de
        default:
            return .com
        }
    }
    
    private var path: [Path] {
        switch self {
        case .google:
            return [.pagead,
                    .recaptcha,
                    .swg]
        case .facebook:
            return [.plugins,
                    .tr]
        case .reddit:
            return [.account]
        case .nyt:
            return [.ads]
        case .bloomberg:
            return [.subscription_offer]
        case .pinterest:
            return [.ct_html]
        default:
            return []
        }
    }
    
    private var subdomain: [Subdomain] {
        switch self {
        case .twitter:
            return [.platform]
        case .spiegel:
            return [.interactive,
                    .tarifvergleich]
        case .snapchat:
            return [.tr]
        case .linkedin:
            return [.platform]
        case .google:
            return [.accounts,
                    .mobileads]
        case .immobilienscout24:
            return [.tracking]
        case .giphy:
            return [.cookies]
        case .wp:
            return [.widgets]
        case .wordpress:
            return [.public_api,
                    .r_login]
        case .yahoo:
            return [.analytics]
        case ._1und1:
            return [.dsl]
        default:
            return []
        }
    }
    
    static func response(for domain: Domain, on: URL) -> Policy? {
        Self(rawValue: domain.name)
            .map { allowing in
                allowing
                    .subdomain(domain: domain)
                ?? allowing
                    .path(domain: domain, url: on)
                ?? .allow
            }
    }
    
    private func subdomain(domain: Domain) -> Policy? {
        domain
            .prefix
            .last
            .flatMap { prefix in
                subdomain
                    .map(\.rawValue)
                    .contains(prefix)
                ? .block(prefix + "." + domain.minimal)
                : nil
            }
    }
    
    private func path(domain: Domain, url: URL) -> Policy? {
        for component in url
            .path
            .components(separatedBy: "/")
            .dropFirst()
                .prefix(2) {
            guard path.map(\.rawValue).contains(component) else { continue }
            return .block(domain.minimal + "/" + component)
        }
        return nil
    }
}
