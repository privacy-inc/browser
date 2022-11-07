import SwiftUI
import Combine
import Engine

final class Icon: ObservableObject {
    @Published private(set) var image: UIImage?
    private var publisher: CurrentValueSubject<UIImage?, Never>?
    private var sub: AnyCancellable?
    
    func load(favicon: Favicon, website: URL?) async {
        guard let website = website else { return }
        publisher = await favicon.publisher(for: website)
        sub = publisher?
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.image = $0
            }
    }
}
