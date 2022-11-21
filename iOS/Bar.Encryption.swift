import SwiftUI

extension Bar {
    struct Encryption: View {
        let url: String
        let secure: Bool
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack(spacing: 0) {
                Text(secure
                     ? "Privacy Browser is using an encrypted connection to \(Text(url.domain).bold())"
                     : "Connection to \(Text(url.domain).bold()) is not secure")
                .font(.callout.weight(.regular))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding(20)
                
                if UIDevice.current.userInterfaceIdiom != .pad {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.callout.weight(.medium))
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .presentationDetents([.height(150)])
        }
    }
}
