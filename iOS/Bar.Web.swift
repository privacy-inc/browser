import SwiftUI
import Domains

extension Bar {
    struct Web: View {
        @ObservedObject var session: Session
        let webview: Webview
        @State private var url = ""
        @State private var title = ""
        @State private var domain = ""
        @State private var secure = true
        @State private var encryption = false
        @State private var trackersPrevented = 0
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            List {
                Section {
                    NavigationLink(destination: Circle()) {
                        HStack {
                            Text(trackersPrevented == 1 ? "Tracker prevented" : "Trackers prevented")
                                .font(.callout.weight(.regular))
                            
                            Spacer()
                            
                            Text("\(trackersPrevented.formatted())")
                                .font(.init(UIFont.systemFont(ofSize: 20, weight: .bold, width: .condensed)).monospacedDigit())
                                .foregroundColor(.accentColor)
                        }
                    }
                    .disabled(trackersPrevented == 0)
                }
                .listSectionSeparator(.hidden)
                .onReceive(session.cloud) {
                    trackersPrevented = $0.tracking.count(domain: domain)
                }
                
                Section("Media") {
                    
                }
                .textCase(.none)
                .listSectionSeparator(.hidden)
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    Color(.systemBackground)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Button {
                            encryption = true
                        } label: {
                            Image(systemName: secure ? "lock.fill" : "exclamationmark.triangle.fill")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.secondary)
                                .foregroundColor(secure ? .blue : .pink)
                                .contentShape(Rectangle())
                                .frame(width: 50, height: 30)
                                .padding(.top, 20)
                        }
                        .popover(isPresented: $encryption) {
                            Encryption(url: url, secure: secure)
                        }
                        
                        if !title.isEmpty {
                            Text(title)
                                .font(.body.weight(.medium))
                                .fixedSize(horizontal: false, vertical: true)
                                .textSelection(.enabled)
                                .padding(.bottom, 2)
                                .padding(.horizontal)
                        }
                        
                        Text(url)
                            .font(.footnote.weight(.regular))
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .textSelection(.enabled)
                            .padding(.horizontal)
                        
                        Divider()
                            .padding(.top, 14)
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    
                    HStack(spacing: 0) {
                        ShareLink(item: webview.url!) {
                            Image(systemName: "square.and.arrow.up")
                                .symbolRenderingMode(.hierarchical)
                                .font(.system(size: 19, weight: .bold))
                                .contentShape(Rectangle())
                                .frame(width: 70, height: 50)
                        }
                        
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 27, weight: .regular))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.secondary)
                                .contentShape(Rectangle())
                                .frame(width: 55, height: 50)
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .onReceive(webview.publisher(for: \.title)) {
                    title = $0 ?? ""
                }
                .onReceive(webview.publisher(for: \.url)) {
                    url = $0?.absoluteString ?? ""
                    domain = url.domain
                }
                .onReceive(webview.publisher(for: \.hasOnlySecureContent)) {
                    secure = $0
                }
            }
        }
    }
}
