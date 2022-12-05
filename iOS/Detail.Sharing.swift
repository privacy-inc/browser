import SwiftUI

extension Detail {
    struct Sharing: View {
        let item: URL
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack {
                Text(item.lastPathComponent)
                    .padding(.top)
                ShareLink(item: item) {
                    Image(systemName: "square.and.arrow.up.circle.fill")
                        .foregroundColor(.primary)
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 30, weight: .regular))
                        .contentShape(Rectangle())
                        .frame(width: 60, height: 45)
                }
                
                Spacer()
                
                if UIDevice.current.userInterfaceIdiom != .pad {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.callout.weight(.medium))
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom, 30)
                }
            }
            .presentationDetents([.height(200)])
        }
    }
}
