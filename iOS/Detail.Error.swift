import SwiftUI

extension Detail {
    struct Error: View {
        let session: Session
        let error: Weberror
        
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
            
            Button {
                guard let current = session.current else { return }
                
                if let webview = session.tabs[current].webview {
                    if webview.url == nil {
                        session.tabs[current].webview?.clean()
                        session.tabs[current].webview = nil
                    }
                }
                
                session.tabs[current].error = nil
            } label: {
                Text("Dismiss")
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(5)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.bottom, 30)
        }
    }
}
