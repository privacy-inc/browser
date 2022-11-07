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
//    init(session: Session,
//         settings: Specs.Settings.Configuration,
//         dark: Bool) {
    
    init(cloud: Cloud<Archive>, favicon: Favicon) {
        
//        self.session = session
        let configuration = WKWebViewConfiguration()
        configuration.dataDetectorTypes = [.link]
        configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        configuration.allowsInlineMediaPlayback = true
        configuration.ignoresViewportScaleLimits = true
        
//        super.init(configuration: configuration, settings: settings, dark: dark)
        super.init(cloud: cloud, favicon: favicon, configuration: configuration)
        isOpaque = false
        scrollView.keyboardDismissMode = .none
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.clipsToBounds = false
//        scrollView.indicatorStyle = dark && settings.dark ? .white : .default
        
//        let background = UIColor
//            .secondarySystemBackground
//            .resolvedColor(with: .init(userInterfaceStyle: dark ? .dark : .light))
        
//        underPageBackgroundColor = background
//
//        if !dark {
//            publisher(for: \.themeColor)
//                .sink { [weak self] theme in
//                    guard
//                        dark,
//                        settings.dark,
//                        let color = theme
//                    else {
//                        self?.underPageBackgroundColor = background
//                        return
//                    }
//                    var alpha = CGFloat()
//                    color.getRed(nil, green: nil, blue: nil, alpha: &alpha)
//                    self?.underPageBackgroundColor = alpha == 0 ? background : color
//                }
//                .store(in: &subs)
//        }
    }
    
    deinit {
//        scrollView.delegate = nil
    }
    
//    func thumbnail() async {
//        let configuration = WKSnapshotConfiguration()
//        configuration.afterScreenUpdates = false
//        session.items[session.index(self)].thumbnail = (try? await takeSnapshot(configuration: configuration)) ?? .init()
//    }
    
//    @MainActor func resizeFont(size: CGFloat) async {
//        resignFirstResponder()
//        _ = try? await evaluateJavaScript(Script.text(size: size))
//    }
    
//    @MainActor func find(_ string: String, backwards: Bool) async {
//        scrollView.zoomScale = 1
//        becomeFirstResponder()
//        select(nil)
//        let config = WKFindConfiguration()
//        config.backwards = backwards
//
//        guard
//            let result = try? await find(string, configuration: config),
//            result.matchFound,
//            let evaluated = try? await evaluateJavaScript(Script.find.script),
//            let string = evaluated as? String
//        else { return }
//        var rect = NSCoder.cgRect(for: string)
//        rect.origin.x += scrollView.contentOffset.x
//        rect.origin.y += scrollView.contentOffset.y - 30
//        rect.size.height += 60
//        scrollView.scrollRectToVisible(rect, animated: true)
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
    
//    override func webView(_ webView: WKWebView, didFinish: WKNavigation!) {
//        super.webView(webView, didFinish: didFinish)
//        isOpaque = true
//    }
    
//    func webView(_: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
//        isOpaque = false
//        UIApplication.shared.hide()
//    }
    
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
