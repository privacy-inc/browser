import SwiftUI

extension Detail {
    struct Tab: View {
        let session: Session
        let webview: Webview
        @State private var downloads = false
        @State private var progress = AnimatablePair(Double(), Double())
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 3)
                Progress(progress: progress)
                    .stroke(Color.accentColor, style: .init(lineWidth: 4, lineCap: .round))
            }
            .frame(height: 3)
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
            
            Browser(webview: webview)
                .onReceive(webview.downloads) {
                    downloads = true
                }
                .sheet(isPresented: $downloads) {
                    NavigationStack {
                        Downloads(session: session)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        dismiss()
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 18, weight: .medium))
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(.secondary)
                                            .contentShape(Rectangle())
                                            .frame(width: 35, height: 40)
                                    }
                                }
                            }
                    }
                    .presentationDetents([.medium])
                }
        }
    }
}
