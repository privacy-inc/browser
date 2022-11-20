import SwiftUI
import Domains

extension Bar {
    struct Web: View {
        @ObservedObject var session: Session
        let webview: Webview
        @State private var url = ""
        @State private var title = ""
        @State private var domain = ""
        @State private var secure = true
        @State private var trackersPrevented = 0
        
        var body: some View {
            Section {
                Text("\(title)\(Text(url).foregroundColor(.secondary).font(.footnote.weight(.regular)))")
                    .font(.body.weight(.medium))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 3)
            } header: {
                HStack {
                    Text(domain)
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: secure ? "lock.fill" : "exclamationmark.triangle.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(secure ? .blue : .pink)
                        .font(.footnote)
                }
                .padding(.top)
            }
            .headerProminence(.increased)
            .listSectionSeparator(.hidden)
            .onReceive(webview.publisher(for: \.title)) {
                title = ($0?.isEmpty == false
                         ? $0!
                         : url.components(separatedBy: "://").last ?? url) + "\n"
            }
            .onReceive(webview.publisher(for: \.url)) {
                url = $0?.absoluteString ?? ""
                domain = url.domain
            }
            .onReceive(webview.publisher(for: \.hasOnlySecureContent)) {
                secure = $0
            }
            
            Section {
                NavigationLink(destination: Circle()) {
                    HStack {
                        Text(trackersPrevented == 1 ? "Tracker prevented" : "Trackers prevented")
                            .font(.callout.weight(.regular))
                        
                        Spacer()
                        
                        Text("\(trackersPrevented.formatted())")
                            .font(.init(UIFont.systemFont(ofSize: 20, weight: .bold, width: .condensed)).monospacedDigit())
                            .foregroundColor(.accentColor)
                    }
                }
                .disabled(trackersPrevented == 0)
            }
            .listSectionSeparator(.hidden)
            .onReceive(session.cloud) {
                trackersPrevented = $0.tracking.count(domain: domain)
            }
            
            Section("Media") {
                
            }
            .textCase(.none)
            .listSectionSeparator(.hidden)
        }
    }
}
