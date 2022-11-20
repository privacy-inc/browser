import SwiftUI

extension AttributedString {
    static func plain(value: Int) -> Self {
        var number = Self(value.formatted())
        number.numberPart = .integer
        return number
    }
    
    static func format(value: Int, singular: String, plural: String) -> Self {
        var number = Self(value.formatted())
        number.numberPart = .integer
        return number + .init(value == 1 ? " " + singular : " " + plural)
    }
    
    func numeric(font: Font, color: Color? = nil) -> Self {
        var value = self
        value.runs.forEach { run in
            if run.numberPart != nil || run.numberSymbol != nil {
                if let color {
                    value[run.range].foregroundColor = color
                }
                value[run.range].font = font
            }
        }
        return value
    }
}
