import SwiftUI

extension Detail {
    struct NewTab: View {
        let session: Session
        
        var body: some View {
            Button {
                session.field.becomeFirstResponder()
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(.tertiary)
                    .foregroundColor(.secondary)
                    .contentShape(Rectangle())
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
            }
            .ignoresSafeArea(.all)
            .task {
                guard session.tabs.count > 1 else { return }
                session.field.becomeFirstResponder()
            }
        }
    }
}
