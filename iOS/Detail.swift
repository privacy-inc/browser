import SwiftUI

struct Detail: View {
    @ObservedObject var session: Session
    let id: UUID
    @State private var progress = AnimatablePair(Double(), Double())
    
    var body: some View {
        VStack(spacing: 0) {
            if let tab = session[tab: id], let webview = tab.webview {
                if let error = tab.error {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 50, weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.orange)
                        .padding(.vertical, 40)
                    
                    VStack(alignment: .leading) {
                        Text(error.message)
                            .font(.body.weight(.medium))
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        if let url = error.url {
                            Text(url.absoluteString.prefix(150))
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .frame(maxWidth: 400, alignment: .leading)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    
                } else {
                    ZStack {
                        Rectangle()
                            .fill(Color(.secondarySystemBackground))
                            .frame(height: 3)
                        Progress(progress: progress)
                            .stroke(Color.accentColor, style: .init(lineWidth: 4, lineCap: .round))
                    }
                    .frame(height: 3)
                    
                    Browser(webview: webview)
                        .onReceive(webview.publisher(for: \.estimatedProgress)) { value in
                            guard value != 1 || progress.second != 0 else { return }
                            
                            progress.first = 0
                            withAnimation(.easeInOut(duration: 0.5)) {
                                progress.second = value
                            }
                            
                            if value == 1 {
                                DispatchQueue
                                    .main
                                    .asyncAfter(deadline: .now() + 0.7) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            progress = .init(1, 1)
                                        }
                                    }
                            }
                        }
                }
            } else {
                Button {
                    session.field.becomeFirstResponder()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .foregroundColor(.secondary)
                        .contentShape(Rectangle())
                        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
                }
                .ignoresSafeArea(.all)
                .task {
                    guard session.tabs.count > 1 else { return }
                    session.field.becomeFirstResponder()
                }
            }
            
            Divider()
            
            Search(session: session)
                .frame(height: 0)
        }
        .id(id)
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if !session.typing {
                Bar(session: session, error: session[tab: id]?.error != nil)
            }
        }
    }
}
