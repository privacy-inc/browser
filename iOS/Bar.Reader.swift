import SwiftUI

extension Bar {
    struct Reader: View {
        let session: Session
        @AppStorage("font") private var size = Int(100)
        
        var body: some View {
            VStack {
                HStack(spacing: 0) {
                    Button {
                        if size > 30 {
                            size -= 25
                        } else {
                            size -= 2
                        }
                    } label: {
                        Image(systemName: "textformat.size.smaller")
                            .font(.system(size: 20, weight: .semibold))
                            .contentShape(Rectangle())
                            .frame(width: 55, height: 50)
                    }
                    .foregroundStyle(size > 3 ? .primary : .tertiary)
                    .allowsHitTesting(size > 3)
                    
                    Button {
                        size = 100
                    } label: {
                        Text((.plain(value: size) + .init("%"))
                            .numeric(font: .init(UIFont.systemFont(ofSize: 20, weight: .bold, width: .condensed)).monospacedDigit(), color: .accentColor))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                        .padding(2)
                        .contentShape(Rectangle())
                        .frame(minWidth: 64)
                    }
                    .foregroundColor(.primary)
                    .buttonStyle(.bordered)
                    .padding(.vertical, 15)
                    
                    Button {
                        if size < 25 {
                            size = 25
                        } else {
                            size += 25
                        }
                    } label: {
                        Image(systemName: "textformat.size.larger")
                            .font(.system(size: 20, weight: .semibold))
                            .contentShape(Rectangle())
                            .frame(width: 55, height: 50)
                    }
                    .foregroundStyle(size < 1500 ? .primary : .tertiary)
                    .allowsHitTesting(size < 1500)
                }
                Spacer()
            }
            .presentationDetents([.height(80)])
        }
    }
}
