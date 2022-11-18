@preconcurrency import WebKit
import Combine
import Archivable
import Engine

class AbstractWebview: WKWebView, WKNavigationDelegate, WKUIDelegate, WKDownloadDelegate {
    final var subs = Set<AnyCancellable>()
    private static var rules: WKContentRuleList?
    private weak var cloud: Cloud<Archive>!
    private let history = PassthroughSubject<(url: URL, title: String), Never>()
    
    required init?(coder: NSCoder) { nil }
    init(cloud: Cloud<Archive>, favicon: Favicon, configuration: WKWebViewConfiguration) {
        self.cloud = cloud
        
        if let rules = Self.rules {
            configuration.userContentController.add(rules)
        } else {
            Task {
                if let rules = try? await WKContentRuleListStore
                    .default()
                    .compileContentRuleList(
                        forIdentifier: "rules",
                        encodedContentRuleList: Rule.list) {
                    Self.rules = rules
                    configuration.userContentController.add(rules)
                }
            }
        }
        
        configuration.suppressesIncrementalRendering = false
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false
        configuration.preferences.isFraudulentWebsiteWarningEnabled = false
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.websiteDataStore = .nonPersistent()
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        configuration.userContentController.addUserScript(.init(source: Script.js, injectionTime: .atDocumentEnd, forMainFrameOnly: false))
        configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")

        super.init(frame: .zero, configuration: configuration)
        navigationDelegate = self
        uiDelegate = self
        allowsBackForwardNavigationGestures = true
        
        history
            .debounce(for: .seconds(1), scheduler: DispatchQueue.global(qos: .utility))
            .sink { url, title in
                Task
                    .detached(priority: .utility) {
                        await cloud.history(url: url, title: title)
                    }
            }
            .store(in: &subs)
        
        publisher(for: \.url)
            .compactMap {
                $0
            }
            .removeDuplicates()
            .combineLatest(publisher(for: \.title)
                .compactMap {
                    $0
                }
                .removeDuplicates())
            .sink { [weak self] url, title in
                self?.history.send((url, title))
            }
            .store(in: &subs)
        
        publisher(for: \.url)
            .compactMap {
                $0
            }
            .removeDuplicates()
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] website in
                Task { [weak self] in
                    guard
                        await favicon.request(for: website),
                        let url = try? await self?.evaluateJavaScript("\(Script.favicon.rawValue)()") as? String
                    else { return }
                    await favicon.received(url: url, for: website)
                }
            }
            .store(in: &subs)
    }
    
    func clean() {
        stopLoading()
        uiDelegate = nil
        navigationDelegate = nil
        
        //        configuration.userContentController.removeScriptMessageHandler(forName: Script.location.method)
    }
    
//    func deeplink(url: URL) {
//
//    }
//
    func error(_ error: Weberror) {
        fatalError()
    }
    
    nonisolated func webView(_: WKWebView, navigationAction: WKNavigationAction, didBecome: WKDownload) {
        didBecome.delegate = self
    }
    
    nonisolated func webView(_: WKWebView, navigationResponse: WKNavigationResponse, didBecome: WKDownload) {
        didBecome.delegate = self
    }
    
    func download(_ download: WKDownload, decideDestinationUsing: URLResponse, suggestedFilename: String) async -> URL? {
        nil
    }
    
    nonisolated func download(_: WKDownload, didFailWithError error: Error, resumeData: Data?) {
//        Task {
//            await UNUserNotificationCenter.send(message: error.localizedDescription)
//        }
    }
    
    nonisolated func downloadDidFinish(_: WKDownload) {
//        Task {
//            await UNUserNotificationCenter.send(message: "Download finished!")
//        }
    }
    
