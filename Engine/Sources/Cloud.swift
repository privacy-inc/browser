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
        guard !model.bookmarks.contains(where: { $0.url == bookmark.url }) else { return }
        model.bookmarks.append(bookmark)
        await update(model: model)
    }
    
    public func delete(bookmark url: String) async {
        var model = await model
        model
            .bookmarks
            .remove {
                $0.url == url
            }
        await update(model: model)
    }
    
    public func update(bookmark: Bookmark, for url: String) async {
        var model = await model
        guard let index = model.bookmarks.firstIndex(where: { $0.url == url }) else { return }
        model.bookmarks.remove(at: index)
        model.bookmarks.insert(bookmark, at: index)
        await update(model: model)
    }
    
    public func move(bookmark index: IndexSet, destination: Int) async {
        var model = await model
        model.bookmarks = model.bookmarks.moving(from: index.first!, to: destination)
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
