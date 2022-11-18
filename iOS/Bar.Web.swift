import SwiftUI

extension Bar {
    struct Web: View {
        @ObservedObject var session: Session
        let webview: Webview
        let url: String
        let title: String
        let domain: String
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
            .onReceive(webview.publisher(for: \.hasOnlySecureContent)) {
                secure = $0
            }
            
            Section {
                NavigationLink(destination: Circle()) {
                    Text("\(trackersPrevented.formatted()) \(Text("trackers prevented").font(.callout.weight(.regular)).foregroundColor(.secondary))")
                        .font(.init(UIFont.systemFont(ofSize: 26, weight: .medium, width: .condensed)).monospacedDigit())
                }
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
