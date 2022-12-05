import SwiftUI

extension Bar {
    struct Encryption: View {
        let domain: String
        let secure: Bool
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack(spacing: 0) {
                Text(secure
                     ? "Privacy Browser is using an encrypted connection to \(Text(domain).bold())"
                     : "Connection to \(Text(domain).bold()) is not secure")
                .font(.callout.weight(.regular))
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
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
                    .padding(.bottom, 30)
                }
            }
            .presentationDetents([.height(160)])
        }
    }
}
