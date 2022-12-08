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
                    .background(.blue)
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
            .foregroundColor(.white)
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
                        .font(.title3.weight(.semibold))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        .gridColumnAlignment(.leading)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 1)
                    Text(trackersPrevented, format: .number)
                        .font(.init(UIFont.systemFont(
                            ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize,
                            weight: .semibold,
                            width: .condensed)).monospacedDigit())
                        .padding(.leading, 20)
                        .gridColumnAlignment(.trailing)
                }
                
                ForEach(trackerItems, id: \.tracker) { item in
                    Rectangle()
                        .fill(Color(white: 1, opacity: 0.5))
                        .frame(height: 1)
                    
                    GridRow {
                        Text(item.tracker)
                            .font(.callout.weight(.medium))
                            .lineLimit(1)
                            .padding(.vertical, 10)
                        Rectangle()
                            .fill(Color(white: 1, opacity: 0.5))
                            .frame(width: 1)
                        Text(item.count, format: .number)
                            .font(.init(UIFont.systemFont(
                                ofSize: UIFont.preferredFont(forTextStyle: .callout).pointSize,
                                weight: .medium,
                                width: .condensed)).monospacedDigit())
                    }
                }
            }
        }
        
        private var header: some View {
            ZStack(alignment: .topTrailing) {
                Color.blue
                
                VStack(alignment: .leading, spacing: 0) {
                    if !title.isEmpty {
                        Text(title)
                            .font(.title2.weight(.semibold))
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(4)
                            .textSelection(.enabled)
                            .padding(.bottom, 2)
                            .padding(.leading)
                            .padding(.trailing, 45)
                    }
                    
                    Text(url)
                        .font(.init(UIFont.systemFont(
                            ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize,
                            weight: .regular,
                            width: .compressed)))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(3)
                        .textSelection(.enabled)
                        .padding(.horizontal)
                    
                    Rectangle()
                        .fill(Color(white: 1, opacity: 0.5))
                        .frame(height: 1)
                        .edgesIgnoringSafeArea(.horizontal)
                        .padding(.top, 20)
                }
                .padding(.top)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24, weight: .regular))
                        .symbolRenderingMode(.hierarchical)
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
