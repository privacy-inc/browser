import SwiftUI
import Combine
import Engine
import Domains

extension Website {
    final class Info: ObservableObject {
        @Published private(set) var image: UIImage?
        @Published private(set) var title = ""
        @Published private(set) var domain = ""
        let error: Bool
        let badge: Bool
        private var subFavicon: AnyCancellable?
        private var subTitle: AnyCancellable?
        private var subURL: AnyCancellable?
        
        init(webview: Webview,
             favicon: Favicon) {
            error = false
            badge = false
            
            subTitle = webview
                .publisher(for: \.title)
                .sink { [weak self] in
                    if let title = $0 {
                        self?.title = title.isEmpty ? title : title + " "
                    } else {
                        self?.title = ""
                    }
                }
            
            subURL = webview
                .publisher(for: \.url)
                .sink { [weak self] in
                    if let url = $0 {
                        self?.domain = url.absoluteString.domain
                        self?.load(favicon: favicon, url: url)
                    } else {
                        self?.domain = ""
                        self?.image = nil
                    }
                }
        }
        
        init(favicon: Favicon,
             url: String,
             title: String,
             badge: Bool = false) {
            domain = url.domain
            error = false
            self.title = title.isEmpty ? title : title + " "
            self.badge = badge
            
            guard let url = URL(string: url) else { return }
            load(favicon: favicon, url: url)
        }
        
        init(error: Weberror) {
            title = error.message
            domain = error.url?.absoluteString.domain ?? ""
            badge = false
            self.error = true
        }
        
        private func load(favicon: Favicon, url: URL) {
            guard let iconIdentifier = url.iconIdentifier else { return }
            
            subFavicon = favicon
                .icons
                .compactMap {
                    guard let icon = $0[iconIdentifier] else {
                        Task {
                            await MainActor.run {
                                favicon.load(iconIdentifier: iconIdentifier)
                            }
                        }
                        return nil
                    }
                    return icon
                }
                .sink { [weak self] (image: UIImage) in
                    self?.image = image
                    self?.subFavicon?.cancel()
                }
        }
    }
}
