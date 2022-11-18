import SwiftUI
import Domains

extension Bar {
    struct Detail: View {
        @ObservedObject var session: Session
        @State private var secure = true
        
        var body: some View {
            NavigationStack {
                List {
                    if case let .tab(id) = session.content,
                       let webview = session[tab: id]?.webview,
                       let url = webview.url?.absoluteString {

                        let title = (webview.title?.isEmpty == false
                                     ? webview.title!
                                     : url.components(separatedBy: "://").last ?? url) + "\n"
                        
                        Section {
                            Text("\(title)\(Text(url).foregroundColor(.secondary).font(.callout.weight(.regular)))")
                                .font(.title3.weight(.medium))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.vertical, 3)
                        } header: {
                            HStack {
                                Text(url.domain)
                                    .font(.callout.weight(.medium))
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Image(systemName: secure ? "lock.fill" : "exclamationmark.triangle.fill")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(secure ? .blue : .pink)
                                    .font(.footnote)
                            }
                            .padding(.top)
                        }
                        .headerProminence(.increased)
                        .onReceive(webview.publisher(for: \.hasOnlySecureContent)) {
                            secure = $0
                        }
                    }
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
            .presentationDetents([.medium, .large])
        }
    }
}
