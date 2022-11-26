import SwiftUI
import Engine

extension Bookmarks {
    struct Edit: View {
        @ObservedObject var session: Session
        @Binding var bookmark: Bookmark?
        @State private var title = ""
        @State private var url = ""
        @State private var fail = false
        @State private var saving = false
        @FocusState private var titleFocus: Bool
        @FocusState private var urlFocus: Bool
        @Environment(\.dismiss) private var dismiss

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
                        
                        self.bookmark = nil
                        dismiss()
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
                        bookmark = nil
                        dismiss()
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .greatestFiniteMagnitude)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .navigationTitle(bookmark == nil ? "New bookmark" : "Edit bookmark")
            .task {
                if let bookmark {
                    title = bookmark.title
                    url = bookmark.url
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}
