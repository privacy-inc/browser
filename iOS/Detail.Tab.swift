import SwiftUI

extension Detail {
    struct Tab: View {
        let webview: Webview
        @State private var progress = AnimatablePair(Double(), Double())
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 3)
                Progress(progress: progress)
                    .stroke(Color.accentColor, style: .init(lineWidth: 4, lineCap: .round))
            }
            .frame(height: 3)
            
            Browser(webview: webview)
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
