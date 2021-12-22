//
//  UIColor+Extension.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/13.
//

import UIKit

extension UIColor {
  static func by(r: Int, g: Int, b: Int, a: CGFloat = 1) -> UIColor {
    let d = CGFloat(255)
    return UIColor(red: CGFloat(r) / d, green: CGFloat(g) / d, blue: CGFloat(b) / d, alpha: a)
  }
  
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }
  
  static var mainTintColor: UIColor = UIColor.init(rgb: 0xC2BBFF)
  static var kakaoColor =  UIColor(red: 254/255.0, green: 229/255.0, blue: 0/255.0, alpha: 1.0)
  static var lightBlackColor = UIColor(red: 25/255.0, green: 25/255.0, blue: 25/255.0, alpha: 1.0)
  static var yellowColor = UIColor(red: 254/255.0, green: 240/255.0, blue: 10/255.0, alpha: 1.0)
  static var lightGrayBorderColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)


}


