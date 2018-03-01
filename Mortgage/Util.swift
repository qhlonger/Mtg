
//
//  Util.swift
//  Mortgage
//
//  Created by Apple on 2017/12/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class Util: NSObject {
    static func localString(key : String) -> String{
        return Bundle.main.localizedString(forKey: key, value: "", table: nil)
    }
    
    static func themeColor() -> UIColor {
        return UIColor.init(red: 1, green: 0.2, blue: 0.4, alpha: 1);
    }

    static func darkThemeColor() -> UIColor {
        return UIColor.init(red: 1, green: 0.3, blue: 0.5, alpha: 1);
    }

    static func get16Color(rgb: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
    static var topPadding: CGFloat {
        if isIpX(){
            return 45
        }
        return 30
    }
    
    static func isIpX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
    
    static func imageWith(color:UIColor)->UIImage{
        let rect = CGRect(x:0,y:0,width:1,height:1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
