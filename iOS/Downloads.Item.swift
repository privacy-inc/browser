import SwiftUI

extension Downloads {
    struct Item: View {
        @Binding var download: Download
        @State private var progress = Double()
        @State private var title = ""
        @State private var completedWeight = Int64()
        @State private var totalWeight = Int64()
        @State private var finished = false
        @State private var url: URL?
        
        var body: some View {
            HStack {
                if finished {
                    if let url {
                        VStack {
                            Text(url.lastPathComponent)
                                .font(.body.weight(.medium))
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                
                            Text(totalWeight.formatted(.byteCount(style: .file).attributed)
                                .numeric(font: .init(UIFont.systemFont(ofSize: 16, weight: .medium, width: .condensed)).monospacedDigit()))
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        }
                        .padding(.vertical, 8)
                        
                        Divider()
                        
                        ShareLink(item: url) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 22, weight: .semibold))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.blue)
                                .contentShape(Rectangle())
                                .frame(width: 50, height: 50)
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    VStack(alignment: .leading) {
                        if let fail = download.fail {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.yellow)
                                Text(fail.error)
                                    .font(.footnote.weight(.regular))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                            }
                            .padding(.bottom, 5)
                        }
                        
                        Text(title)
                            .font(.body.weight(.medium))
                            .fixedSize(horizontal: false, vertical: true)
                        Text(weight)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
                        ProgressView(value: progress)
                            .tint(.blue)
                    }
                    .padding(.vertical, 8)
                    
                    Divider()
                    
                    if download.fail == nil {
                        pause
                    } else {
                        retry
                    }
                }
            }
            .onReceive(download.item.progress.publisher(for: \.fileURL)) {
                url = $0
            }
            .onReceive(download.item.progress.publisher(for: \.isFinished)) {
                finished = $0
            }
            .onReceive(download.item.progress.publisher(for: \.fractionCompleted)) {
                progress = $0
            }
            .onReceive(download.item.progress.publisher(for: \.localizedDescription)) {
                title = $0
            }
            .onReceive(download.item.progress.publisher(for: \.totalUnitCount)) {
                totalWeight = $0
            }
            .onReceive(download.item.progress.publisher(for: \.completedUnitCount)) {
                completedWeight = $0
            }
        }
        
        private var retry: some View {
            Button {
                guard let fail = download.fail else { return }
                Task {
                    await resume(data: fail.data)
                }
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.system(size: 24, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.blue)
                    .contentShape(Rectangle())
                    .frame(width: 50, height: 50)
            }
            .buttonStyle(.plain)
        }
        
        private var pause: some View {
            Button {
                Task {
                    await cancel()
                }
            } label: {
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 24, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.yellow)
                    .contentShape(Rectangle())
                    .frame(width: 50, height: 50)
            }
            .buttonStyle(.plain)
        }
        
        private var weight: AttributedString {
            (completedWeight.formatted(.byteCount(style: .file).attributed)
            + .init(" of ")
            + totalWeight.formatted(.byteCount(style: .file).attributed))
            .numeric(font: .init(UIFont.systemFont(ofSize: 16, weight: .medium, width: .condensed)).monospacedDigit())
        }
        
        @MainActor private func resume(data: Data) async {
            let resumed = await download.webview.resumeDownload(fromResumeData: data)
            resumed.delegate = download.webview
            resumed.progress.fileURL = download.item.progress.fileURL
            download.fail = nil
            download.item = resumed
        }
        
        @MainActor private func cancel() async {
            if let data = await download.item.cancel() {
                download.fail = .init(error: "Paused", data: data)
            }
        }
    }
}
