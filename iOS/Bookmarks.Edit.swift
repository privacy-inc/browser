import SwiftUI
import Engine

extension Bookmarks {
    struct Edit: View {
        @ObservedObject var session: Session
        let bookmark: Bookmark?
        @State private var title = ""
        @State private var url = ""
        @FocusState private var titleFocus: Bool
        @FocusState private var urlFocus: Bool
        
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
                Section {
                    Button {
                        titleFocus = false
                        urlFocus = false
                        
                    } label: {
                        Text("Save")
                            .bold()
                            .padding(.vertical, 4)
                            .frame(maxWidth: .greatestFiniteMagnitude)
                    }
                    .buttonStyle(.borderedProminent)
                    
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
