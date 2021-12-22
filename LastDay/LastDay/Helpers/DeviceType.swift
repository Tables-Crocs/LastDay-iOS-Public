//
//  DeviceType.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/12.
//

import UIKit

class DeviceType {
  static var type = 0
  
  class func getDeviceType(_ view: UIView) -> Int {
    if view.bounds.height > 810.0 {
      return 0
    } else {
      return 1
    }
  }
}
