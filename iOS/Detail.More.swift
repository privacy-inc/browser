import SwiftUI
import Engine

extension Detail {
    struct More: View {
        @ObservedObject var session: Session
        @State private var url = ""
        @State private var title = ""
        @State private var domain = ""
        @State private var tracking = Tracking()
        @State private var trackersPrevented = 0
        @State private var trackerItems = [Tracking.Item]()
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationStack {
                if case let .tab(id) = session.sidebar,
                   let webview = session.tabs[id]?.webview {
                    ScrollView {
                        trackers
                            .padding(.horizontal)
                            .padding(.vertical, 20)
                    }
                    .safeAreaInset(edge: .top, spacing: 0) {
                        header
                    }
                    .onReceive(webview.publisher(for: \.title)) {
                        title = $0 ?? ""
                    }
                    .onReceive(webview.publisher(for: \.url)) {
                        url = $0?.absoluteString ?? ""
                        domain = url.domain
                        update()
                    }
                }
            }
            .presentationDetents([.medium])
            .onReceive(session.cloud) {
                tracking = $0.tracking
                update()
            }
        }
        
        private var trackers: some View {
            Grid(verticalSpacing: 0) {
                GridRow {
                    Text("Trackers prevented")
                        .font(.title3.weight(.medium))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        .gridColumnAlignment(.leading)
                    HStack {
                        Divider()
                    }
                    Text(trackersPrevented, format: .number)
                        .font(.init(UIFont.systemFont(
                            ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize,
                            weight: .medium,
                            width: .condensed)).monospacedDigit())
                        .gridColumnAlignment(.trailing)
                }
                
                ForEach(trackerItems, id: \.tracker) { item in
                    Divider()
                    
                    GridRow {
                        Text(item.tracker)
                            .font(.callout)
                            .lineLimit(1)
                            .padding(.vertical, 10)
                        HStack {
                            Divider()
                        }
                        Text(item.count, format: .number)
                            .font(.init(UIFont.systemFont(
                                ofSize: UIFont.preferredFont(forTextStyle: .callout).pointSize,
                                weight: .regular,
                                width: .condensed)).monospacedDigit())
                            .padding(.leading, 20)
                    }
                }
            }
        }
        
        private var header: some View {
            ZStack(alignment: .topTrailing) {
                Color(.secondarySystemBackground)
                
                VStack(alignment: .leading, spacing: 0) {
                    if !title.isEmpty {
                        Text(title)
                            .font(.title3.weight(.medium))
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(4)
                            .textSelection(.enabled)
                            .padding(.bottom, 1)
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
        
        private func update() {
            trackersPrevented = tracking.count(domain: domain)
            trackerItems = tracking.items(for: domain)
        }
    }
}
