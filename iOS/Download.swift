import Foundation
import WebKit

struct Download: Identifiable {
    var fail: Fail?
    private(set) weak var download: WKDownload!
    let id: UUID
    
    init(download: WKDownload) {
        id = .init()
        self.download = download
    }
}
