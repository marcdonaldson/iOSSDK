//
//  ColorHelper.swift
//  Fantabulous
//
//  Created by Marc Donaldson on 29/09/2020.
//

import SwiftUI
import UIKit

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }

    var suColor: Color { Color(self) }

}

extension Color {

    func uiColor() -> UIColor {

        let components = self.components()
        return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
    }

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {

        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}

extension Color {
    
    func baseColors -> [String] {
        
        var colors: [String] = []
        
        colors.append("000000")
        colors.append("434343")
        colors.append("666666")
        colors.append("999999")
        colors.append("b7b7b7")
        colors.append("cccccc")
        colors.append("d9d9d9")
        colors.append("efefef")
        colors.append("f3f3f3")
        colors.append("ffffff")
        colors.append("980000")
        colors.append("ff0000")
        colors.append("ff9900")
        colors.append("ffff00")
        colors.append("00ff00")
        colors.append("00ffff")
        colors.append("4a86e8")
        colors.append("0000ff")
        colors.append("9900ff")
        colors.append("ff00ff")
        colors.append("e6b8af")
        colors.append("f4cccc")
        colors.append("fce5cd")
        colors.append("fff2cc")
        colors.append("d9ead3")
        colors.append("d0e0e3")
        colors.append("c9daf8")
        colors.append("cfe2f3")
        colors.append("d9d2e9")
        colors.append("ead1dc")
        colors.append("dd7e6b")
        colors.append("ea9999")
        colors.append("f9cb9c")
        colors.append("ffe599")
        colors.append("b6d7a8")
        colors.append("a2c4c9")
        colors.append("a4c2f4")
        colors.append("9fc5e8")
        colors.append("b4a7d6")
        colors.append("d5a6bd")
        colors.append("cc4125")
        colors.append("e06666")
        colors.append("f6b26b")
        colors.append("ffd966")
        colors.append("93c47d")
        colors.append("76a5af")
        colors.append("6d9eeb")
        colors.append("6fa8dc")
        colors.append("8e7cc3")
        colors.append("c27ba0")
        colors.append("a61c00")
        colors.append("cc0000")
        colors.append("e69138")
        colors.append("f1c232")
        colors.append("6aa84f")
        colors.append("45818e")
        colors.append("3c78d8")
        colors.append("3d85c6")
        colors.append("674ea7")
        colors.append("a64d79")
        colors.append("85200c")
        colors.append("990000")
        colors.append("b45f06")
        colors.append("bf9000")
        colors.append("38761d")
        colors.append("134f5c")
        colors.append("1155cc")
        colors.append("0b5394")
        colors.append("351c75")
        colors.append("741b47")
        colors.append("5b0f00")
        colors.append("660000")
        colors.append("783f04")
        colors.append("7f6000")
        colors.append("274e13")
        colors.append("0c343d")
        colors.append("1c4587")
        colors.append("073763")
        colors.append("20124d")
        colors.append("4c1130")
        return(colors)
    }
    
}
