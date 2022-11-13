import Foundation
import Archivable
import Domains

extension Cloud where Output == Archive {
    public func clearHistory() async {
        var model = await model
        guard !model.history.isEmpty else { return }
        model.history = []
        await update(model: model)
    }
    
    public func history(url: URL, title: String) async {
        guard let remote = url.remoteString else { return }
        let comparable = remote.comparable
        var model = await model
        
        model
            .history
            .remove {
                $0.url.comparable == comparable
            }
        
        model.history.insert(.init(url: remote, title: title), at: 0)
        
        await update(model: model)
    }
    
    public func add(bookmark: Bookmark) async {
        var model = await model
        model.bookmarks.append(bookmark)
        await update(model: model)
    }
    
    public func policy(request: URL, from url: URL) async -> Policy {
        var model = await model
        let response = request.policy
        let domain = url.absoluteString.domain
        switch response {
        case .allow:
            model.log.append(.init(domain: domain, url: .init(request.absoluteString.prefix(90))))
        case let .block(tracker):
            model.tracking = model
                .tracking
                .with(tracker: tracker, on: domain)
        default:
            break
        }
        await update(model: model)
        return response
    }
}
