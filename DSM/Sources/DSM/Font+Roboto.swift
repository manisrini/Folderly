// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public enum Roboto : String,CaseIterable{
    case Black = "Roboto-Black"
    case BlackItalic = "Roboto-BlackItalic"
    case Bold = "Roboto-Bold"
    case BoldItalic = "Roboto-BoldItalic"
    case Italic = "Roboto-Italic"
    case Light = "Roboto-Light"
    case LightItalic = "Roboto-LightItalic"
    case Medium = "Roboto-Medium"
    case Thin = "Roboto-Thin"
    case ThinItalic = "Roboto-ThinItalic"
    case Regular = "Roboto-Regular"
}

extension Font{
    
    public static func Roboto(_ roboto : Roboto,size : CGFloat) -> Font{
        return Font.custom(roboto.rawValue, size: size,relativeTo: .body)
    }
}
