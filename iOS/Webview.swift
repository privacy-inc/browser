@preconcurrency import WebKit
import Combine
import Engine

final class Webview: AbstractWebview {
    private weak var session: Session!
    let downloads = PassthroughSubject<Void, Never>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        self.session = session
        
        let configuration = WKWebViewConfiguration()
        configuration.dataDetectorTypes = [.link]
        configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        configuration.allowsInlineMediaPlayback = true
        configuration.ignoresViewportScaleLimits = true
        
        super.init(cloud: session.cloud, favicon: session.favicon, configuration: configuration)
        isOpaque = true
        scrollView.keyboardDismissMode = .none
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.clipsToBounds = true
        
        publisher(for: \.url)
            .combineLatest(publisher(for: \.isLoading),
                           UserDefaults
                .standard
                .publisher(for: \.font))
            .debounce(for: .seconds(0.05), scheduler: DispatchQueue.main)
            .sink { [weak self] result in
                Task { [weak self] in
                    await self?.update(font: result.2)
                }
            }
            .store(in: &subs)
    }
    
    override func clean() {
        super.clean()
        scrollView.delegate = nil
    }
    
    override func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome: WKDownload) {
        super.webView(webView, navigationAction: navigationAction, didBecome: didBecome)
        
        Task {
            await add(download: didBecome)
        }
    }
    
    override func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome: WKDownload) {
        super.webView(webView, navigationResponse: navigationResponse, didBecome: didBecome)
        
        Task {
            await add(download: didBecome)
        }
    }
    
    override func download(_ download: WKDownload, decideDestinationUsing: URLResponse, suggestedFilename: String) async -> URL? {
        let url = URL.temporal(suggestedFilename)
        
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
    
        return url
    }
    
    override func download(_ download: WKDownload, didFailWithError: Error, resumeData: Data?) {
        super.download(download, didFailWithError: didFailWithError, resumeData: resumeData)
        let fail = Download.Fail(error: didFailWithError.localizedDescription, data: resumeData ?? .init())
        
        Task {
            await failed(downloading: download, with: fail)
        }
    }
    
    override func downloadDidFinish(_ download: WKDownload) {
        super.downloadDidFinish(download)
        
        Task {
            await MainActor.run {
                session.review.send()
                downloads.send()
            }
        }
    }
    
    override func deeplink(url: URL) {
        UIApplication.shared.open(url)
    }
    
    override func error(_ error: Weberror) {
        guard let id = session.tab else { return }
        session.tabs[id]?.error = error
    }
    
    func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
        UIApplication.shared.hide()
    }
    
    func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if action.sourceFrame.isMainFrame,
           (action.targetFrame == nil && action.navigationType == .other)
            || action.navigationType == .linkActivated {
            if let url = action.request.url {
                load(.init(url: url))
            }
        }
        return nil
    }
    
    func webView(_: WKWebView, contextMenuConfigurationFor: WKContextMenuElementInfo) async -> UIContextMenuConfiguration? {
        .init(actionProvider: { elements in
            var elements = elements
                .filter {
                    guard let name = ($0 as? UIAction)?.identifier.rawValue else { return true }
                    switch name {
                    case "WKElementActionTypeOpen", "WKElementActionTypeAddToReadingList":
                        return false
                    default:
                        return true
                    }
                }
            
            if let url = contextMenuConfigurationFor.linkURL {
                elements.insert(contentsOf: [
                    .init(title: "Open",
                             image: .init(systemName: "link"))
                    { [weak self] _ in
                        self?.load(.init(url: url))
                    },
                    .init(title: "Open in new tab",
                          image: .init(systemName: "plus.square"))
                    { [weak self] _ in
                        self?.session.open(url: url)
                    },
                    .init(title: "Add to reading list",
                          image: .init(systemName: "eyeglasses"))
                    { [weak self] _ in
                        Task { [weak self] in
                            await self?.session.cloud.add(read: .init(url: url.absoluteString, title: ""))
                        }
                    }
                ] as [UIAction], at: 0)
            }
            return .init(children: elements)
        })
    }
    
    func webView(_: WKWebView, contextMenuForElement: WKContextMenuElementInfo, willCommitWithAnimator: UIContextMenuInteractionCommitAnimating) {
        if let url = contextMenuForElement.linkURL {
            load(.init(url: url))
        } else if let data = (willCommitWithAnimator.previewViewController?.view.subviews.first as? UIImageView)?.image?.pngData() {
            load(.init(url: data.temporal("image.png")))
        }
    }
    
    private func update(font: Int) async {
        var current = 100
        
        if let string = try? await evaluateJavaScript("document.body.style.webkitTextSizeAdjust") as? String,
           let read = Int(string.replacingOccurrences(of: "%", with: "")) {
            current = read
        }
        
        guard current != font else { return }
        
        evaluateJavaScript("document.body.style.webkitTextSizeAdjust='\(font)%'",
                           completionHandler: nil)
    }
    
    @MainActor private func add(download: WKDownload) {
        session.downloads.insert(.init(webview: self, item: download), at: 0)
        downloads.send()
    }
    
    @MainActor private func failed(downloading: WKDownload, with: Download.Fail) {
        guard let index = session.downloads.firstIndex(where: { $0.item == downloading }) else { return }
        session.downloads[index].fail = with
        downloads.send()
    }
}
