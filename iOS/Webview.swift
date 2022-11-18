import WebKit
import Engine
//import Specs

final class Webview: AbstractWebview {
    private weak var session: Session!
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
    init(session: Session) {
        self.session = session
        
        let configuration = WKWebViewConfiguration()
        configuration.dataDetectorTypes = [.link]
        configuration.defaultWebpagePreferences.preferredContentMode = .recommended
        configuration.allowsInlineMediaPlayback = true
        configuration.ignoresViewportScaleLimits = true
        
        super.init(cloud: session.cloud, favicon: session.favicon, configuration: configuration)
        isOpaque = true
        scrollView.keyboardDismissMode = .none
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.clipsToBounds = true
    }
    
    override func clean() {
        super.clean()
        scrollView.delegate = nil
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
    
    override func error(_ error: Weberror) {
        guard let index = session.current else { return }
        session.tabs[index].error = error
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
}
