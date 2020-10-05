//
//  ProgressDialog.swift
//  Progress Dialog
//
//  Created by fukoapps on 30.04.2015.
//  Copyright (c) 2015 FukoApps.com. All rights reserved.
//

import UIKit
import QuartzCore
import SwiftUI

public class ProgressDialog {
    private var diaColor:UIColor;
    private var diaSize:Size;
    private var bg_Color:UIColor;
    private var bgOpacity:Float
    private var delegate: UIViewController!
    private var borderColor:UIColor!
    private var borderWidth:Float!
    private var borderRadius:Float!
    private var fill_bg:UIView!
    public var isShow: Bool!
    //Get Properties
    public func GetDialogColor() -> UIColor {
        return diaColor;
    }
    public func GetDialogBackground() -> UIColor {
        return bg_Color;
    }
    public func GetDialogSize() -> Size {
        return diaSize;
    }
    public func GetOpacity() -> Float {
        return bgOpacity;
    }
    public func GetBorderColor() -> UIColor {
        return borderColor;
    }
    public func GetBorderWidth() -> Float {
        return borderWidth;
    }
    public func GetBorderRadius() -> Float {
        return borderRadius;
    }
    //Set Properties
    public func SetDialogColor(color: UIColor) {
        self.diaColor = color
    }
    public func SetDialogBackground(color: UIColor) {
        self.bg_Color = color
    }
    public func SetDialogSize(size: Size) {
        self.diaSize = size
    }
    public func SetOpacity(opacity: Float) {
        self.bgOpacity = opacity
    }
    public func SetBorderColor(color: UIColor) {
        self.borderColor = color
    }
    public func SetBorderWidth(width: Float) {
        self.borderWidth = width
    }
    public func SetBorderRadius(radius: Float)  {
        self.borderRadius = radius
    }
    
    public init(delegate:UIViewController) {
        diaColor = UIColor.white
        diaSize = Size(width: 120, height: 120)
        bg_Color = UIColor.black
        bgOpacity = 0.85;
        borderColor = UIColor.gray
        borderWidth = 2.5
        borderRadius = 8.0;
        isShow = false;
        self.delegate = delegate
    }
    public func Show(animate:Bool, mesaj: String) {
        let sc_size = UIScreen.main.bounds;
        
        let fill_rect = CGRect(x: 0, y: 0, width: sc_size.width, height: sc_size.height);
        let bg_rect: CGRect!
        if(mesaj == "") {
            bg_rect = CGRect(x: 0, y: 0, width: diaSize.Width, height: diaSize.Height);
        } else {
            bg_rect = CGRect(x: 0, y: 0, width: diaSize.Width + 22, height: diaSize.Height + 12);
        }
        fill_bg = UIView(frame: fill_rect)
        fill_bg.backgroundColor = UIColor.clear
        let bg = UIView(frame: bg_rect);
        bg.center = CGPoint(x: fill_bg.frame.width / 2 , y: fill_bg.frame.height / 2)
        bg.backgroundColor = self.bg_Color;
        bg.alpha = CGFloat(self.bgOpacity)
        bg.layer.borderColor = self.borderColor.cgColor
        bg.layer.borderWidth = CGFloat(self.borderWidth)
        bg.layer.cornerRadius = CGFloat(self.borderRadius)
        fill_bg.addSubview(bg);
        
        
        
        let progress = UIActivityIndicatorView();
        progress.style = UIActivityIndicatorView.Style.large;
        progress.center = CGPoint(x: fill_bg.frame.size.width / 2, y: fill_bg.frame.size.height / 2)
        progress.startAnimating()
        progress.backgroundColor = diaColor;
        fill_bg.addSubview(progress)
        
        let label = UILabel()
        label.center = CGPoint(x: fill_bg.frame.size.width / 2, y: (fill_bg.frame.size.height / 2) + 5)
        label.frame = CGRect(x: 4, y: bg.frame.height - 30, width: bg.frame.width - 4, height: 30)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = mesaj
        label.textColor = UIColor.white
        bg.addSubview(label)
        if animate {
            fill_bg.alpha = 0;
        }
        delegate.view.addSubview(fill_bg)
        if animate {
            UIView.animate(withDuration: 1.5, animations: { () -> Void in
                self.fill_bg.alpha = 1.0
                self.isShow = true;
            })
        }
    }
    
    public func Close() {
            self.fill_bg.removeFromSuperview()
    }
}

public class Size {
    internal var Width:CGFloat!
    internal var Height:CGFloat!
    public init(width:CGFloat, height:CGFloat) {
        Width = width;
        Height = height
    }
}
