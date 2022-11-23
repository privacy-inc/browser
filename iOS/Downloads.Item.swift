import SwiftUI

extension Downloads {
    struct Item: View {
        @Binding var download: Download
        @State private var progress = Double()
        @State private var title = ""
        @State private var weight = ""
        @State private var finished = false
        @State private var url: URL?
        
        var body: some View {
            HStack {
                if finished {
                    if let url {
                        Text(url.lastPathComponent)
                            .font(.title3.weight(.medium))
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                            .padding(.vertical, 8)
                        
                        Divider()
                        
                        ShareLink(item: url) {
                            Image(systemName: "square.and.arrow.up")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 19, weight: .bold))
                                .contentShape(Rectangle())
                                .frame(width: 70, height: 50)
                        }
                    }
                } else {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.title3.weight(.medium))
                            .fixedSize(horizontal: false, vertical: true)
                        ProgressView(weight, value: 0.5)
                            .tint(.blue)
                            .font(.callout.monospacedDigit()).foregroundColor(.secondary)
                        
                        if let fail = download.fail {
                            Label(fail.error, systemImage: "exclamationmark.triangle.fill")
                                .imageScale(.large)
                                .font(.footnote)
                                .padding(.top, 10)
                        }
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
            .onReceive(download.item.progress.publisher(for: \.localizedAdditionalDescription)) {
                weight = $0
            }
        }
        
        private var retry: some View {
            Button {
                guard let fail = download.fail else { return }
                Task {
                    let resumed = await download.webview.resumeDownload(fromResumeData: fail.data)
                    resumed.delegate = download.webview
                    resumed.progress.fileURL = download.item.progress.fileURL
                    download.fail = nil
                }
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.system(size: 28, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.blue)
                    .contentShape(Rectangle())
                    .frame(width: 50, height: 40)
            }
        }
        
        private var pause: some View {
            Button {
                Task {
                    if let data = await download.item.cancel() {
                        download.fail = .init(error: "Paused", data: data)
                    }
                }
            } label: {
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 28, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.yellow)
                    .contentShape(Rectangle())
                    .frame(width: 50, height: 40)
            }
        }
    }
}
