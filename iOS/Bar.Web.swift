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
                Text("\(title)\(Text(url).foregroundColor(.secondary).font(.callout.weight(.regular)))")
                    .font(.title3.weight(.medium))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 3)
            } header: {
                HStack {
                    Text(domain)
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
                        
                        ZStack {
                            Capsule()
                                .fill(Color.accentColor)
                            Text("\(trackersPrevented.formatted())")
                                .font(.init(UIFont.systemFont(ofSize: 16, weight: .semibold, width: .condensed)).monospacedDigit())
                                .foregroundColor(.white)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 10)
                        }
                        .fixedSize()
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
