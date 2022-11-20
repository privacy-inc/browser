import SwiftUI

extension Bar {
    struct Reader: View {
        let session: Session
        @State private var size = Double(1)
        
        var body: some View {
            VStack {
                HStack(spacing: 0) {
                    Button {
                        if size > 0.3 {
                            size -= 0.25
                        } else {
                            size -= 0.025
                        }
    //
    //                    Task {
    //                        await session.items[index].web!.resizeFont(size: size)
    //                    }
                    } label: {
                        Image(systemName: "textformat.size.smaller")
                            .font(.system(size: 20, weight: .semibold))
                            .contentShape(Rectangle())
                            .frame(width: 55, height: 50)
                    }
                    .foregroundStyle(size > 0.03 ? .primary : .tertiary)
                    .allowsHitTesting(size > 0.03)
                    
                    Button {
                        size = 1
    //
    //                    Task {
    //                        await session.items[index].web!.resizeFont(size: size)
    //                    }
                    } label: {
                        Text((.plain(value: .init(size * 100)) + .init("%"))
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
                                            if size < 0.25 {
                                                size = 0.25
                                            } else {
                                                size += 0.25
                                            }
                        //
                        //                    Task {
                        //                        await session.items[index].web!.resizeFont(size: size)
                        //                    }
                    } label: {
                        Image(systemName: "textformat.size.larger")
                            .font(.system(size: 20, weight: .semibold))
                            .contentShape(Rectangle())
                            .frame(width: 55, height: 50)
                    }
                    
                    .foregroundStyle(size < 15 ? .primary : .tertiary)
                    .allowsHitTesting(size < 15)
                }
                Spacer()
            }
            .presentationDetents([.height(80)])
        }
    }
}