//    final func privacy(url: URL) {
//        message(info: .init(url: url, title: "Privacy deeplink", icon: "eyeglasses"))
//    }
    
    nonisolated final func webView(_: WKWebView, respondTo: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        (.useCredential, respondTo.protectionSpace.serverTrust.map(URLCredential.init(trust:)))
    }
    
    nonisolated final func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
        guard
            (withError as NSError).code != NSURLErrorCancelled,
            (withError as NSError).code != Weberror.frameLoadInterrupted
        else { return }

        Task {
            await error(withError)
        }
    }
    
    final func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, preferences: WKWebpagePreferences) async -> (WKNavigationActionPolicy, WKWebpagePreferences) {
        
        guard
            !(decidePolicyFor.navigationType == .linkActivated && decidePolicyFor.sourceFrame.webView == nil)
        else { return (.cancel, preferences) }

        switch await cloud.policy(request: decidePolicyFor.request.url!, from: url!) {
        case .allow:
            if decidePolicyFor.shouldPerformDownload {
                return (.download, preferences)
            } else {
                print("allowed: \(decidePolicyFor.request.url!)")
                preferences.allowsContentJavaScript = true
                return (.allow, preferences)
            }
        case .ignore:
            decidePolicyFor
                .targetFrame
                .map(\.isMainFrame)
                .map {
                    guard $0 else { return }
                    error(url: decidePolicyFor.request.url, message: "There was an error loading this website.")
                }
        case .block:
            decidePolicyFor
                .targetFrame
                .map(\.isMainFrame)
                .map {
                    guard $0 else { return }
                    error(url: decidePolicyFor.request.url, message: "Website blocked for privacy concerns.")
                }
        case .deeplink:
//            message(info: .init(url: decidePolicyFor.request.url!, title: "Deeplink opened", icon: "paperplane.circle.fill"))
//            deeplink(url: decidePolicyFor.request.url!)
            break
        case .app:
//            privacy(url: decidePolicyFor.request.url!)
            break
        }
        return (.cancel, preferences)
    }
    
    final func webView(_: WKWebView, decidePolicyFor: WKNavigationAction) async -> WKNavigationActionPolicy {
        decidePolicyFor.shouldPerformDownload ? .download : .allow
    }
    
    final func webView(_: WKWebView, decidePolicyFor: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        guard
            let response = decidePolicyFor.response as? HTTPURLResponse,
            let contentType = response.value(forHTTPHeaderField: "Content-Type"),
            contentType.range(of: "attachment", options: .caseInsensitive) != nil
        else {
            return decidePolicyFor.canShowMIMEType ? .allow : .download
        }
        return .download
    }
    
//    final func download(_: WKDownload, decidedPolicyForHTTPRedirection: HTTPURLResponse, newRequest: URLRequest) async -> WKDownload.RedirectPolicy {
//        switch await cloud.policy(request: newRequest.url!, from: decidedPolicyForHTTPRedirection.url ?? url!) {
//        case .allow:
//            return .allow
//        default:
//            return .cancel
//        }
//    }
    
//    final func download(_: WKDownload, respondTo: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
//        settings.http
//        ? (.useCredential, respondTo.protectionSpace.serverTrust.map(URLCredential.init(trust:)))
//        : (.performDefaultHandling, nil)
//    }
    
//    @MainActor final class func clear() async {
//        URLCache.shared.removeAllCachedResponses()
//        HTTPCookieStorage.shared.removeCookies(since: .distantPast)
//        await clear(store: .default())
//        await clear(store: .nonPersistent())
//    }
    
//    @MainActor private class func clear(store: WKWebsiteDataStore) async {
//        for record in await store.dataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {
//            await store.removeData(ofTypes: record.dataTypes, for: [record])
//        }
//        await store.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: .distantPast)
//    }
    
    private func error(_ error: Error) {
        self.error(url: (error as? URLError)
                .flatMap(\.failingURL)
                ?? url
                ?? {
                    $0?["NSErrorFailingURLKey"] as? URL
                } (error._userInfo as? [String : Any]),
              message: error.localizedDescription)
    }
    
    private func error(url: URL?, message: String) {
        error(.init(url: url, message: message))
        guard let url = url else { return }
        history.send((url, message))
    }
}
