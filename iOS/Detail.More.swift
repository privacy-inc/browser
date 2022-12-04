import SwiftUI
import Engine

extension Detail {
    struct More: View {
        @ObservedObject var session: Session
        @State private var url = ""
        @State private var title = ""
        @State private var domain = ""
        @State private var trackersPrevented = 0
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationStack {
                if case let .tab(id) = session.sidebar,
                   let webview = session.tabs[id]?.webview {
                    List {
                        Section("Trackers prevented") {
                            trackers
                        }
                        .headerProminence(.increased)
                    }
                    .listStyle(.grouped)
                    .safeAreaInset(edge: .top, spacing: 0) {
                        header
                    }
                    .onReceive(webview.publisher(for: \.title)) {
                        title = $0 ?? ""
                    }
                    .onReceive(webview.publisher(for: \.url)) {
                        url = $0?.absoluteString ?? ""
                        domain = url.domain
                    }
                }
            }
            .presentationDetents([.medium])
            .onReceive(session.cloud) {
                trackersPrevented = $0.tracking.count(domain: domain)
            }
        }
        
        private var trackers: some View {
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
        
        private var header: some View {
            ZStack(alignment: .topTrailing) {
                Color(.systemBackground)
                
                VStack(alignment: .leading, spacing: 0) {
                    if !title.isEmpty {
                        Text(title)
                            .font(.title3.weight(.medium))
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(4)
                            .textSelection(.enabled)
                            .padding(.bottom, 5)
                            .padding(.horizontal)
                    }
                    
                    Text(url)
                        .font(.init(UIFont.systemFont(
                            ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize,
                            weight: .regular,
                            width: .compressed)))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(3)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.top, 20)
                }
                .padding(.top, 34)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24, weight: .regular))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.secondary)
                        .contentShape(Rectangle())
                        .frame(width: 45, height: 45)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
