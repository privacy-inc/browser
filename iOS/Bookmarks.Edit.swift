import SwiftUI
import Engine

extension Bookmarks {
    struct Edit: View {
        @ObservedObject var session: Session
        let bookmark: Bookmark?
        @State private var title: String
        @State private var url: String
        @State private var fail = false
        @State private var saving = false
        @FocusState private var titleFocus: Bool
        @FocusState private var urlFocus: Bool
        @Environment(\.dismiss) private var dismiss
        
        init(session: Session, bookmark: Bookmark?) {
            self.session = session
            self.bookmark = bookmark
            _title = .init(initialValue: bookmark?.title ?? "")
            _url = .init(initialValue: bookmark?.url ?? "")
        }
        
        var body: some View {
            Form {
                Section {
                    TextField("Title", text: $title)
                        .focused($titleFocus)
                        .submitLabel(.next)
                        .onSubmit {
                            guard url.isEmpty else { return }
                            urlFocus = true
                        }
                    TextField("URL", text: $url)
                        .focused($urlFocus)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .submitLabel(.next)
                        .onSubmit {
                            guard title.isEmpty else { return }
                            titleFocus = true
                        }
                }
                
                if fail {
                    Section {
                        Label("Invalid URL", systemImage: "exclamationmark.triangle.fill")
                            .font(.callout.bold())
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.pink)
                }
                
                Section {
                    Button {
                        saving = true
                        titleFocus = false
                        urlFocus = false
                        guard
                            let bookmark = Bookmark(url: url, title: title)
                        else {
                            fail = true
                            saving = false
                            return
                        }
                        
                        if let url = self.bookmark?.url {
                            Task {
                                await session.cloud.update(bookmark: bookmark, for: url)
                            }
                        } else {
                            Task {
                                await session.cloud.add(bookmark: bookmark)
                            }
                        }
                        
                        dismiss()
                        session.content = nil
                        
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            session.columns = .all
                        }
                    } label: {
                        Text("Save")
                            .bold()
                            .padding(.vertical, 4)
                            .frame(maxWidth: .greatestFiniteMagnitude)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(saving)
                    
                    Button("Cancel") {
                        titleFocus = false
                        urlFocus = false
                        session.content = nil
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .greatestFiniteMagnitude)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .navigationTitle(bookmark == nil ? "New bookmark" : "Edit bookmark")
        }
    }
}
