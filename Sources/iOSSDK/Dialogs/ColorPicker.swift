//
//  File.swift
//  
//
//  Created by Marc Donaldson on 05/10/2020.
//

import Foundation
import SwiftUI


struct ColorDialogView: View {
    @Binding var isDisplayed: Bool
    @Binding var bgColor: Color
    @Binding var bgSelColor: Color
    
    public static var colorsPerRow:Int = 10

    public var action: () -> Void
    
    
    let chunkedColors = Color.baseColors.chunked(into: ColorDialogView.colorsPerRow)
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
    
    init(isDisplayed: Binding<Bool>,bgColor: Binding<Color>,bgSelColor: Binding<Color>,_ action: @escaping () -> Void)  {
        self._isDisplayed = isDisplayed
        self._bgColor = bgColor
        self._bgSelColor = bgSelColor
        self.action = action
    }
}
