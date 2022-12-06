import SwiftUI
import UniformTypeIdentifiers

extension Detail {
    struct Export: View {
        let webview: Webview
        let url: URL
        @State private var download: URL?
        @State private var snapshot: URL?
        @State private var pdf: URL?
        @State private var webarchive: URL?
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationStack {
                List {
                    Section {
                        Button {
                            UIPrintInteractionController.shared.printFormatter = webview.viewPrintFormatter()
                            UIPrintInteractionController.shared.present(animated: true)
                        } label: {
                            element(title: "Print", icon: "printer")
                        }
                    }
                    
                    Section {
                        if let download {
                            ShareLink(item: download) {
                                element(title: "Download", icon: "square.and.arrow.down")
                            }
                        }
                        
                        if let snapshot {
                            ShareLink(item: snapshot) {
                                element(title: "Snapshot", icon: "text.below.photo.fill")
                            }
                        }
                        
                        if let pdf {
                            ShareLink(item: pdf) {
                                element(title: "PDF", icon: "doc.richtext")
                            }
                        }
                        
                        if let webarchive {
                            ShareLink(item: webarchive) {
                                element(title: "Web archive", icon: "doc.zipper")
                            }
                        }
                    }
                    
                    if let type = UTType(filenameExtension: url
                        .absoluteString
                        .components(separatedBy: ".")
                        .last!
                        .lowercased()),
                       type.conforms(to: .movie) || type.conforms(to: .image) {
                        
                        Section {
                            Button {
                                Task.detached(priority: .utility) {
                                    guard
                                        let (data, _) = try? await URLSession.shared.data(from: url),
                                        let image = UIImage(data: data)
                                    else { return }
                                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                }
                            } label: {
                                element(title: "Add to photos", icon: "photo")
                            }
                        }
                    }
                }
                .navigationTitle("Export")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
            .presentationDetents([.medium])
            .task {
                download = url.download
                
                if let image = try? await webview.takeSnapshot(configuration: nil),
                   let data = image.pngData() {
                    snapshot = data.temporal(url.file("png"))
                }
                
                if let data = try? await webview.pdf() {
                    pdf = data.temporal(url.file("pdf"))
                }
                
                webview
                    .createWebArchiveData {
                        if case let .success(data) = $0 {
                            webarchive = data.temporal(url.file("webarchive"))
                        }
                    }
            }
        }
        
        private func element(title: String, icon: String) -> some View {
            HStack {
                Text(title)
                    .font(.callout)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .regular))
                    .symbolRenderingMode(.multicolor)
                    .frame(width: 30, height: 28)
            }
        }
    }
}
