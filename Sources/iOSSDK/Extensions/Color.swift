//
//  ColorHelper.swift
//  Fantabulous
//
//  Created by Marc Donaldson on 29/09/2020.
//
import Foundation
import SwiftUI
import UIKit

public extension UIColor {

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

public extension Color {

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
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
    
    
    public static var baseColors: [String] = [
        "000000",
        "434343",
        "666666",
        "999999",
        "b7b7b7",
        "cccccc",
        "d9d9d9",
        "efefef",
        "f3f3f3",
        "ffffff",
        "980000",
        "ff0000",
        "ff9900",
        "ffff00",
        "00ff00",
        "00ffff",
        "4a86e8",
        "0000ff",
        "9900ff",
        "ff00ff",
        "e6b8af",
        "f4cccc",
        "fce5cd",
        "fff2cc",
        "d9ead3",
        "d0e0e3",
        "c9daf8",
        "cfe2f3",
        "d9d2e9",
        "ead1dc",
        "dd7e6b",
        "ea9999",
        "f9cb9c",
        "ffe599",
        "b6d7a8",
        "a2c4c9",
        "a4c2f4",
        "9fc5e8",
        "b4a7d6",
        "d5a6bd",
        "cc4125",
        "e06666",
        "f6b26b",
        "ffd966",
        "93c47d",
        "76a5af",
        "6d9eeb",
        "6fa8dc",
        "8e7cc3",
        "c27ba0",
        "a61c00",
        "cc0000",
        "e69138",
        "f1c232",
        "6aa84f",
        "45818e",
        "3c78d8",
        "3d85c6",
        "674ea7",
        "a64d79",
        "85200c",
        "990000",
        "b45f06",
        "bf9000",
        "38761d",
        "134f5c",
        "1155cc",
        "0b5394",
        "351c75",
        "741b47",
        "5b0f00",
        "660000",
        "783f04",
        "7f6000",
        "274e13",
        "0c343d",
        "1c4587",
        "073763",
        "20124d",
        "4c1130"]
}


public struct ColorDialogView: View {
    @Binding var isDisplayed: Bool
    @Binding var bgColor: Color
    @Binding var bgSelColor: Color
    
    public static var colorsPerRow:Int = 10

    public var action: () -> Void
    
    
    let chunkedColors = Color.baseColors.chunked(into: colorsPerRow)
    var body: some View {
        VStack(spacing: 10) {
            Text("Select Color").font(.title)
                .foregroundColor(.black).lineSpacing(26).padding(.bottom,2).minimumScaleFactor(0.5).lineLimit(1)
            ScrollView(.vertical) {
                  ForEach(0..<chunkedColors.count) { index in
                    HStack(spacing:0) {
                        ForEach(chunkedColors[index],id: \.self) { hex in
                           
                            Button(action: {
                                let bgColor = Color.init(hex:hex)
                                self.bgColor = bgColor
                                self.bgSelColor = bgColor
                                action()
                                self.isDisplayed = false
                            }) {
                                ZStack {
                                    RoundedCorners(color:Color.init(hex: hex),tl:6,tr:6,bl:6,br:6)
                                }.padding(1).background(RoundedCorners(color:.white,tl:6,tr:6,bl:6,br:6)).frame(width:(UIScreen.screenWidth*0.75)/CGFloat(ColorDialogView.colorsPerRow),height:(UIScreen.screenWidth*0.75)/CGFloat(ColorDialogView.colorsPerRow))
                            }
                       }
                    }
                }
            }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: (UIScreen.screenWidth*0.75), minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: (UIScreen.screenWidth*0.75),alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Button(action: {
                self.isDisplayed = false
            }) {
                Text("Close")
            }
        }
        .padding()
    }
    
    init(isDisplayed: Binding<Bool>,bgColor: Binding<Color>,bgSelColor: Binding<Color>,action: @escaping () -> Void)  {
        self._isDisplayed = isDisplayed
        self._bgColor = bgColor
        self._bgSelColor = bgSelColor
        self.action = action
    }
}
