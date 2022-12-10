import SwiftUI

struct Forget: View {
    let session: Session
    @State private var history = 0
    @State private var trackers = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Grid(verticalSpacing: 0) {
                item(title: "Tabs", count: session.tabs.count)
                item(title: "History", count: history)
                item(title: "Downloads", count: session.downloads.count)
                item(title: "Trackers", count: trackers)
                item(title: "Cookies", count: nil)
                item(title: "Cache", count: nil)
            }
            .padding([.leading, .trailing, .top])
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Forget")
                    .font(.body.weight(.medium))
                    .padding(.horizontal, 30)
                    .padding(.vertical, 3)
            }
            .tint(.pink)
            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 15)
            
            Button("Cancel") {
                dismiss()
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .padding(.bottom, 20)
        }
        .presentationDetents([.medium])
        .onReceive(session.cloud) {
            history = $0.history.count
            trackers = $0.tracking.total
        }
    }
    
    @ViewBuilder private func item(title: String, count: Int?) -> some View {
        GridRow {
            Text(title)
                .font(.body.weight(.semibold))
                .foregroundColor(.accentColor)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .gridColumnAlignment(.leading)
            if let count {
                Text(count, format: .number)
                    .font(.init(UIFont.systemFont(
                        ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize,
                        weight: .medium,
                        width: .condensed)).monospacedDigit())
                    .foregroundColor(.pink)
                    .gridColumnAlignment(.trailing)
            } else {
                Image(systemName: "infinity")
                    .font(.body.weight(.medium))
                    .foregroundColor(.pink)
                    .gridColumnAlignment(.trailing)
            }
        }
        .padding(.vertical, 9)
        Divider()
    }
}
