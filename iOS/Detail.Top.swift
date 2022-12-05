import SwiftUI
import UniformTypeIdentifiers
import Engine

extension Detail {
    struct Top: View {
        let session: Session
        let id: UUID
        @State private var keyboard = false
        @State private var back = false
        @State private var forward = false
        @State private var isBookmark = false
        @State private var isReadingList = false
        @State private var more = false
        @State private var reader = false
        @State private var progress = Double()
        @State private var sharing: URL?
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        button(icon: "sidebar.left", size: 19) {
                            UIApplication.shared.hide()
                            dismiss()
                        }
                    }
                    
                    Spacer()
                    
                    if keyboard {
                        Button {
                            UIApplication.shared.hide()
                            
                            if let tab = session.tabs[id],
                               let webview = tab.webview,
                               webview.findInteraction?.isFindNavigatorVisible == true {
                                webview.findInteraction?.dismissFindNavigator()
                            }
                        } label: {
                            Text("Cancel")
                                .font(.callout)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 5)
                                .contentShape(Rectangle())
                        }
                        
                    } else if let tab = session.tabs[id],
                              let webview = tab.webview,
                              let url = webview.url {
                        options(webview: webview, url: url)
                            .onReceive(webview.publisher(for: \.canGoBack)) {
                                back = $0
                            }
                            .onReceive(webview.publisher(for: \.canGoForward)) {
                                forward = $0
                            }
                    }
                }
                
                if let tab = session.tabs[id],
                   let webview = tab.webview {
                    ZStack(alignment: .top) {
                        Rectangle()
                            .fill(Color.primary.opacity(0.1))
                        Progress(value: progress)
                            .stroke(Color.accentColor, style: .init(lineWidth: 2))
                            .frame(height: 2)
                    }
                    .frame(height: 3)
                    .onReceive(webview.publisher(for: \.estimatedProgress)) {
                        progress = $0
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                keyboard = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboard = false
            }
            .sheet(isPresented: $more) {
                More(session: session)
            }
            .popover(isPresented: $reader) {
                Reader(session: session)
            }
            .popover(isPresented: .init(
                get: { sharing != nil },
                set: { if !$0 { sharing = nil } })) {
                Sharing(item: sharing ?? .init(filePath: ""))
            }
        }
        
        @ViewBuilder @MainActor private func options(webview: Webview, url: URL) -> some View {
            button(icon: "chevron.backward", disabled: !back) {
                UIApplication.shared.hide()
                webview.goBack()
            }
            
            button(icon: "chevron.forward", disabled: !forward) {
                UIApplication.shared.hide()
                webview.goForward()
            }
            
            ShareLink(item: url) {
                image(icon: "square.and.arrow.up")
            }
            
            Menu {
                menu(webview: webview, url: url)
            } label: {
                image(icon: "slider.horizontal.3")
            }
        }
        
        @ViewBuilder @MainActor private func menu(webview: Webview, url: URL) -> some View {
            element(title: "Bookmark",
                    icon: isBookmark ? "bookmark.fill" : "bookmark") {
                Task {
                    if isBookmark {
                        await session.cloud.delete(bookmark: url.absoluteString)
                    } else {
                        guard
                            let bookmark = Bookmark(url: url.absoluteString,
                                                    title: webview.title ?? "")
                        else { return }
                        await session.cloud.add(bookmark: bookmark)
                    }
                }
            }
            .onReceive(session.cloud) {
                isBookmark = $0.bookmarks.contains { $0.url == url.absoluteString }
            }
            
            element(title: "Reading list",
                    icon: isReadingList ? "checkmark.circle" : "eyeglasses") {
                guard !isReadingList else { return }
                isReadingList = true
                Task {
                    await session.cloud.add(read: .init(url: url.absoluteString,
                                                        title: webview.title ?? ""))
                }
            }
            .disabled(isReadingList)
            
            Divider()
            
            element(title: "Reader", icon: "textformat.size") {
                reader = true
            }
            
            element(title: "Find on page", icon: "magnifyingglass") {
                webview.findInteraction?.presentFindNavigator(showingReplace: false)
            }
            
            Divider()
            
            Menu("Media") {
                element(title: "Full screen", icon: "arrow.up.left.and.arrow.down.right") {
                    webview.evaluateJavaScript("document.body.webkitRequestFullscreen()", completionHandler: nil)
                }
                
                element(title: "Pause all media", icon: "pause") {
                    webview.pauseAllMediaPlayback()
                }
            }
            
            Menu("Export") {
                element(title: "Download", icon: "square.and.arrow.down") {
                    sharing = url.download
                }
                
                element(title: "Print", icon: "printer") {
                    UIPrintInteractionController.shared.printFormatter = webview.viewPrintFormatter()
                    UIPrintInteractionController.shared.present(animated: true)
                }
                
                element(title: "Snapshot", icon: "text.below.photo.fill") {
                    Task {
                        guard
                            let image = try? await webview.takeSnapshot(configuration: nil),
                            let data = image.pngData()
                        else { return }
                        sharing = data.temporal(url.file("png"))
                    }
                }
                
                element(title: "PDF", icon: "doc.richtext") {
                    Task {
                        guard let data = try? await webview.pdf() else { return }
                        sharing = data.temporal(url.file("pdf"))
                    }
                }
                
                element(title: "Web archive", icon: "doc.zipper") {
                    webview
                        .createWebArchiveData {
                            guard case let .success(data) = $0 else { return }
                            sharing = data.temporal(url.file("webarchive"))
                        }
                }
                
                if let type = UTType(filenameExtension: url.absoluteString.components(separatedBy: ".").last!.lowercased()),
                   type.conforms(to: .movie) || type.conforms(to: .image) {
                    
                    Divider()
                    
                    element(title: "Add to photos", icon: "photo") {
                        Task.detached(priority: .utility) {
                            guard
                                let (data, _) = try? await URLSession(configuration: .ephemeral).data(from: url),
                                let image = UIImage(data: data)
                            else { return }
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                    }
                }
            }
            
            Divider()
            
            element(title: "Website details", icon: "ellipsis") {
                more = true
            }
        }
        
        private func button(icon: String, size: Double = 17, disabled: Bool = false, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                image(icon: icon, size: size, disabled: disabled)
            }
            .disabled(disabled)
        }
        
        private func element(title: String, icon: String, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                Label(title, systemImage: icon)
            }
        }
        
        private func image(icon: String, size: Double = 17, disabled: Bool = false) -> some View {
            Image(systemName: icon)
                .foregroundStyle(disabled ? .tertiary : .primary)
                .foregroundColor(.primary)
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: size, weight: .regular))
                .contentShape(Rectangle())
                .frame(width: 60, height: 45)
        }
    }
}
