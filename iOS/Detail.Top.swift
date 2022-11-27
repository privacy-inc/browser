import SwiftUI

extension Detail {
    struct Top: View {
        let webview: Webview
        @State private var domain = ""
        @State private var loading = true
        @State private var secure = true
        @State private var encryption = false
        @State private var progress = Double()
        
        var body: some View {
            
            Button {
                UIApplication.shared.hide()
                if loading {
                    webview.stopLoading()
                } else {
                    webview.reload()
                }
            } label: {
                ZStack {
                    Circle()
                        .stroke(Color.primary.opacity(0.1), style: .init(lineWidth: 2, lineCap: .round))
                        .frame(width: 26, height: 26)
                    Circle()
                        .trim(to: progress)
                        .stroke(Color.accentColor, style: .init(lineWidth: 2, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(), value: progress)
                        .frame(width: 26, height: 26)
                    Image(systemName: loading ? "pause" : "arrow.clockwise")
                        .font(.system(size: 11, weight: .bold))
                }
                .contentShape(Rectangle())
                .frame(width: 40, height: 40)
            }
            .onReceive(webview.publisher(for: \.url)) {
                domain = $0?.absoluteString.domain ?? ""
            }
            .onReceive(webview.publisher(for: \.hasOnlySecureContent)) {
                secure = $0
            }
            .onReceive(webview.publisher(for: \.estimatedProgress)) {
                progress = $0
            }
            .onReceive(webview.publisher(for: \.isLoading)) {
                loading = $0
            }
            
//            VStack(alignment: .trailing, spacing: 0) {
//                Button {
//                    encryption = true
//                } label: {
//                    ZStack(alignment: .leading) {
//                        RoundedRectangle(cornerRadius: 6)
//                            .fill(Color(.secondarySystemBackground))
//                        RoundedRectangle(cornerRadius: 6)
//                            .fill(secure ? Color.blue : .pink)
//                            .opacity(0.1)
//                            .frame(width: 170 * progress)
//                        HStack(spacing: 0) {
//                            Spacer()
//                            Text(domain)
//                                .font(.system(size: 12, weight: .regular))
//                                .lineLimit(1)
//                                .frame(maxWidth: 130, alignment: .trailing)
//
//                            Image(systemName: secure ? "lock.fill" : "exclamationmark.triangle.fill")
//                                .font(.system(size: 8, weight: .medium))
//                                .frame(width: 22, height: 26)
//                                .padding(.trailing, 4)
//                        }
//                        .foregroundColor(.primary)
//                    }
//                    .frame(width: 170, height: 2)
//                }
//                .popover(isPresented: $encryption) {
//                    Encryption(domain: domain, secure: secure)
//                }
//
//            }
        }
    }
}
