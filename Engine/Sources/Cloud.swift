import Foundation
import Archivable
import Domains

extension Cloud where Output == Archive {
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
    
    public func policy(request: URL, from url: URL) async -> Policy {
        let response = request.policy
        if case let .block(tracker) = response {
            var model = await model
            model.tracking = model
                .tracking
                .with(tracker: tracker, on: url.absoluteString.domain)
            
            await update(model: model)
        }
        return response
    }
}
