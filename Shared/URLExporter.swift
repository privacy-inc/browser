import Foundation
import UniformTypeIdentifiers
import CoreTransferable

struct URLExporter: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .url) { _ in
            Data()
        }
//        .suggestedFileName("ddsasa.data")
        
        
        DataRepresentation(exportedContentType: .webArchive) { _ in
//            $0.webview
//                .createWebArchiveData {
//                    guard case let .success(data) = $0 else { return }
//                    data.temporal(url.file("webarchive"))
//                }
            Data()
        }
    }
    
    private let webview: AbstractWebview
    private let url: URL
    private let type: UTType
    
    init(webview: AbstractWebview, url: URL, type: UTType) {
        self.webview = webview
        self.url = url
        self.type = type
    }
}
