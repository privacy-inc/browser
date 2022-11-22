import SwiftUI

struct Downloads: View {
    @ObservedObject var session: Session
    
    var body: some View {
        List {
            if session.downloads.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: Category.downloads.image)
                        .font(.system(size: 60, weight: .medium))
                        .padding(.top, 60)
                    Text("No downloads")
                }
                .foregroundStyle(.secondary)
                .frame(maxWidth: .greatestFiniteMagnitude)
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
            } else {
                ForEach(session.downloads) { item in
                    Button {
                        
                    } label: {
                        Text("")
                    }
                    .swipeActions {
                        Button {
                            
                        } label: {
                            Label("Close", systemImage: "xmark.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                        }
                        .tint(.pink)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(Category.downloads.title)
    }
}