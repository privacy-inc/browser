import SwiftUI

extension Detail {
    struct Error: View {
        let session: Session
        let error: Weberror
        @State private var animate = false
        
        var body: some View {
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
            
            if animate {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.accentColor)
                    .padding(.bottom, 60)
            } else {
                Button {
                    animate = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        guard case let .tab(id) = session.sidebar else { return }
                        
                        if let url = error.url {
                            session.tabs[id]?.webview?.load(.init(url: url))
                        }
                        
                        session.tabs[id]?.error = nil
                    }
                } label: {
                    Text("Try again")
                        .font(.body.weight(.medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 15)
                
                Button {
                    guard case let .tab(id) = session.sidebar else { return }
                    
                    if let webview = session.tabs[id]?.webview {
                        if webview.url == nil {
                            session.tabs[id]?.webview?.clean()
                            session.tabs[id]?.webview = nil
                        }
                    }
                    
                    session.tabs[id]?.error = nil
                } label: {
                    Text("Dismiss")
                        .font(.body.weight(.medium))
                        .foregroundStyle(.secondary)
                        .padding(5)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(.bottom, 35)
            }
        }
    }
}
