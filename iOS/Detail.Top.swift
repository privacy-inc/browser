import SwiftUI
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
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        button(icon: "sidebar.left") {
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
        }
        
        @ViewBuilder @MainActor private func options(webview: Webview, url: URL) -> some View {
            button(icon: "chevron.backward", disabled: !back) {
                UIApplication.shared.hide()
                webview.goBack()
            }
            .onReceive(webview.publisher(for: \.canGoBack)) {
                back = $0
            }
            
            button(icon: "chevron.forward", disabled: !forward) {
                UIApplication.shared.hide()
                webview.goForward()
            }
            .onReceive(webview.publisher(for: \.canGoForward)) {
                forward = $0
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
            
            extra(webview: webview, url: url)
            
            element(title: "Website details", icon: "ellipsis") {
                more = true
            }
            
            Menu("Export as...") {
                element(title: "Download", icon: "square.and.arrow.down") {
                    more = true
                }
                
                element(title: "Print", icon: "printer") {
                    more = true
                }
                
                element(title: "Snapshot", icon: "text.below.photo.fill") {
                    more = true
                }
                
                element(title: "PDF", icon: "doc.richtext") {
                    more = true
                }
                
                element(title: "Web archive", icon: "doc.zipper") {
                    more = true
                }
                
                if true {
                    Divider()
                    
                    element(title: "Add to photos", icon: "photo") {
                        more = true
                    }
                }
            }
        }
        
        @ViewBuilder @MainActor private func extra(webview: Webview, url: URL) -> some View {
            Divider()
            
            element(title: "Full screen", icon: "arrow.up.left.and.arrow.down.right") {
                webview.evaluateJavaScript("canvas.webkitRequestFullscreen()", completionHandler: nil)
            }
            
            element(title: "Pause all media", icon: "pause") {
                more = true
            }
            
            element(title: "Allow text selection", icon: "selection.pin.in.out") {
                more = true
            }
            
            Divider()
        }
        
        private func button(icon: String, disabled: Bool = false, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                image(icon: icon, disabled: disabled)
            }
            .disabled(disabled)
        }
        
        private func element(title: String, icon: String, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                Label(title, systemImage: icon)
            }
        }
        
        private func image(icon: String, disabled: Bool = false) -> some View {
            Image(systemName: icon)
                .foregroundStyle(disabled ? .tertiary : .primary)
                .foregroundColor(.primary)
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 17, weight: .regular))
                .contentShape(Rectangle())
                .frame(width: 60, height: 45)
        }
    }
}
