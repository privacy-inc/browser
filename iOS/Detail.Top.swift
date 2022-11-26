import SwiftUI

extension Detail {
    struct Top: View {
        let webview: Webview
        @State private var domain = ""
        @State private var secure = true
        @State private var encryption = false
        @State private var progress = Double()
        
        var body: some View {
            VStack(alignment: .trailing, spacing: 0) {
                Button {
                    encryption = true
                } label: {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(.secondarySystemBackground))
                        RoundedRectangle(cornerRadius: 6)
                            .fill(secure ? Color.blue : .pink)
                            .opacity(0.1)
                            .frame(width: 200 * progress)
                        HStack(spacing: 0) {
                            Spacer()
                            Text(domain)
                                .font(.system(size: 14, weight: .regular))
                                .lineLimit(1)
                                .frame(maxWidth: 160, alignment: .trailing)
                            
                            Image(systemName: secure ? "lock.fill" : "exclamationmark.triangle.fill")
                                .font(.system(size: 10, weight: .medium))
                                .frame(width: 26, height: 32)
                                .padding(.trailing, 4)
                        }
                        .foregroundColor(.primary)
                    }
                    .frame(width: 200, height: 2)
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
                .onReceive(webview.publisher(for: \.estimatedProgress).dropFirst()) {
                    progress = $0
                }
            }
        }
    }
}
