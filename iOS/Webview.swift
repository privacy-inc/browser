import WebKit
import Archivable
import Engine
//import Specs

final class Webview: AbstractWebview {
//    private let session: Session
    
//    @MainActor var fontSize: CGFloat {
//        get async {
//            guard
//                let string = try? await evaluateJavaScript(Script.text.script) as? String,
//                let int = Int(string.replacingOccurrences(of: "%", with: ""))
//            else {
//                return 1
//            }
//            return .init(int) / 100
//        }
//    }
//
    required init?(coder: NSCoder) { nil }
    init(cloud: Cloud<Archive>, favicon: Favicon) {
        let configuration = WKWebViewConfiguration()
        configuration.dataDetectorTypes = [.link]
        configuration.defaultWebpagePreferences.preferredContentMode = .recommended
        configuration.allowsInlineMediaPlayback = true
        configuration.ignoresViewportScaleLimits = true
        
        super.init(cloud: cloud, favicon: favicon, configuration: configuration)
        isOpaque = true
        scrollView.keyboardDismissMode = .none
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.clipsToBounds = true
    }
    
    deinit {
        Task {
            await MainActor
                .run {
                    scrollView.delegate = nil
                }
        }
    }
    
//    @MainActor func resizeFont(size: CGFloat) async {
//        resignFirstResponder()
//        _ = try? await evaluateJavaScript(Script.text(size: size))
//    }
    
//    override func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome: WKDownload) {
//        super.webView(webView, navigationAction: navigationAction, didBecome: didBecome)
//        session.downloads.append((download: didBecome, status: .on))
//    }
    
//    override func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome: WKDownload) {
//        super.webView(webView, navigationResponse: navigationResponse, didBecome: didBecome)
//        session.downloads.append((download: didBecome, status: .on))
//    }
    
//    override func download(_ download: WKDownload, decideDestinationUsing: URLResponse, suggestedFilename: String) async -> URL? {
//        FileManager.default.fileExists(atPath: URL.temporal(suggestedFilename).path)
//        ? URL.temporal(UUID().uuidString + "_" + suggestedFilename)
//        : URL.temporal(suggestedFilename)
//    }
    
//    override func download(_ download: WKDownload, didFailWithError: Error, resumeData: Data?) {
//        super.download(download, didFailWithError: didFailWithError, resumeData: resumeData)
//        session
//            .downloads
//            .remove {
//                $0.download == download
//            }
//
//        if let data = resumeData {
//            session.downloads.append((download: download, status: .cancelled(data)))
//        }
//    }
    
//    override func downloadDidFinish(_ download: WKDownload) {
//        super.downloadDidFinish(download)
//        if Defaults.rate {
//            UIApplication.shared.review()
//        }
//    }
    
//    override func deeplink(url: URL) {
//        UIApplication.shared.open(url)
//    }
    
//    override func message(info: Info) {
//        let index = session.index(self)
//        session.items[index].info = info
//        session.items[index].flow = .message
//        session.objectWillChange.send()
//    }
    
    func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
        UIApplication.shared.hide()
    }
    
//    func webView(_: WKWebView, createWebViewWith: WKWebViewConfiguration, for action: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//        if action.sourceFrame.isMainFrame,
//           (action.targetFrame == nil && action.navigationType == .other) || action.navigationType == .linkActivated {
//            _ = action
//                .request
//                .url
//                .map(load)
//        }
//        return nil
//    }
    
//    func webView(_: WKWebView, contextMenuConfigurationFor: WKContextMenuElementInfo) async -> UIContextMenuConfiguration? {
//        .init(identifier: nil, previewProvider: nil) { elements in
//            var elements = elements
//                .filter {
//                    guard let name = ($0 as? UIAction)?.identifier.rawValue else { return true }
//                    return !name.hasSuffix("Open")
//                }
//
//            if let url = contextMenuConfigurationFor .linkURL {
//                elements
//                    .insert(UIAction(title: NSLocalizedString("Open", comment: ""),
//                                     image: UIImage(systemName: "paperplane"))
//                            { [weak self] _ in
//                        self?.load(url: url)
//                    }, at: 0)
//
//                elements
//                    .insert(UIAction(title: NSLocalizedString("New Tab", comment: ""),
//                                     image: UIImage(systemName: "plus.square"))
//                            { [weak self] _ in
//                        Task { [weak self] in
//                            await self?.session.open(url: url, change: false)
//                        }
//                    }, at: 1)
//
//                elements
//                    .insert(UIAction(title: NSLocalizedString("Change New Tab", comment: ""),
//                                     image: UIImage(systemName: "plus.square.on.square"))
//                            { [weak self] _ in
//                        Task { [weak self] in
//                            await self?.thumbnail()
//                            await self?.session.open(url: url, change: true)
//                        }
//                    }, at: 2)
//            }
//            return .init(title: "", children: elements)
//        }
//    }
    
//    func webView(_: WKWebView, contextMenuForElement: WKContextMenuElementInfo, willCommitWithAnimator: UIContextMenuInteractionCommitAnimating) {
//        if let url = contextMenuForElement.linkURL {
//            load(url: url)
//        } else if let data = (willCommitWithAnimator.previewViewController?.view.subviews.first as? UIImageView)?.image?.pngData() {
//            load(url: data.temporal("image.png"))
//        }
//    }
}
