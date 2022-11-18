import SwiftUI
import Domains

extension Bar {
    struct Detail: View {
        @ObservedObject var session: Session
        
        var body: some View {
            NavigationStack {
                if case let .tab(id) = session.content,
                   let webview = session[tab: id]?.webview,
                   let url = webview.url?.absoluteString {

                    List {
                        let title = (webview.title?.isEmpty == false
                                     ? webview.title!
                                     : url.components(separatedBy: "://").last ?? url) + "\n"
                        let domain = url.domain
                        
                        Web(session: session, webview: webview, url: url, title: title, domain: domain)
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            Button("Reload") {
                                
                            }
                            Button("Bookmark") {
                                
                            }
                        }
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}
