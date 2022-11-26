import SwiftUI

extension Detail {
    struct Top: View {
        let webview: Webview
        @State private var domain = ""
        @State private var secure = true
        @State private var encryption = false
        @State private var progress = AnimatablePair(Double(), Double())
        
        var body: some View {
            VStack(alignment: .trailing, spacing: 0) {
                Button {
                    encryption = true
                } label: {
                    HStack(spacing: 0) {
                        Text(domain)
                            .font(.system(size: 14, weight: .regular))
                        
                        Image(systemName: secure ? "lock.fill" : "exclamationmark.triangle.fill")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.secondary)
                            .frame(width: 20, height: 20)
                            .offset(x: 3)
                    }
                    .foregroundColor(secure ? .blue : .pink)
                }
                .popover(isPresented: $encryption) {
                    Encryption(domain: domain, secure: secure)
                }
                .onReceive(webview.publisher(for: \.url)) {
                    domain = $0?.absoluteString.domain ?? ""
                }
                .onReceive(webview.publisher(for: \.hasOnlySecureContent)) {
                    secure = $0
                }
                
                ZStack {
                    Rectangle()
                        .fill(Color(.secondarySystemBackground))
                    Progress(progress: progress)
                        .stroke(Color.accentColor, style: .init(lineWidth: 3, lineCap: .round))
                }
                .frame(width: 250, height: 2)
                .onReceive(webview.publisher(for: \.estimatedProgress).dropFirst()) { value in
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
        }
    }
}
